/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements. See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership. The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.apache.fineract.portfolio.loanaccount.service;

import static org.apache.fineract.portfolio.loanaccount.domain.Loan.ACTUAL_DISBURSEMENT_DATE;

import java.math.BigDecimal;
import java.time.LocalDate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.fineract.infrastructure.configuration.service.TemporaryConfigurationServiceContainer;
import org.apache.fineract.infrastructure.core.api.JsonCommand;
import org.apache.fineract.infrastructure.core.domain.ExternalId;
import org.apache.fineract.infrastructure.core.service.DateUtils;
import org.apache.fineract.infrastructure.core.service.MathUtil;
import org.apache.fineract.infrastructure.event.business.domain.loan.LoanBalanceChangedBusinessEvent;
import org.apache.fineract.infrastructure.event.business.domain.loan.transaction.LoanTransactionDownPaymentPostBusinessEvent;
import org.apache.fineract.infrastructure.event.business.domain.loan.transaction.LoanTransactionDownPaymentPreBusinessEvent;
import org.apache.fineract.infrastructure.event.business.service.BusinessEventNotifierService;
import org.apache.fineract.organisation.monetary.domain.Money;
import org.apache.fineract.portfolio.loanaccount.data.HolidayDetailDTO;
import org.apache.fineract.portfolio.loanaccount.data.ScheduleGeneratorDTO;
import org.apache.fineract.portfolio.loanaccount.domain.ChangedTransactionDetail;
import org.apache.fineract.portfolio.loanaccount.domain.Loan;
import org.apache.fineract.portfolio.loanaccount.domain.LoanEvent;
import org.apache.fineract.portfolio.loanaccount.domain.LoanLifecycleStateMachine;
import org.apache.fineract.portfolio.loanaccount.domain.LoanRepaymentScheduleInstallment;
import org.apache.fineract.portfolio.loanaccount.domain.LoanTransaction;
import org.apache.fineract.portfolio.loanaccount.domain.LoanTransactionRepository;
import org.apache.fineract.portfolio.loanaccount.domain.transactionprocessor.LoanRepaymentScheduleTransactionProcessor;
import org.apache.fineract.portfolio.loanaccount.domain.transactionprocessor.MoneyHolder;
import org.apache.fineract.portfolio.loanaccount.domain.transactionprocessor.TransactionCtx;
import org.apache.fineract.portfolio.loanaccount.exception.InvalidLoanStateTransitionException;
import org.apache.fineract.portfolio.loanaccount.exception.InvalidLoanTransactionTypeException;
import org.apache.fineract.portfolio.loanaccount.loanschedule.domain.LoanScheduleType;
import org.apache.fineract.portfolio.loanaccount.serialization.LoanDownPaymentTransactionValidator;
import org.apache.fineract.portfolio.loanaccount.serialization.LoanRefundValidator;

@Slf4j
@RequiredArgsConstructor
public class LoanDownPaymentHandlerServiceImpl implements LoanDownPaymentHandlerService {

    private final LoanTransactionRepository loanTransactionRepository;
    private final BusinessEventNotifierService businessEventNotifierService;
    private final LoanDownPaymentTransactionValidator loanDownPaymentTransactionValidator;
    private final LoanScheduleService loanScheduleService;
    private final LoanRefundService loanRefundService;
    private final LoanRefundValidator loanRefundValidator;

    @Override
    public LoanTransaction handleDownPayment(ScheduleGeneratorDTO scheduleGeneratorDTO, JsonCommand command,
            LoanTransaction disbursementTransaction, Loan loan) {
        businessEventNotifierService.notifyPreBusinessEvent(new LoanTransactionDownPaymentPreBusinessEvent(loan));
        LoanTransaction downPaymentTransaction = handleDownPayment(loan, disbursementTransaction, command, scheduleGeneratorDTO);
        if (downPaymentTransaction != null) {
            downPaymentTransaction = loanTransactionRepository.saveAndFlush(downPaymentTransaction);
            businessEventNotifierService.notifyPostBusinessEvent(new LoanTransactionDownPaymentPostBusinessEvent(downPaymentTransaction));
            businessEventNotifierService.notifyPostBusinessEvent(new LoanBalanceChangedBusinessEvent(loan));
        }
        return downPaymentTransaction;
    }

    @Override
    public ChangedTransactionDetail handleRepaymentOrRecoveryOrWaiverTransaction(final Loan loan, final LoanTransaction loanTransaction,
            final LoanLifecycleStateMachine loanLifecycleStateMachine, final LoanTransaction adjustedTransaction,
            final ScheduleGeneratorDTO scheduleGeneratorDTO) {
        ChangedTransactionDetail changedTransactionDetail = null;

        if (loanTransaction.isRecoveryRepayment()) {
            loanLifecycleStateMachine.transition(LoanEvent.LOAN_RECOVERY_PAYMENT, loan);
        }

        if (loanTransaction.isRecoveryRepayment()
                && loanTransaction.getAmount(loan.getCurrency()).getAmount().compareTo(loan.getSummary().getTotalWrittenOff()) > 0) {
            final String errorMessage = "The transaction amount cannot greater than the remaining written off amount.";
            throw new InvalidLoanStateTransitionException("transaction", "cannot.be.greater.than.total.written.off", errorMessage);
        }

        loanTransaction.updateLoan(loan);

        final boolean isTransactionChronologicallyLatest = loan.isChronologicallyLatestRepaymentOrWaiver(loanTransaction);

        if (loanTransaction.isNotZero()) {
            loan.addLoanTransaction(loanTransaction);
        }

        if (loanTransaction.isNotRepaymentLikeType() && loanTransaction.isNotWaiver() && loanTransaction.isNotRecoveryRepayment()) {
            final String errorMessage = "A transaction of type repayment or recovery repayment or waiver was expected but not received.";
            throw new InvalidLoanTransactionTypeException("transaction", "is.not.a.repayment.or.waiver.or.recovery.transaction",
                    errorMessage);
        }

        final LocalDate loanTransactionDate = loanRefundService.extractTransactionDate(loan, loanTransaction);

        if (DateUtils.isDateInTheFuture(loanTransactionDate)) {
            final String errorMessage = "The transaction date cannot be in the future.";
            throw new InvalidLoanStateTransitionException("transaction", "cannot.be.a.future.date", errorMessage, loanTransactionDate);
        }

        if (loanTransaction.isInterestWaiver()) {
            Money totalInterestOutstandingOnLoan = loan.getTotalInterestOutstandingOnLoan();
            if (adjustedTransaction != null) {
                totalInterestOutstandingOnLoan = totalInterestOutstandingOnLoan.plus(adjustedTransaction.getAmount(loan.loanCurrency()));
            }
            if (loanTransaction.getAmount(loan.getCurrency()).isGreaterThan(totalInterestOutstandingOnLoan)) {
                final String errorMessage = "The amount of interest to waive cannot be greater than total interest outstanding on loan.";
                throw new InvalidLoanStateTransitionException("waive.interest", "amount.exceeds.total.outstanding.interest", errorMessage,
                        loanTransaction.getAmount(loan.getCurrency()), totalInterestOutstandingOnLoan.getAmount());
            }
        }

        loanRefundValidator.validateTransactionAmountThreshold(loan, adjustedTransaction);

        final LoanRepaymentScheduleTransactionProcessor loanRepaymentScheduleTransactionProcessor = loan.getTransactionProcessor();

        final LoanRepaymentScheduleInstallment currentInstallment = loan
                .fetchLoanRepaymentScheduleInstallmentByDueDate(loanTransaction.getTransactionDate());

        boolean reprocess = loan.isForeclosure() || !isTransactionChronologicallyLatest || adjustedTransaction != null
                || !DateUtils.isEqualBusinessDate(loanTransaction.getTransactionDate()) || currentInstallment == null
                || !currentInstallment.getTotalOutstanding(loan.getCurrency()).isEqualTo(loanTransaction.getAmount(loan.getCurrency()));

        if (isTransactionChronologicallyLatest && adjustedTransaction == null
                && (!reprocess || !loan.repaymentScheduleDetail().isInterestRecalculationEnabled()) && !loan.isForeclosure()) {
            loanRepaymentScheduleTransactionProcessor.processLatestTransaction(loanTransaction,
                    new TransactionCtx(loan.getCurrency(), loan.getRepaymentScheduleInstallments(), loan.getActiveCharges(),
                            new MoneyHolder(loan.getTotalOverpaidAsMoney()), null));
            reprocess = false;
            if (loan.repaymentScheduleDetail().isInterestRecalculationEnabled()) {
                if (currentInstallment == null || currentInstallment.isNotFullyPaidOff()) {
                    reprocess = true;
                } else {
                    final LoanRepaymentScheduleInstallment nextInstallment = loan
                            .fetchRepaymentScheduleInstallment(currentInstallment.getInstallmentNumber() + 1);
                    if (nextInstallment != null && nextInstallment.getTotalPaidInAdvance(loan.getCurrency()).isGreaterThanZero()) {
                        reprocess = true;
                    }
                }
            }
        }
        if (reprocess) {
            if (loan.repaymentScheduleDetail().isInterestRecalculationEnabled()
                    && !loan.getLoanProductRelatedDetail().getLoanScheduleType().equals(LoanScheduleType.PROGRESSIVE)) {
                loanScheduleService.regenerateRepaymentScheduleWithInterestRecalculation(loan, scheduleGeneratorDTO);
            } else if (loan.getLoanProductRelatedDetail() != null
                    && loan.getLoanProductRelatedDetail().getLoanScheduleType().equals(LoanScheduleType.PROGRESSIVE)
                    && loan.getLoanTransactions().stream().anyMatch(LoanTransaction::isChargeOff)) {
                loanScheduleService.regenerateRepaymentSchedule(loan, scheduleGeneratorDTO);
            }
            changedTransactionDetail = loan.reprocessTransactions();
        }

        loan.updateLoanSummaryDerivedFields();

        /**
         * FIXME: Vishwas, skipping post loan transaction checks for Loan recoveries
         **/
        if (loanTransaction.isNotRecoveryRepayment()) {
            loan.doPostLoanTransactionChecks(loanTransaction.getTransactionDate(), loanLifecycleStateMachine);
        }

        if (loan.getLoanProduct().isMultiDisburseLoan()) {
            final BigDecimal totalDisbursed = loan.getDisbursedAmount();
            final BigDecimal totalPrincipalAdjusted = loan.getSummary().getTotalPrincipalAdjustments();
            final BigDecimal totalPrincipalCredited = totalDisbursed.add(totalPrincipalAdjusted);
            if (totalPrincipalCredited.compareTo(loan.getSummary().getTotalPrincipalRepaid()) < 0
                    && loan.repaymentScheduleDetail().getPrincipal().minus(totalDisbursed).isGreaterThanZero()) {
                final String errorMessage = "The transaction amount cannot exceed threshold.";
                throw new InvalidLoanStateTransitionException("transaction", "amount.exceeds.threshold", errorMessage);
            }
        }

        return changedTransactionDetail;
    }

    private LoanTransaction handleDownPayment(final Loan loan, final LoanTransaction disbursementTransaction, final JsonCommand command,
            final ScheduleGeneratorDTO scheduleGeneratorDTO) {
        final LocalDate disbursedOn = command.localDateValueOfParameterNamed(ACTUAL_DISBURSEMENT_DATE);
        final BigDecimal disbursedAmountPercentageForDownPayment = loan.getLoanRepaymentScheduleDetail()
                .getDisbursedAmountPercentageForDownPayment();
        ExternalId externalId = ExternalId.empty();
        if (TemporaryConfigurationServiceContainer.isExternalIdAutoGenerationEnabled()) {
            externalId = ExternalId.generate();
        }
        Money downPaymentMoney = Money.of(loan.getCurrency(),
                MathUtil.percentageOf(disbursementTransaction.getAmount(), disbursedAmountPercentageForDownPayment, 19));
        if (loan.getLoanProduct().getInstallmentAmountInMultiplesOf() != null) {
            downPaymentMoney = Money.roundToMultiplesOf(downPaymentMoney, loan.getLoanProduct().getInstallmentAmountInMultiplesOf());
        }
        final Money adjustedDownPaymentMoney = switch (loan.getLoanProductRelatedDetail().getLoanScheduleType()) {
            // For Cumulative loan: To check whether the loan was overpaid when the disbursement happened and to get the
            // proper amount after the disbursement we are using two balances:
            // 1. Whether the loan is still overpaid after the disbursement,
            // 2. if the loan is not overpaid anymore after the disbursement, but was it more overpaid than the
            // calculated down-payment amount?
            case CUMULATIVE -> {
                if (loan.getTotalOverpaidAsMoney().isGreaterThanZero()) {
                    yield Money.zero(loan.getCurrency());
                }
                yield MathUtil.negativeToZero(downPaymentMoney.minus(MathUtil.negativeToZero(disbursementTransaction
                        .getAmount(loan.getCurrency()).minus(disbursementTransaction.getOutstandingLoanBalanceMoney(loan.getCurrency())))));
            }
            // For Progressive loan: Disbursement transaction portion balances are enough to see whether the overpayment
            // amount was more than the calculated down-payment amount
            case PROGRESSIVE ->
                MathUtil.negativeToZero(downPaymentMoney.minus(disbursementTransaction.getOverPaymentPortion(loan.getCurrency())));
        };

        if (adjustedDownPaymentMoney.isGreaterThanZero()) {
            final LoanTransaction downPaymentTransaction = LoanTransaction.downPayment(loan.getOffice(), adjustedDownPaymentMoney, null,
                    disbursedOn, externalId);
            final LoanEvent event = LoanEvent.LOAN_REPAYMENT_OR_WAIVER;
            loanDownPaymentTransactionValidator.validateRepaymentTypeAccountStatus(loan, downPaymentTransaction, event);
            final HolidayDetailDTO holidayDetailDTO = scheduleGeneratorDTO.getHolidayDetailDTO();
            loanDownPaymentTransactionValidator.validateRepaymentDateIsOnHoliday(downPaymentTransaction.getTransactionDate(),
                    holidayDetailDTO.isAllowTransactionsOnHoliday(), holidayDetailDTO.getHolidays());
            loanDownPaymentTransactionValidator.validateRepaymentDateIsOnNonWorkingDay(downPaymentTransaction.getTransactionDate(),
                    holidayDetailDTO.getWorkingDays(), holidayDetailDTO.isAllowTransactionsOnNonWorkingDay());

            handleRepaymentOrRecoveryOrWaiverTransaction(loan, downPaymentTransaction, loan.getLoanLifecycleStateMachine(), null,
                    scheduleGeneratorDTO);
            return downPaymentTransaction;
        } else {
            return null;
        }
    }
}
