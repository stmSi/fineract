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
package org.apache.fineract.test.initializer.global;

import static org.apache.fineract.test.data.TransactionProcessingStrategyCode.ADVANCED_PAYMENT_ALLOCATION;
import static org.apache.fineract.test.factory.LoanProductsRequestFactory.INTEREST_RATE_FREQUENCY_TYPE_WHOLE_TERM;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import lombok.RequiredArgsConstructor;
import org.apache.fineract.client.models.AdvancedPaymentData;
import org.apache.fineract.client.models.ChargeData;
import org.apache.fineract.client.models.CreditAllocationData;
import org.apache.fineract.client.models.CreditAllocationOrder;
import org.apache.fineract.client.models.LoanProductPaymentAllocationRule;
import org.apache.fineract.client.models.PaymentAllocationOrder;
import org.apache.fineract.client.models.PostLoanProductsRequest;
import org.apache.fineract.client.models.PostLoanProductsResponse;
import org.apache.fineract.client.services.LoanProductsApi;
import org.apache.fineract.test.data.AdvancePaymentsAdjustmentType;
import org.apache.fineract.test.data.ChargeProductType;
import org.apache.fineract.test.data.DaysInMonthType;
import org.apache.fineract.test.data.DaysInYearType;
import org.apache.fineract.test.data.InterestCalculationPeriodTime;
import org.apache.fineract.test.data.RecalculationRestFrequencyType;
import org.apache.fineract.test.data.TransactionProcessingStrategyCode;
import org.apache.fineract.test.data.loanproduct.DefaultLoanProduct;
import org.apache.fineract.test.factory.LoanProductsRequestFactory;
import org.apache.fineract.test.support.TestContext;
import org.apache.fineract.test.support.TestContextKey;
import org.springframework.stereotype.Component;
import retrofit2.Response;

@RequiredArgsConstructor
@Component
public class LoanProductGlobalInitializerStep implements FineractGlobalInitializerStep {

    private final LoanProductsApi loanProductsApi;
    private final LoanProductsRequestFactory loanProductsRequestFactory;

    @Override
    public void initialize() throws Exception {
        // LP1
        String name = DefaultLoanProduct.LP1.getName();
        PostLoanProductsRequest loanProductsRequest = loanProductsRequestFactory.defaultLoanProductsRequestLP1().name(name);
        Response<PostLoanProductsResponse> response = loanProductsApi.createLoanProduct(loanProductsRequest).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1, response);

        // LP1 product with due date and overdue date for repayment in config
        // (LP1_DUE_DATE)
        PostLoanProductsRequest loanProductsRequestDueDate = loanProductsRequestFactory.defaultLoanProductsRequestLP1()//
                .name(DefaultLoanProduct.LP1_DUE_DATE.getName())//
                .dueDaysForRepaymentEvent(3)//
                .overDueDaysForRepaymentEvent(3);//
        Response<PostLoanProductsResponse> responseDueDate = loanProductsApi.createLoanProduct(loanProductsRequestDueDate).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_DUE_DATE, responseDueDate);

        // LP1 with 12% FLAT interest
        // (LP1_INTEREST_FLAT)
        String name2 = DefaultLoanProduct.LP1_INTEREST_FLAT.getName();
        PostLoanProductsRequest loanProductsRequestInterestFlat = loanProductsRequestFactory.defaultLoanProductsRequestLP1InterestFlat()
                .name(name2);
        Response<PostLoanProductsResponse> responseInterestFlat = loanProductsApi.createLoanProduct(loanProductsRequestInterestFlat)
                .execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_INTEREST_FLAT, responseInterestFlat);

        // LP1 with 12% DECLINING BALANCE interest, interest period: Same as payment period
        // (LP1_INTEREST_DECLINING_BALANCE_PERIOD_SAME_AS_PAYMENT)
        String name3 = DefaultLoanProduct.LP1_INTEREST_DECLINING_BALANCE_PERIOD_SAME_AS_PAYMENT.getName();
        PostLoanProductsRequest loanProductsRequestInterestDecliningPeriodSameAsPayment = loanProductsRequestFactory
                .defaultLoanProductsRequestLP1InterestDeclining().name(name3);
        Response<PostLoanProductsResponse> responseInterestDecliningPeriodSameAsPayment = loanProductsApi
                .createLoanProduct(loanProductsRequestInterestDecliningPeriodSameAsPayment).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_INTEREST_DECLINING_PERIOD_SAME_AS_PAYMENT,
                responseInterestDecliningPeriodSameAsPayment);

        // LP1 with 12% DECLINING BALANCE interest, interest period: Daily
        // (LP1_INTEREST_DECLINING_BALANCE_PERIOD_DAILY)
        String name4 = DefaultLoanProduct.LP1_INTEREST_DECLINING_BALANCE_PERIOD_DAILY.getName();
        PostLoanProductsRequest loanProductsRequestInterestDecliningPeriodDaily = loanProductsRequestFactory
                .defaultLoanProductsRequestLP1InterestDeclining().name(name4)
                .interestCalculationPeriodType(InterestCalculationPeriodTime.DAILY.value).allowPartialPeriodInterestCalcualtion(false);
        Response<PostLoanProductsResponse> responseInterestDecliningPeriodDaily = loanProductsApi
                .createLoanProduct(loanProductsRequestInterestDecliningPeriodDaily).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_INTEREST_DECLINING_PERIOD_DAILY,
                responseInterestDecliningPeriodDaily);

        // LP1-1MONTH with 12% DECLINING BALANCE interest, interest period: Daily, Interest recalculation-Monthly,
        // Compounding:Interest
        // (LP1_1MONTH_INTEREST_DECLINING_BALANCE_DAILY_RECALCULATION_COMPOUNDING_MONTHLY)
        String name5 = DefaultLoanProduct.LP1_1MONTH_INTEREST_DECLINING_BALANCE_DAILY_RECALCULATION_COMPOUNDING_MONTHLY.getName();
        PostLoanProductsRequest loanProductsRequestInterestDecliningBalanceDailyRecalculationCompoundingMonthly = loanProductsRequestFactory
                .defaultLoanProductsRequestLP11MonthInterestDecliningBalanceDailyRecalculationCompoundingMonthly().name(name5);
        Response<PostLoanProductsResponse> responseInterestDecliningBalanceDailyRecalculationCompoundingMonthly = loanProductsApi
                .createLoanProduct(loanProductsRequestInterestDecliningBalanceDailyRecalculationCompoundingMonthly).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_1MONTH_INTEREST_DECLINING_BALANCE_DAILY_RECALCULATION_COMPOUNDING_MONTHLY,
                responseInterestDecliningBalanceDailyRecalculationCompoundingMonthly);

        // LP1 with 12% DECLINING BALANCE interest, interest period: Daily, Interest
        // recalculation-Daily, Compounding:none
        // (LP1_INTEREST_DECLINING_BALANCE_DAILY_RECALCULATION_COMPOUNDING_NONE)
        String name6 = DefaultLoanProduct.LP1_INTEREST_DECLINING_BALANCE_DAILY_RECALCULATION_COMPOUNDING_NONE.getName();
        PostLoanProductsRequest loanProductsRequestInterestDecliningBalanceDailyRecalculationCompoundingNone = loanProductsRequestFactory
                .defaultLoanProductsRequestLP1InterestDecliningBalanceDailyRecalculationCompoundingNone().name(name6);
        Response<PostLoanProductsResponse> responseInterestDecliningBalanceDailyRecalculationCompoundingNone = loanProductsApi
                .createLoanProduct(loanProductsRequestInterestDecliningBalanceDailyRecalculationCompoundingNone).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_INTEREST_DECLINING_BALANCE_DAILY_RECALCULATION_COMPOUNDING_NONE,
                responseInterestDecliningBalanceDailyRecalculationCompoundingNone);

        // LP1 with 12% DECLINING BALANCE interest, interest period: Daily, Interest
        // recalculation-Daily, Compounding:none, rescheduleStrategyMethod:Reduce number of installments
        // (LP1_INTEREST_DECLINING_BALANCE_DAILY_RECALCULATION_COMPOUNDING_NONE_RESCHEDULE_REDUCE_NR_INST)
        String name7 = DefaultLoanProduct.LP1_INTEREST_DECLINING_BALANCE_DAILY_RECALCULATION_COMPOUNDING_NONE_RESCHEDULE_REDUCE_NR_INST
                .getName();
        PostLoanProductsRequest loanProductsRequestInterestDecliningBalanceDailyRecalculationCompoundingNoneRescheduleReduceNrInstallments = loanProductsRequestFactory
                .defaultLoanProductsRequestLP1InterestDecliningBalanceDailyRecalculationCompoundingNone()//
                .name(name7)//
                .rescheduleStrategyMethod(AdvancePaymentsAdjustmentType.REDUCE_NUMBER_OF_INSTALLMENTS.value);//
        Response<PostLoanProductsResponse> responseInterestDecliningBalanceDailyRecalculationCompoundingNoneRescheduleReduceNrInstallments = loanProductsApi
                .createLoanProduct(
                        loanProductsRequestInterestDecliningBalanceDailyRecalculationCompoundingNoneRescheduleReduceNrInstallments)
                .execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_INTEREST_DECLINING_BALANCE_DAILY_RECALCULATION_COMPOUNDING_NONE_RESCHEDULE_REDUCE_NR_INSTALLMENTS,
                responseInterestDecliningBalanceDailyRecalculationCompoundingNoneRescheduleReduceNrInstallments);

        // LP1 with 12% DECLINING BALANCE interest, interest period: Daily, Interest
        // recalculation-Daily, Compounding:none, rescheduleStrategyMethod:Reschedule next repayments
        // (LP1_INTEREST_DECLINING_BALANCE_DAILY_RECALCULATION_COMPOUNDING_NONE_RESCHEDULE_RESCH_NEXT_REP)
        String name8 = DefaultLoanProduct.LP1_INTEREST_DECLINING_BALANCE_DAILY_RECALCULATION_COMPOUNDING_NONE_RESCHEDULE_RESCH_NEXT_REP
                .getName();
        PostLoanProductsRequest loanProductsRequestInterestDecliningBalanceDailyRecalculationCompoundingNoneRescheduleRescheduleNextRepayments = loanProductsRequestFactory
                .defaultLoanProductsRequestLP1InterestDecliningBalanceDailyRecalculationCompoundingNone()//
                .name(name8)//
                .rescheduleStrategyMethod(AdvancePaymentsAdjustmentType.RESCHEDULE_NEXT_REPAYMENTS.value);//
        Response<PostLoanProductsResponse> responseInterestDecliningBalanceDailyRecalculationCompoundingNoneRescheduleRescheduleNextRepayments = loanProductsApi
                .createLoanProduct(
                        loanProductsRequestInterestDecliningBalanceDailyRecalculationCompoundingNoneRescheduleRescheduleNextRepayments)
                .execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_INTEREST_DECLINING_BALANCE_DAILY_RECALCULATION_COMPOUNDING_NONE_RESCHEDULE_NEXT_REPAYMENTS,
                responseInterestDecliningBalanceDailyRecalculationCompoundingNoneRescheduleRescheduleNextRepayments);

        // LP1 with 12% DECLINING BALANCE interest, interest period: Daily, Interest
        // recalculation-Daily, Compounding:none, Interest Recalculation Frequency: Same as Repayment Period
        // (LP1_INTEREST_DECLINING_BALANCE_DAILY_RECALCULATION_SAME_AS_REPAYMENT_COMPOUNDING_NONE)
        String name9 = DefaultLoanProduct.LP1_INTEREST_DECLINING_BALANCE_DAILY_RECALCULATION_SAME_AS_REPAYMENT_COMPOUNDING_NONE.getName();
        PostLoanProductsRequest loanProductsRequestInterestDecliningBalanceDailyRecalculationSameAsRepaymentCompoundingNone = loanProductsRequestFactory
                .defaultLoanProductsRequestLP1InterestDecliningBalanceDailyRecalculationCompoundingNone()//
                .name(name9)//
                .recalculationRestFrequencyType(RecalculationRestFrequencyType.SAME_AS_REPAYMENT.value);//
        Response<PostLoanProductsResponse> responseInterestDecliningBalanceDailyRecalculationSameAsRepaymentCompoundingNone = loanProductsApi
                .createLoanProduct(loanProductsRequestInterestDecliningBalanceDailyRecalculationSameAsRepaymentCompoundingNone).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_INTEREST_DECLINING_BALANCE_DAILY_RECALCULATION_SAME_AS_REPAYMENT_COMPOUNDING_NONE,
                responseInterestDecliningBalanceDailyRecalculationSameAsRepaymentCompoundingNone);

        // LP1 with 12% DECLINING BALANCE interest, interest period: Daily, Interest
        // recalculation-Daily, Compounding:none, Interest Recalculation Frequency: Same as Repayment Period,
        // Multi-disbursement
        // (LP1_INTEREST_DECLINING_BALANCE_SAR_RECALCULATION_SAME_AS_REPAYMENT_COMPOUNDING_NONE_MULTIDISB)
        String name10 = DefaultLoanProduct.LP1_INTEREST_DECLINING_BALANCE_SAR_RECALCULATION_SAME_AS_REPAYMENT_COMPOUNDING_NONE_MULTIDISB
                .getName();
        PostLoanProductsRequest loanProductsRequestInterestDecliningBalanceSaRRecalculationSameAsRepaymentCompoundingNoneMultiDisbursement = loanProductsRequestFactory
                .defaultLoanProductsRequestLP1InterestDecliningBalanceDailyRecalculationCompoundingNone()//
                .name(name10)//
                .interestCalculationPeriodType(InterestCalculationPeriodTime.SAME_AS_REPAYMENT_PERIOD.value)//
                .recalculationRestFrequencyType(RecalculationRestFrequencyType.SAME_AS_REPAYMENT.value)//
                .multiDisburseLoan(true)//
                .disallowExpectedDisbursements(true)//
                .allowPartialPeriodInterestCalcualtion(true)//
                .maxTrancheCount(10)//
                .outstandingLoanBalance(10000.0);//
        Response<PostLoanProductsResponse> responseInterestDecliningBalanceSaRRecalculationSameAsRepaymentCompoundingNoneMultiDisbursement = loanProductsApi
                .createLoanProduct(
                        loanProductsRequestInterestDecliningBalanceSaRRecalculationSameAsRepaymentCompoundingNoneMultiDisbursement)
                .execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_INTEREST_DECLINING_BALANCE_SAR_RECALCULATION_SAME_AS_REPAYMENT_COMPOUNDING_NONE_MULTI_DISBURSEMENT,
                responseInterestDecliningBalanceSaRRecalculationSameAsRepaymentCompoundingNoneMultiDisbursement);

        // LP1 with new due-penalty-fee-interest-principal-in-advance-principal-penalty-fee-interest-strategy payment
        // strategy
        // (LP1_PAYMENT_STRATEGY_DUE_IN_ADVANCE)
        String name11 = DefaultLoanProduct.LP1_PAYMENT_STRATEGY_DUE_IN_ADVANCE.getName();
        PostLoanProductsRequest loanProductsRequestDueInAdvance = loanProductsRequestFactory.defaultLoanProductsRequestLP1()//
                .name(name11)//
                .transactionProcessingStrategyCode(
                        TransactionProcessingStrategyCode.DUE_PENALTY_FEE_INTEREST_PRINCIPAL_IN_ADVANCE_PRINCIPAL_PENALTY_FEE_INTEREST.value);//
        Response<PostLoanProductsResponse> responseDueInAdvance = loanProductsApi.createLoanProduct(loanProductsRequestDueInAdvance)
                .execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_PAYMENT_STRATEGY_DUE_IN_ADVANCE,
                responseDueInAdvance);

        // LP1 with new due-penalty-fee-interest-principal-in-advance-principal-penalty-fee-interest-strategy payment
        // strategy and with 12% FLAT interest
        // (LP1_PAYMENT_STRATEGY_DUE_IN_ADVANCE_INTEREST_FLAT)
        String name12 = DefaultLoanProduct.LP1_PAYMENT_STRATEGY_DUE_IN_ADVANCE_INTEREST_FLAT.getName();
        PostLoanProductsRequest loanProductsRequestDueInAdvanceInterestFlat = loanProductsRequestFactory
                .defaultLoanProductsRequestLP1InterestFlat()//
                .name(name12)//
                .transactionProcessingStrategyCode(
                        TransactionProcessingStrategyCode.DUE_PENALTY_FEE_INTEREST_PRINCIPAL_IN_ADVANCE_PRINCIPAL_PENALTY_FEE_INTEREST.value);//
        Response<PostLoanProductsResponse> responseDueInAdvanceInterestFlat = loanProductsApi
                .createLoanProduct(loanProductsRequestDueInAdvanceInterestFlat).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_PAYMENT_STRATEGY_DUE_IN_ADVANCE_INTEREST_FLAT,
                responseDueInAdvanceInterestFlat);

        // LP1 with new due-penalty-interest-principal-fee-in-advance-penalty-interest-principal-fee-strategy payment
        // strategy
        // (LP1_PAYMENT_STRATEGY_DUE_IN_ADVANCE_PENALTY_INTEREST_PRINCIPAL_FEE)
        PostLoanProductsRequest loanProductsRequestDueInAdvance2 = loanProductsRequestFactory.defaultLoanProductsRequestLP1()//
                .name(DefaultLoanProduct.LP1_PAYMENT_STRATEGY_DUE_IN_ADVANCE_PENALTY_INTEREST_PRINCIPAL_FEE.getName())//
                .transactionProcessingStrategyCode(
                        TransactionProcessingStrategyCode.DUE_PENALTY_INTEREST_PRINCIPAL_FEE_IN_ADVANCE_PENALTY_INTEREST_PRINCIPAL_FEE.value);//
        Response<PostLoanProductsResponse> responseDueInAdvance2 = loanProductsApi.createLoanProduct(loanProductsRequestDueInAdvance2)
                .execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_PAYMENT_STRATEGY_DUE_IN_ADVANCE_PENALTY_INTEREST_PRINCIPAL_FEE,
                responseDueInAdvance2);

        // LP1 with new due-penalty-interest-principal-fee-in-advance-penalty-interest-principal-fee-strategy payment
        // strategy and with 12% FLAT interest
        // (LP1_PAYMENT_STRATEGY_DUE_IN_ADVANCE_PENALTY_INTEREST_PRINCIPAL_FEE_INTEREST_FLAT)
        PostLoanProductsRequest loanProductsRequestDueInAdvanceInterestFlat2 = loanProductsRequestFactory
                .defaultLoanProductsRequestLP1InterestFlat()//
                .name(DefaultLoanProduct.LP1_PAYMENT_STRATEGY_DUE_IN_ADVANCE_PENALTY_INTEREST_PRINCIPAL_FEE_INTEREST_FLAT.getName())//
                .transactionProcessingStrategyCode(
                        TransactionProcessingStrategyCode.DUE_PENALTY_INTEREST_PRINCIPAL_FEE_IN_ADVANCE_PENALTY_INTEREST_PRINCIPAL_FEE.value);//
        Response<PostLoanProductsResponse> responseDueInAdvanceInterestFlat2 = loanProductsApi
                .createLoanProduct(loanProductsRequestDueInAdvanceInterestFlat2).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_PAYMENT_STRATEGY_DUE_IN_ADVANCE_PENALTY_INTEREST_PRINCIPAL_FEE_INTEREST_FLAT,
                responseDueInAdvanceInterestFlat2);

        // LP1 with 12% FLAT interest with % overdue fee for amount
        // (LP1_INTEREST_FLAT_OVERDUE_FROM_AMOUNT)
        String name13 = DefaultLoanProduct.LP1_INTEREST_FLAT_OVERDUE_FROM_AMOUNT.getName();
        List<ChargeData> charges = new ArrayList<>();
        charges.add(new ChargeData().id(ChargeProductType.LOAN_PERCENTAGE_LATE_FEE.value));
        PostLoanProductsRequest loanProductsRequestInterestFlatOverdueFeeAmount = loanProductsRequestFactory
                .defaultLoanProductsRequestLP1InterestFlat()//
                .name(name13)//
                .charges(charges);//
        Response<PostLoanProductsResponse> responseInterestFlatOverdueFeeAmount = loanProductsApi
                .createLoanProduct(loanProductsRequestInterestFlatOverdueFeeAmount).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_INTEREST_FLAT_OVERDUE_FROM_AMOUNT,
                responseInterestFlatOverdueFeeAmount);

        // LP1 with 12% FLAT interest with % overdue fee for amount+interest
        // (LP1_INTEREST_FLAT_OVERDUE_FROM_AMOUNT_INTEREST)
        String name14 = DefaultLoanProduct.LP1_INTEREST_FLAT_OVERDUE_FROM_AMOUNT_INTEREST.getName();
        List<ChargeData> chargesInterest = new ArrayList<>();
        chargesInterest.add(new ChargeData().id(ChargeProductType.LOAN_PERCENTAGE_LATE_FEE_AMOUNT_PLUS_INTEREST.value));
        PostLoanProductsRequest loanProductsRequestInterestFlatOverdueFeeAmountInterest = loanProductsRequestFactory
                .defaultLoanProductsRequestLP1InterestFlat()//
                .name(name14)//
                .charges(chargesInterest);//
        Response<PostLoanProductsResponse> responseInterestFlatOverdueFeeAmountInterest = loanProductsApi
                .createLoanProduct(loanProductsRequestInterestFlatOverdueFeeAmountInterest).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_INTEREST_FLAT_OVERDUE_FROM_AMOUNT_INTEREST,
                responseInterestFlatOverdueFeeAmountInterest);

        // LP2 with Down-payment
        // (LP2_DOWNPAYMENT)
        String name15 = DefaultLoanProduct.LP2_DOWNPAYMENT.getName();
        PostLoanProductsRequest loanProductsRequestDownPayment = loanProductsRequestFactory.defaultLoanProductsRequestLP2()//
                .name(name15)//
                .enableAutoRepaymentForDownPayment(false);//
        Response<PostLoanProductsResponse> responseDownPayment = loanProductsApi.createLoanProduct(loanProductsRequestDownPayment)
                .execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_DOWNPAYMENT, responseDownPayment);

        // LP2 with Down-payment+autopayment
        // (LP2_DOWNPAYMENT_AUTO)
        String name16 = DefaultLoanProduct.LP2_DOWNPAYMENT_AUTO.getName();
        PostLoanProductsRequest loanProductsRequestDownPaymentAuto = loanProductsRequestFactory.defaultLoanProductsRequestLP2()
                .name(name16);
        Response<PostLoanProductsResponse> responseDownPaymentAuto = loanProductsApi.createLoanProduct(loanProductsRequestDownPaymentAuto)
                .execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_DOWNPAYMENT_AUTO, responseDownPaymentAuto);

        // LP2 with Down-payment+autopayment + advanced payment allocation
        // (LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION)
        String name17 = DefaultLoanProduct.LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION.getName();
        PostLoanProductsRequest loanProductsRequestDownPaymentAutoAdvPaymentAllocation = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2()//
                .name(name17)//
                .transactionProcessingStrategyCode(ADVANCED_PAYMENT_ALLOCATION.getValue())//
                .loanScheduleType("PROGRESSIVE") //
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestDownPaymentAutoAdvPaymentAllocation = loanProductsApi
                .createLoanProduct(loanProductsRequestDownPaymentAutoAdvPaymentAllocation).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION,
                responseLoanProductsRequestDownPaymentAutoAdvPaymentAllocation);

        // LP2 with Down-payment + advanced payment allocation - no auto downpayment
        // (LP2_DOWNPAYMENT_ADVANCED_PAYMENT_ALLOCATION)
        String name24 = DefaultLoanProduct.LP2_DOWNPAYMENT_ADVANCED_PAYMENT_ALLOCATION.getName();
        PostLoanProductsRequest loanProductsRequestDownPaymentAdvPaymentAllocation = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2()//
                .name(name24)//
                .enableAutoRepaymentForDownPayment(false)//
                .transactionProcessingStrategyCode(ADVANCED_PAYMENT_ALLOCATION.getValue())//
                .loanScheduleType("PROGRESSIVE") //
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestDownPaymentAdvPaymentAllocation = loanProductsApi
                .createLoanProduct(loanProductsRequestDownPaymentAdvPaymentAllocation).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_DOWNPAYMENT_ADVANCED_PAYMENT_ALLOCATION,
                responseLoanProductsRequestDownPaymentAdvPaymentAllocation);

        // LP2 with Down-payment and interest
        // (LP2_DOWNPAYMENT_INTEREST)
        String name18 = DefaultLoanProduct.LP2_DOWNPAYMENT_INTEREST.getName();
        PostLoanProductsRequest loanProductsRequestDownPaymentInterest = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2InterestFlat()//
                .name(name18)//
                .enableAutoRepaymentForDownPayment(false);//
        Response<PostLoanProductsResponse> responseDownPaymentInterest = loanProductsApi
                .createLoanProduct(loanProductsRequestDownPaymentInterest).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_DOWNPAYMENT_INTEREST, responseDownPaymentInterest);

        // LP2 with Down-payment and interest
        // (LP2_DOWNPAYMENT_INTEREST_AUTO)
        String name19 = DefaultLoanProduct.LP2_DOWNPAYMENT_INTEREST_AUTO.getName();
        PostLoanProductsRequest loanProductsRequestDownPaymentInterestAuto = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2InterestFlat().name(name19);
        Response<PostLoanProductsResponse> responseDownPaymentInterestAuto = loanProductsApi
                .createLoanProduct(loanProductsRequestDownPaymentInterestAuto).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_DOWNPAYMENT_INTEREST_AUTO,
                responseDownPaymentInterestAuto);

        // LP2 with Down-payment + advanced payment allocation + progressive loan schedule + horizontal
        // (LP2_DOWNPAYMENT_ADV_PMT_ALLOC_PROGRESSIVE_LOAN_SCHEDULE_HORIZONTAL)
        String name20 = DefaultLoanProduct.LP2_DOWNPAYMENT_ADV_PMT_ALLOC_PROGRESSIVE_LOAN_SCHEDULE_HORIZONTAL.getName();
        PostLoanProductsRequest loanProductsRequestDownPaymentAdvPaymentAllocationProgressiveLoanSchedule = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2()//
                .name(name20)//
                .transactionProcessingStrategyCode(ADVANCED_PAYMENT_ALLOCATION.getValue())//
                .loanScheduleType("PROGRESSIVE") //
                .loanScheduleProcessingType("HORIZONTAL")//
                .enableAutoRepaymentForDownPayment(false)//
                .installmentAmountInMultiplesOf(null)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestDownPaymentAdvPaymentAllocationProgressiveLoanSchedule = loanProductsApi
                .createLoanProduct(loanProductsRequestDownPaymentAdvPaymentAllocationProgressiveLoanSchedule).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_DOWNPAYMENT_ADVANCED_PAYMENT_ALLOCATION_PROGRESSIVE_LOAN_SCHEDULE,
                responseLoanProductsRequestDownPaymentAdvPaymentAllocationProgressiveLoanSchedule);

        // LP2 with Down-payment + advanced payment allocation + progressive loan schedule + vertical
        // (LP2_DOWNPAYMENT_ADV_PMT_ALLOC_PROGRESSIVE_LOAN_SCHEDULE_VERTICAL)
        String name21 = DefaultLoanProduct.LP2_DOWNPAYMENT_ADV_PMT_ALLOC_PROGRESSIVE_LOAN_SCHEDULE_VERTICAL.getName();
        PostLoanProductsRequest loanProductsRequestDownPaymentAdvPaymentAllocationProgressiveLoanScheduleVertical = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2()//
                .name(name21)//
                .transactionProcessingStrategyCode(ADVANCED_PAYMENT_ALLOCATION.getValue())//
                .loanScheduleType("PROGRESSIVE") //
                .loanScheduleProcessingType("VERTICAL")//
                .enableAutoRepaymentForDownPayment(false)//
                .installmentAmountInMultiplesOf(null)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestDownPaymentAdvPaymentAllocationProgressiveLoanScheduleVertical = loanProductsApi
                .createLoanProduct(loanProductsRequestDownPaymentAdvPaymentAllocationProgressiveLoanScheduleVertical).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_DOWNPAYMENT_ADVANCED_PAYMENT_ALLOCATION_PROGRESSIVE_LOAN_SCHEDULE_VERTICAL,
                responseLoanProductsRequestDownPaymentAdvPaymentAllocationProgressiveLoanScheduleVertical);

        // LP2 with Down-payment + advanced payment allocation + progressive loan schedule + horizontal + installment
        // level delinquency
        // (LP2_DOWNPAYMENT_ADV_PMT_ALLOC_PROGRESSIVE_LOAN_SCHEDULE_HORIZONTAL_INSTALLMENT_LEVEL_DELINQUENCY)
        String name22 = DefaultLoanProduct.LP2_DOWNPAYMENT_ADV_PMT_ALLOC_PROGRESSIVE_LOAN_SCHEDULE_HORIZONTAL_INSTALLMENT_LEVEL_DELINQUENCY
                .getName();
        PostLoanProductsRequest loanProductsRequestDownPaymentAdvPaymentAllocationProgressiveLoanScheduleInstLvlDelinquency = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2()//
                .name(name22)//
                .transactionProcessingStrategyCode(ADVANCED_PAYMENT_ALLOCATION.getValue())//
                .loanScheduleType("PROGRESSIVE") //
                .loanScheduleProcessingType("HORIZONTAL")//
                .enableInstallmentLevelDelinquency(true)//
                .enableAutoRepaymentForDownPayment(false)//
                .installmentAmountInMultiplesOf(null)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestDownPaymentAdvPaymentAllocationProgressiveLoanScheduleInstLvlDelinquency = loanProductsApi
                .createLoanProduct(loanProductsRequestDownPaymentAdvPaymentAllocationProgressiveLoanScheduleInstLvlDelinquency).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_DOWNPAYMENT_ADVANCED_PAYMENT_ALLOCATION_PROGRESSIVE_LOAN_SCHEDULE_INSTALLMENT_LEVEL_DELINQUENCY,
                responseLoanProductsRequestDownPaymentAdvPaymentAllocationProgressiveLoanScheduleInstLvlDelinquency);

        // LP2 with Down-payment + advanced payment allocation + progressive loan schedule + horizontal + installment
        // level delinquency + creditAllocation
        // (LP2_DOWNPAYMENT_ADV_PMT_ALLOC_PROGRESSIVE_LOAN_SCHEDULE_HORIZONTAL_INSTALLMENT_LEVEL_DELINQUENCY)
        String name23 = DefaultLoanProduct.LP2_DOWNPAYMENT_ADV_PMT_ALLOC_PROG_SCHEDULE_HOR_INST_LVL_DELINQUENCY_CREDIT_ALLOCATION.getName();
        PostLoanProductsRequest loanProductsRequestDownPaymentAdvPmtAllocProgSchedInstLvlDelinquencyCreditAllocation = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2()//
                .name(name23)//
                .transactionProcessingStrategyCode(ADVANCED_PAYMENT_ALLOCATION.getValue())//
                .loanScheduleType("PROGRESSIVE") //
                .loanScheduleProcessingType("HORIZONTAL")//
                .enableInstallmentLevelDelinquency(true)//
                .enableAutoRepaymentForDownPayment(false)//
                .installmentAmountInMultiplesOf(null)//
                .creditAllocation(List.of(//
                        createCreditAllocation("CHARGEBACK", List.of("PENALTY", "FEE", "INTEREST", "PRINCIPAL"))//
                ))//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestDownPaymentAdvPmtAllocProgSchedInstLvlDelinquencyCreditAllocation = loanProductsApi
                .createLoanProduct(loanProductsRequestDownPaymentAdvPmtAllocProgSchedInstLvlDelinquencyCreditAllocation).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_DOWNPAYMENT_ADV_PMT_ALLOC_PROG_SCHEDULE_HOR_INST_LVL_DELINQUENCY_CREDIT_ALLOCATION,
                responseLoanProductsRequestDownPaymentAdvPmtAllocProgSchedInstLvlDelinquencyCreditAllocation);

        // LP2 with Down-payment + advanced payment allocation + progressive loan schedule + horizontal + installment
        // level delinquency + creditAllocation + fixed length (90)
        // (LP2_DOWNPAYMENT_ADV_PMT_ALLOC_FIXED_LENGTH)
        String name25 = DefaultLoanProduct.LP2_DOWNPAYMENT_ADV_PMT_ALLOC_FIXED_LENGTH.getName();
        PostLoanProductsRequest loanProductsRequestDownPaymentAdvPmtAllocFixedLength = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2()//
                .name(name25)//
                .transactionProcessingStrategyCode(ADVANCED_PAYMENT_ALLOCATION.getValue())//
                .loanScheduleType("PROGRESSIVE") //
                .loanScheduleProcessingType("HORIZONTAL")//
                .enableInstallmentLevelDelinquency(true)//
                .enableAutoRepaymentForDownPayment(false)//
                .installmentAmountInMultiplesOf(null)//
                .fixedLength(90).creditAllocation(List.of(//
                        createCreditAllocation("CHARGEBACK", List.of("PENALTY", "FEE", "INTEREST", "PRINCIPAL"))//
                ))//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestDownPaymentAdvPmtAllocFixedLength = loanProductsApi
                .createLoanProduct(loanProductsRequestDownPaymentAdvPmtAllocFixedLength).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_DOWNPAYMENT_ADV_PMT_ALLOC_FIXED_LENGTH,
                responseLoanProductsRequestDownPaymentAdvPmtAllocFixedLength);

        // LP2 with Down-payment+autopayment + advanced payment allocation + repayment start date SUBMITTED ON DATE
        // (LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION_REPAYMENT_START_SUBMITTED)
        String name26 = DefaultLoanProduct.LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION_REPAYMENT_START_SUBMITTED.getName();
        PostLoanProductsRequest loanProductsRequestDownPaymentAutoAdvPaymentAllocationRepaymentStartSubmitted = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2()//
                .name(name26)//
                .transactionProcessingStrategyCode(ADVANCED_PAYMENT_ALLOCATION.getValue())//
                .loanScheduleType("PROGRESSIVE") //
                .repaymentStartDateType(2)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestDownPaymentAutoAdvPaymentAllocationRepaymentStartSubmitted = loanProductsApi
                .createLoanProduct(loanProductsRequestDownPaymentAutoAdvPaymentAllocationRepaymentStartSubmitted).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_DOWNPAYMENT_AUTO_ADVANCED_REPAYMENT_ALLOCATION_PAYMENT_START_SUBMITTED,
                responseLoanProductsRequestDownPaymentAutoAdvPaymentAllocationRepaymentStartSubmitted);

        // LP2 with Down-payment + advanced payment allocation + progressive loan schedule + horizontal + interest Flat
        // (LP2_DOWNPAYMENT_INTEREST_FLAT_ADV_PMT_ALLOC)
        String name27 = DefaultLoanProduct.LP2_DOWNPAYMENT_INTEREST_FLAT_ADV_PMT_ALLOC.getName();
        PostLoanProductsRequest loanProductsRequestDownPaymentAdvPaymentAllocationInterestFlat = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2InterestFlat()//
                .name(name27)//
                .transactionProcessingStrategyCode(ADVANCED_PAYMENT_ALLOCATION.getValue())//
                .loanScheduleType("PROGRESSIVE") //
                .loanScheduleProcessingType("HORIZONTAL")//
                .enableAutoRepaymentForDownPayment(false)//
                .installmentAmountInMultiplesOf(null)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestDownPaymentAdvPaymentAllocationInterestFlat = loanProductsApi
                .createLoanProduct(loanProductsRequestDownPaymentAdvPaymentAllocationInterestFlat).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_DOWNPAYMENT_INTEREST_FLAT_ADV_PMT_ALLOC,
                responseLoanProductsRequestDownPaymentAdvPaymentAllocationInterestFlat);

        // LP2 with progressive loan schedule + horizontal + interest EMI + actual/actual
        // (LP2_ADV_PYMNT_INTEREST_DAILY_EMI_ACTUAL_ACTUAL)
        String name28 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_EMI_ACTUAL_ACTUAL.getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvancedpaymentInterestEmiActualActual = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .name(name28)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestLP2AdvancedpaymentInterestEmiActualActual = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedpaymentInterestEmiActualActual).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_EMI_ACTUAL_ACTUAL,
                responseLoanProductsRequestLP2AdvancedpaymentInterestEmiActualActual);

        // LP2 with progressive loan schedule + horizontal + interest EMI + 360/30
        // (LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30)
        String name29 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30.getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvancedpaymentInterestEmi36030 = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .name(name29)//
                .daysInYearType(DaysInYearType.DAYS360.value)//
                .daysInMonthType(DaysInMonthType.DAYS30.value)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestLP2AdvancedpaymentInterest36030 = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedpaymentInterestEmi36030).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30,
                responseLoanProductsRequestLP2AdvancedpaymentInterest36030);

        // LP2 with progressive loan schedule + horizontal + interest EMI + 360/30 + multidisbursement
        // (LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_MULTIDISBURSE)
        String name36 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_MULTIDISBURSE.getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvancedpaymentInterestEmi36030MultiDisburse = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .name(name36)//
                .daysInYearType(DaysInYearType.DAYS360.value)//
                .daysInMonthType(DaysInMonthType.DAYS30.value)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")))//
                .multiDisburseLoan(true)//
                .disallowExpectedDisbursements(true)//
                .maxTrancheCount(10)//
                .outstandingLoanBalance(10000.0);//
        Response<PostLoanProductsResponse> responseLoanProductsRequestLP2AdvancedpaymentInterest36030MultiDisburse = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedpaymentInterestEmi36030MultiDisburse).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_MULTIDISBURSE,
                responseLoanProductsRequestLP2AdvancedpaymentInterest36030MultiDisburse);

        // LP2 with progressive loan schedule + horizontal + interest EMI + 360/30 + multidisbursement + downpayment
        // 25%, auto disabled
        // (LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_MULTIDISBURSE_DOWNPAYMENT)
        String name37 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_MULTIDISBURSE_DOWNPAYMENT.getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvancedpaymentInterestEmi36030MultiDisburseDownPayment = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .name(name37)//
                .enableDownPayment(true)//
                .disbursedAmountPercentageForDownPayment(new BigDecimal(25))//
                .daysInYearType(DaysInYearType.DAYS360.value)//
                .daysInMonthType(DaysInMonthType.DAYS30.value)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")))//
                .multiDisburseLoan(true)//
                .disallowExpectedDisbursements(true)//
                .maxTrancheCount(10)//
                .outstandingLoanBalance(10000.0);//
        Response<PostLoanProductsResponse> responseLoanProductsRequestLP2AdvancedpaymentInterest36030MultiDisburseDownPayment = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedpaymentInterestEmi36030MultiDisburseDownPayment).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_MULTIDISBURSE_DOWNPAYMENT,
                responseLoanProductsRequestLP2AdvancedpaymentInterest36030MultiDisburseDownPayment);

        // LP2 with progressive loan schedule + horizontal + interest EMI + 365/Actual
        // (LP2_ADV_PYMNT_INTEREST_DAILY_EMI_365_ACTUAL)
        String name30 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_EMI_365_ACTUAL.getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvancedpaymentInterest365Actual = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .name(name30)//
                .daysInYearType(DaysInYearType.DAYS365.value)//
                .daysInMonthType(DaysInMonthType.ACTUAL.value)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestLP2AdvancedpaymentInterestEmi365Actual = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedpaymentInterest365Actual).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_EMI_365_ACTUAL,
                responseLoanProductsRequestLP2AdvancedpaymentInterestEmi365Actual);

        // LP2 with progressive loan schedule + horizontal + interest EMI + 360/30 + downpayment 25%
        // (LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_DOWNPAYMENT)
        String name31 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_DOWNPAYMENT.getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvancedpaymentInterest36030Downpayment = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .name(name31)//
                .enableDownPayment(true)//
                .disbursedAmountPercentageForDownPayment(new BigDecimal(25))//
                .daysInYearType(DaysInYearType.DAYS360.value)//
                .daysInMonthType(DaysInMonthType.DAYS30.value)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestLP2AdvancedpaymentInterestEmi36030Downpayment = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedpaymentInterest36030Downpayment).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_DOWNPAYMENT,
                responseLoanProductsRequestLP2AdvancedpaymentInterestEmi36030Downpayment);

        // LP2 with progressive loan schedule + horizontal + interest EMI + actual/actual +
        // enableAccrualActivityPosting
        // (LP2_ADV_PYMNT_INTEREST_DAILY_EMI_ACTUAL_ACTUAL_ACCRUAL_ACTIVITY)
        String name32 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_EMI_ACTUAL_ACTUAL_ACCRUAL_ACTIVITY.getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvancedpaymentInterestEmiActualActualAccrualActivity = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .name(name32)//
                .enableAccrualActivityPosting(true)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestLP2AdvancedpaymentInterestEmiActualActualAccrualActivity = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedpaymentInterestEmiActualActualAccrualActivity).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_EMI_ACTUAL_ACTUAL,
                responseLoanProductsRequestLP2AdvancedpaymentInterestEmiActualActualAccrualActivity);

        // LP1 with 12% DECLINING BALANCE interest, interest period: Daily + enableAccrualActivityPosting
        // (LP1_INTEREST_DECLINING_BALANCE_PERIOD_DAILY_ACCRUAL_ACTIVITY)
        String name33 = DefaultLoanProduct.LP1_INTEREST_DECLINING_BALANCE_PERIOD_DAILY_ACCRUAL_ACTIVITY.getName();
        PostLoanProductsRequest loanProductsRequestInterestDecliningPeriodDailyAccrualActivity = loanProductsRequestFactory
                .defaultLoanProductsRequestLP1InterestDeclining()//
                .name(name33)//
                .enableAccrualActivityPosting(true)//
                .interestCalculationPeriodType(InterestCalculationPeriodTime.DAILY.value)//
                .allowPartialPeriodInterestCalcualtion(false);//
        Response<PostLoanProductsResponse> responseInterestDecliningPeriodDailyAccrualActivity = loanProductsApi
                .createLoanProduct(loanProductsRequestInterestDecliningPeriodDailyAccrualActivity).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_INTEREST_DECLINING_PERIOD_DAILY_ACCRUAL_ACTIVITY,
                responseInterestDecliningPeriodDailyAccrualActivity);

        // LP1 with 12% DECLINING BALANCE interest, interest period: Daily, Interest
        // recalculation-Daily, Compounding:none + enableAccrualActivityPosting
        // (LP1_INTEREST_DECLINING_BALANCE_DAILY_RECALCULATION_COMPOUNDING_NONE_ACCRUAL_ACTIVITY)
        String name34 = DefaultLoanProduct.LP1_INTEREST_DECLINING_BALANCE_DAILY_RECALCULATION_COMPOUNDING_NONE_ACCRUAL_ACTIVITY.getName();
        PostLoanProductsRequest loanProductsRequestLP1InterestDecliningBalanceDailyRecalculationCompoundingNoneAccrualActivity = loanProductsRequestFactory
                .defaultLoanProductsRequestLP1InterestDecliningBalanceDailyRecalculationCompoundingNone()//
                .name(name34)//
                .enableAccrualActivityPosting(true)//
                .interestCalculationPeriodType(InterestCalculationPeriodTime.DAILY.value)//
                .allowPartialPeriodInterestCalcualtion(false);//
        Response<PostLoanProductsResponse> responseLP1InterestDecliningBalanceDailyRecalculationCompoundingNoneAccrualActivity = loanProductsApi
                .createLoanProduct(loanProductsRequestLP1InterestDecliningBalanceDailyRecalculationCompoundingNoneAccrualActivity)
                .execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_INTEREST_DECLINING_BALANCE_DAILY_RECALCULATION_COMPOUNDING_NONE_ACCRUAL_ACTIVITY,
                responseLP1InterestDecliningBalanceDailyRecalculationCompoundingNoneAccrualActivity);

        // LP2 with progressive loan schedule + horizontal + interest EMI + actual/actual + interest refund with
        // Merchant issued and Payment refund
        // (LP2_ADV_PYMNT_INTEREST_DAILY_EMI_ACTUAL_ACTUAL_INTEREST_REFUND)
        String name35 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_EMI_ACTUAL_ACTUAL_INTEREST_REFUND.getName();
        List<String> supportedInterestRefundTypes = Arrays.asList("MERCHANT_ISSUED_REFUND", "PAYOUT_REFUND");
        PostLoanProductsRequest loanProductsRequestLP2AdvancedpaymentInterestEmiActualActualInterestRefund = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .name(name35)//
                .supportedInterestRefundTypes(supportedInterestRefundTypes).paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("INTEREST_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestLP2AdvancedpaymentInterestEmiActualActualInterestRefund = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedpaymentInterestEmiActualActualInterestRefund).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_EMI_ACTUAL_ACTUAL_INTEREST_REFUND,
                responseLoanProductsRequestLP2AdvancedpaymentInterestEmiActualActualInterestRefund);

        // LP2 with progressive loan schedule + horizontal + interest EMI + 360/30
        // + interest recalculation, preClosureInterestCalculationStrategy= till preclose,
        // interestRecalculationCompoundingMethod = none
        // Frequency for recalculate Outstanding Principal: Daily, Frequency Interval for recalculation: 1
        // (LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_DAILY_TILL_PRECLOSE)
        String name38 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_DAILY_TILL_PRECLOSE.getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvancedpaymentInterestEmi36030InterestRecalcDailyTillPreclose = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .name(name38)//
                .daysInYearType(DaysInYearType.DAYS360.value)//
                .daysInMonthType(DaysInMonthType.DAYS30.value)//
                .isInterestRecalculationEnabled(true)//
                .preClosureInterestCalculationStrategy(1)//
                .rescheduleStrategyMethod(4)//
                .interestRecalculationCompoundingMethod(0)//
                .recalculationRestFrequencyType(2)//
                .recalculationRestFrequencyInterval(1)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestLP2AdvancedpaymentInterest36030InterestRecalcDailyTillPreCloese = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedpaymentInterestEmi36030InterestRecalcDailyTillPreclose).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_DAILY_TILL_PRECLOSE,
                responseLoanProductsRequestLP2AdvancedpaymentInterest36030InterestRecalcDailyTillPreCloese);

        // LP2 with progressive loan schedule + horizontal + interest EMI + 360/30
        // + interest recalculation, preClosureInterestCalculationStrategy= till rest frequency date,
        // interestRecalculationCompoundingMethod = none
        // Frequency for recalculate Outstanding Principal: Daily, Frequency Interval for recalculation: 1
        // (LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_DAILY_TILL_REST_FREQUENCY_DATE)
        String name39 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_DAILY_TILL_REST_FREQUENCY_DATE
                .getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvancedpaymentInterestEmi36030InterestRecalcDailyTillRestFrequencyDate = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .name(name39)//
                .daysInYearType(DaysInYearType.DAYS360.value)//
                .daysInMonthType(DaysInMonthType.DAYS30.value)//
                .isInterestRecalculationEnabled(true)//
                .preClosureInterestCalculationStrategy(2)//
                .rescheduleStrategyMethod(4)//
                .interestRecalculationCompoundingMethod(0)//
                .recalculationRestFrequencyType(2)//
                .recalculationRestFrequencyInterval(1)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestLP2AdvancedpaymentInterest36030InterestRecalcDailyTillRestFrequencyDate = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedpaymentInterestEmi36030InterestRecalcDailyTillRestFrequencyDate).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_DAILY_TILL_REST_FREQUENCY_DATE,
                responseLoanProductsRequestLP2AdvancedpaymentInterest36030InterestRecalcDailyTillRestFrequencyDate);

        // LP2 with progressive loan schedule + horizontal + interest EMI + 360/30
        // + interest recalculation, preClosureInterestCalculationStrategy= till preclose,
        // interestRecalculationCompoundingMethod = none
        // Frequency for recalculate Outstanding Principal: Same as repayment period, Frequency Interval for
        // recalculation: 1
        // (LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_SARP_TILL_PRECLOSE)
        String name40 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_SARP_TILL_PRECLOSE.getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvancedpaymentInterestEmi36030InterestRecalcSameAsRepTillPreclose = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .name(name40)//
                .daysInYearType(DaysInYearType.DAYS360.value)//
                .daysInMonthType(DaysInMonthType.DAYS30.value)//
                .isInterestRecalculationEnabled(true)//
                .preClosureInterestCalculationStrategy(1)//
                .rescheduleStrategyMethod(4)//
                .interestRecalculationCompoundingMethod(0)//
                .recalculationRestFrequencyType(1)//
                .recalculationRestFrequencyInterval(1)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestLP2AdvancedpaymentInterest36030InterestRecalcSameAsRepTillPreCloese = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedpaymentInterestEmi36030InterestRecalcSameAsRepTillPreclose).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_SAME_AS_REP_TILL_PRECLOSE,
                responseLoanProductsRequestLP2AdvancedpaymentInterest36030InterestRecalcSameAsRepTillPreCloese);

        // LP2 with progressive loan schedule + horizontal + interest EMI + 360/30
        // + interest recalculation, preClosureInterestCalculationStrategy= till rest frequency date,
        // interestRecalculationCompoundingMethod = none
        // Frequency for recalculate Outstanding Principal: Same as repayment period, Frequency Interval for
        // recalculation: 1
        // (LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_SARP_TILL_REST_FREQUENCY_DATE)
        String name41 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_SARP_TILL_REST_FREQUENCY_DATE
                .getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvancedpaymentInterestEmi36030InterestRecalcSameAsRepTillRestFrequencyDate = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .name(name41)//
                .daysInYearType(DaysInYearType.DAYS360.value)//
                .daysInMonthType(DaysInMonthType.DAYS30.value)//
                .isInterestRecalculationEnabled(true)//
                .preClosureInterestCalculationStrategy(2)//
                .rescheduleStrategyMethod(4)//
                .interestRecalculationCompoundingMethod(0)//
                .recalculationRestFrequencyType(1)//
                .recalculationRestFrequencyInterval(1)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestLP2AdvancedpaymentInterest36030InterestRecalcSameAsRepTillRestFrequencyDate = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedpaymentInterestEmi36030InterestRecalcSameAsRepTillRestFrequencyDate)
                .execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_SAME_AS_REP_TILL_REST_FREQUENCY_DATE,
                responseLoanProductsRequestLP2AdvancedpaymentInterest36030InterestRecalcSameAsRepTillRestFrequencyDate);

        // LP1 advanced payment allocation + progressive loan schedule + horizontal
        // (LP1_ADV_PMT_ALLOC_PROGRESSIVE_LOAN_SCHEDULE_HORIZONTAL)
        String name42 = DefaultLoanProduct.LP1_ADV_PMT_ALLOC_PROGRESSIVE_LOAN_SCHEDULE_HORIZONTAL.getName();
        PostLoanProductsRequest loanProductsRequestLP1AdvPmtAllocProgressiveLoanScheduleHorizontal = loanProductsRequestFactory//
                .defaultLoanProductsRequestLP1()//
                .name(name42)//
                .transactionProcessingStrategyCode(ADVANCED_PAYMENT_ALLOCATION.getValue())//
                .loanScheduleType("PROGRESSIVE") //
                .loanScheduleProcessingType("HORIZONTAL")//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLP1AdvPmtAllocProgressiveLoanScheduleHorizontal = loanProductsApi
                .createLoanProduct(loanProductsRequestLP1AdvPmtAllocProgressiveLoanScheduleHorizontal).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP1_ADVANCED_PAYMENT_ALLOCATION_PROGRESSIVE_LOAN_SCHEDULE_HORIZONTAL,
                responseLP1AdvPmtAllocProgressiveLoanScheduleHorizontal);

        // + interest recalculation, preClosureInterestCalculationStrategy= till preclose,
        // interestRecalculationCompoundingMethod = none
        // Frequency for recalculate Outstanding Principal: Daily, Frequency Interval for recalculation: 1
        // Frequency for Interest rate - Whole Year
        // (LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_DAILY_TILL_PRECLOSE_WHOLE_TERM)
        String name43 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_DAILY_TILL_PRECLOSE_WHOLE_TERM
                .getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvancedpaymentInterestEmi36030InterestRecalcDailyTillPrecloseWholeTerm = loanProductsRequestFactory//
                .defaultLoanProductsRequestLP2Emi()//
                .name(name43)//
                .daysInYearType(DaysInYearType.DAYS360.value)//
                .daysInMonthType(DaysInMonthType.DAYS30.value)//
                .isInterestRecalculationEnabled(true)//
                .preClosureInterestCalculationStrategy(1)//
                .rescheduleStrategyMethod(4)//
                .interestRecalculationCompoundingMethod(0)//
                .recalculationRestFrequencyType(2)//
                .recalculationRestFrequencyInterval(1)//
                .interestRatePerPeriod((double) 4)//
                .interestRateFrequencyType(INTEREST_RATE_FREQUENCY_TYPE_WHOLE_TERM)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLP2AdvancedpaymentInterestEmi36030InterestRecalcDailyTillPrecloseWholeTerm = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedpaymentInterestEmi36030InterestRecalcDailyTillPrecloseWholeTerm).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_DAILY_TILL_PRECLOSE_WHOLE_TERM,
                responseLP2AdvancedpaymentInterestEmi36030InterestRecalcDailyTillPrecloseWholeTerm);

        // LP2 + interest recalculation + advanced custom payment allocation + progressive loan schedule + horizontal
        // (LP2_ADV_CUSTOM_PMT_ALLOC_PROGRESSIVE_LOAN_SCHEDULE_HORIZONTAL)
        String name44 = DefaultLoanProduct.LP2_ADV_CUSTOM_PMT_ALLOC_PROGRESSIVE_LOAN_SCHEDULE_HORIZONTAL.getName();

        PostLoanProductsRequest loanProductsRequestAdvCustomPaymentAllocationProgressiveLoanSchedule = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2InterestDailyRecalculation()//
                .name(name44)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT",
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_INTEREST, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_PRINCIPAL, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_PENALTY, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_FEE, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_INTEREST, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_PRINCIPAL, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_PENALTY, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_FEE, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_INTEREST, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_PRINCIPAL, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_PENALTY, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_FEE), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestAdvCustomPaymentAllocationProgressiveLoanSchedule = loanProductsApi
                .createLoanProduct(loanProductsRequestAdvCustomPaymentAllocationProgressiveLoanSchedule).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADVANCED_CUSTOM_PAYMENT_ALLOCATION_PROGRESSIVE_LOAN_SCHEDULE,
                responseLoanProductsRequestAdvCustomPaymentAllocationProgressiveLoanSchedule);

        String name45 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_EMI_ACTUAL_ACTUAL_INTEREST_REFUND_FULL.getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvancedpaymentInterestEmiActualActualInterestRefundFull = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .name(name45)//
                .multiDisburseLoan(true)//
                .disallowExpectedDisbursements(true)//
                .maxTrancheCount(10)//
                .isInterestRecalculationEnabled(true)//
                .preClosureInterestCalculationStrategy(1)//
                .rescheduleStrategyMethod(4)//
                .interestRecalculationCompoundingMethod(0)//
                .recalculationRestFrequencyType(2)//
                .recalculationRestFrequencyInterval(1)//
                .supportedInterestRefundTypes(supportedInterestRefundTypes).paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("INTEREST_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestLP2AdvancedpaymentInterestEmiActualActualInterestRefundFull = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedpaymentInterestEmiActualActualInterestRefundFull).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_EMI_ACTUAL_ACTUAL_INTEREST_REFUND_FULL,
                responseLoanProductsRequestLP2AdvancedpaymentInterestEmiActualActualInterestRefundFull);

        // LP2 with progressive loan schedule + horizontal + interest EMI + 360/30
        // + interest recalculation, preClosureInterestCalculationStrategy= till preclose,
        // interestRecalculationCompoundingMethod = none
        // payment allocation order: penalty-fee-interest-principal
        // Frequency for recalculate Outstanding Principal: Daily, Frequency Interval for recalculation: 1
        // (LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_DAILY_TILL_PRECLOSE_PMT_ALLOC_1)
        String name46 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_DAILY_TILL_PRECLOSE_PMT_ALLOC_1
                .getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvancedpaymentInterestEmi36030InterestRecalcDailyTillPreclosePmtAlloc1 = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .name(name46)//
                .daysInYearType(DaysInYearType.DAYS360.value)//
                .daysInMonthType(DaysInMonthType.DAYS30.value)//
                .isInterestRecalculationEnabled(true)//
                .preClosureInterestCalculationStrategy(1)//
                .rescheduleStrategyMethod(4)//
                .interestRecalculationCompoundingMethod(0)//
                .recalculationRestFrequencyType(2)//
                .recalculationRestFrequencyInterval(1)//
                .paymentAllocation(List.of(//
                        createPaymentAllocationPenFeeIntPrincipal("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocationPenFeeIntPrincipal("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocationPenFeeIntPrincipal("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocationPenFeeIntPrincipal("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestLP2AdvancedpaymentInterest36030InterestRecalcDailyTillPreCloesePmtAlloc1 = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedpaymentInterestEmi36030InterestRecalcDailyTillPreclosePmtAlloc1).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_DAILY_TILL_PRECLOSE_PMT_ALLOC_1,
                responseLoanProductsRequestLP2AdvancedpaymentInterest36030InterestRecalcDailyTillPreCloesePmtAlloc1);

        // LP2 with progressive loan schedule + horizontal + interest EMI + 360/30, LAST INSTALLMENT strategy
        // + interest recalculation, preClosureInterestCalculationStrategy= till preclose,
        // interestRecalculationCompoundingMethod = none
        // Frequency for recalculate Outstanding Principal: Daily, Frequency Interval for recalculation: 1
        // (LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_IR_DAILY_TILL_PRECLOSE_LAST_INSTALLMENT_STRATEGY)
        String name47 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_IR_DAILY_TILL_PRECLOSE_LAST_INSTALLMENT_STRATEGY
                .getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvancedpaymentInterestEmi36030InterestRecalcDailyTillPrecloseLastInstallment = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .name(name47)//
                .daysInYearType(DaysInYearType.DAYS360.value)//
                .daysInMonthType(DaysInMonthType.DAYS30.value)//
                .isInterestRecalculationEnabled(true)//
                .preClosureInterestCalculationStrategy(1)//
                .rescheduleStrategyMethod(4)//
                .interestRecalculationCompoundingMethod(0)//
                .recalculationRestFrequencyType(2)//
                .recalculationRestFrequencyInterval(1)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "LAST_INSTALLMENT")));//
        Response<PostLoanProductsResponse> loanProductsRequestLP2AdvancedpaymentInterestEmi36030InterestRecalcDailyTillPrecloseLastInstallmentResponse = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedpaymentInterestEmi36030InterestRecalcDailyTillPrecloseLastInstallment)
                .execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_DAILY_TILL_PRECLOSE_LAST_INSTALLMENT,
                loanProductsRequestLP2AdvancedpaymentInterestEmi36030InterestRecalcDailyTillPrecloseLastInstallmentResponse);

        // LP2 with progressive loan schedule + horizontal + interest EMI + actual/actual + interest refund with
        // Merchant issued and Payment refund + interest recalculation
        // (LP2_ADV_PYMNT_INTEREST_DAILY_EMI_ACTUAL_ACTUAL_INTEREST_REFUND_INTEREST_RECALCULATION)
        String name48 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_EMI_ACTUAL_ACTUAL_INTEREST_REFUND_INTEREST_RECALCULATION.getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvancedpaymentInterestEmiActualActualInterestRefundRecalculation = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .isInterestRecalculationEnabled(true)//
                .preClosureInterestCalculationStrategy(1)//
                .rescheduleStrategyMethod(4)//
                .interestRecalculationCompoundingMethod(0)//
                .recalculationRestFrequencyType(2)//
                .recalculationRestFrequencyInterval(1)//
                .name(name48)//
                .supportedInterestRefundTypes(Arrays.asList("MERCHANT_ISSUED_REFUND", "PAYOUT_REFUND"))//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestLP2AdvancedpaymentInterestEmiActualActualInterestRefundInterestRecalculation = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedpaymentInterestEmiActualActualInterestRefundRecalculation).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_EMI_ACTUAL_ACTUAL_INTEREST_REFUND_INTEREST_RECALCULATION,
                responseLoanProductsRequestLP2AdvancedpaymentInterestEmiActualActualInterestRefundInterestRecalculation);

        // LP2 with progressive loan schedule + horizontal + interest EMI + 360/30 + multidisbursement + downpayment +
        // interest recalculation
        // 25%, auto disabled
        // (LP2_ADV_PYMNT_INTEREST_RECALCULATION_DAILY_EMI_360_30_MULTIDISBURSE_DOWNPAYMENT)
        String name49 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_RECALCULATION_DAILY_EMI_360_30_MULTIDISBURSE_DOWNPAYMENT.getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvancedpaymentInterestRecalculationEmi36030MultiDisburseDownPayment = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .name(name49)//
                .enableDownPayment(true)//
                .disbursedAmountPercentageForDownPayment(new BigDecimal(25))//
                .daysInYearType(DaysInYearType.DAYS360.value)//
                .daysInMonthType(DaysInMonthType.DAYS30.value)//
                .isInterestRecalculationEnabled(true)//
                .preClosureInterestCalculationStrategy(1)//
                .rescheduleStrategyMethod(4)//
                .interestRecalculationCompoundingMethod(0)//
                .recalculationRestFrequencyType(2)//
                .recalculationRestFrequencyInterval(1)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")))//
                .multiDisburseLoan(true)//
                .disallowExpectedDisbursements(true)//
                .maxTrancheCount(10)//
                .outstandingLoanBalance(10000.0);//
        Response<PostLoanProductsResponse> responseLoanProductsRequestLP2AdvancedpaymentInterestRecalculation36030MultiDisburseDownPayment = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedpaymentInterestRecalculationEmi36030MultiDisburseDownPayment).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_RECALCULATION_DAILY_EMI_360_30_MULTIDISBURSE_DOWNPAYMENT,
                responseLoanProductsRequestLP2AdvancedpaymentInterestRecalculation36030MultiDisburseDownPayment);

        // LP2 with progressive loan schedule + horizontal + interest recalculation daily EMI + 360/30 + multi
        // disbursement + custom default payment allocation order
        // (LP2_ADV_CUSTOM_PAYMENT_ALLOC_INTEREST_RECALCULATION_DAILY_EMI_360_30_MULTIDISBURSE)
        String name50 = DefaultLoanProduct.LP2_ADV_CUSTOM_PAYMENT_ALLOC_INTEREST_RECALCULATION_DAILY_EMI_360_30_MULTIDISBURSE.getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvCustomPaymentAllocationInterestRecalculationDailyEmi36030MultiDisburse = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .name(name50)//
                .daysInYearType(DaysInYearType.DAYS360.value)//
                .daysInMonthType(DaysInMonthType.DAYS30.value)//
                .isInterestRecalculationEnabled(true)//
                .preClosureInterestCalculationStrategy(1)//
                .rescheduleStrategyMethod(4)//
                .interestRecalculationCompoundingMethod(0)//
                .recalculationRestFrequencyType(2)//
                .recalculationRestFrequencyInterval(1)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT",
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_PENALTY, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_FEE, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_INTEREST, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_PRINCIPAL, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_PENALTY, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_FEE, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_INTEREST, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_PRINCIPAL, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_PENALTY, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_FEE, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_INTEREST, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_PRINCIPAL), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")))//
                .multiDisburseLoan(true)//
                .disallowExpectedDisbursements(true)//
                .maxTrancheCount(10)//
                .outstandingLoanBalance(10000.0);//
        Response<PostLoanProductsResponse> responseLoanProductsRequestLP2AdvCustomPaymentAllocationInterestRecalculationDaily36030MultiDisburse = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvCustomPaymentAllocationInterestRecalculationDailyEmi36030MultiDisburse)
                .execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADVANCED_CUSTOM_PAYMENT_ALLOCATION_INTEREST_RECALCULATION_DAILY_EMI_360_30_MULTIDISBURSE,
                responseLoanProductsRequestLP2AdvCustomPaymentAllocationInterestRecalculationDaily36030MultiDisburse);

        // LP2 + interest recalculation + zero-interest chargeOff behaviour + progressive loan schedule + horizontal
        // (LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR)
        final String name51 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR
                .getName();

        final PostLoanProductsRequest loanProductsRequestAdvInterestRecalculationZeroInterestChargeOffBehaviourProgressiveLoanSchedule = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2InterestDailyRecalculation()//
                .name(name51)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT")))
                .chargeOffBehaviour("ZERO_INTEREST");//
        final Response<PostLoanProductsResponse> responseLoanProductsRequestAdvInterestRecalculationZeroInterestChargeOffBehaviourProgressiveLoanSchedule = loanProductsApi
                .createLoanProduct(loanProductsRequestAdvInterestRecalculationZeroInterestChargeOffBehaviourProgressiveLoanSchedule)
                .execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR,
                responseLoanProductsRequestAdvInterestRecalculationZeroInterestChargeOffBehaviourProgressiveLoanSchedule);

        // LP2 + zero-interest chargeOff behaviour + progressive loan schedule + horizontal
        // (LP2_ADV_PYMNT_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR)
        final String name52 = DefaultLoanProduct.LP2_ADV_PYMNT_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR.getName();

        final PostLoanProductsRequest loanProductsRequestAdvZeroInterestChargeOffBehaviourProgressiveLoanSchedule = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2()//
                .name(name52)//
                .enableDownPayment(false)//
                .enableAutoRepaymentForDownPayment(null)//
                .disbursedAmountPercentageForDownPayment(null)//
                .transactionProcessingStrategyCode(ADVANCED_PAYMENT_ALLOCATION.getValue())//
                .loanScheduleType("PROGRESSIVE") //
                .loanScheduleProcessingType("HORIZONTAL")//
                .interestRateFrequencyType(3)//
                .maxInterestRatePerPeriod(10.0)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT",
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_PENALTY, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_FEE, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_PRINCIPAL, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_INTEREST, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_PENALTY, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_FEE, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_PRINCIPAL, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_INTEREST, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_PENALTY, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_FEE, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_INTEREST, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_PRINCIPAL), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")))//
                .chargeOffBehaviour("ZERO_INTEREST");//
        final Response<PostLoanProductsResponse> responseLoanProductsRequestAdvZeroInterestChargeOffBehaviourProgressiveLoanSchedule = loanProductsApi
                .createLoanProduct(loanProductsRequestAdvZeroInterestChargeOffBehaviourProgressiveLoanSchedule).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR,
                responseLoanProductsRequestAdvZeroInterestChargeOffBehaviourProgressiveLoanSchedule);

        // LP2 with progressive loan schedule + horizontal + interest EMI + 360/30 + multidisbursement +
        // accelerate-maturity chargeOff behaviour
        // (LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR)
        final String name53 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR
                .getName();

        final PostLoanProductsRequest loanProductsRequestAdvCustomInterestRecalculationAccelerateMaturityChargeOffBehaviourProgressiveLoanSchedule = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2InterestDailyRecalculation()//
                .name(name53)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT",
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_PENALTY, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_FEE, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_INTEREST, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_PRINCIPAL, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_PENALTY, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_FEE, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_PRINCIPAL, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_INTEREST, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_PENALTY, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_FEE, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_PRINCIPAL,
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_INTEREST), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT"))) //
                .chargeOffBehaviour("ACCELERATE_MATURITY");//
        final Response<PostLoanProductsResponse> responseLoanProductsRequestAdvCustomInterestRecalculationAccelerateMaturityChargeOffBehaviourProgressiveLoanSchedule = loanProductsApi
                .createLoanProduct(
                        loanProductsRequestAdvCustomInterestRecalculationAccelerateMaturityChargeOffBehaviourProgressiveLoanSchedule)
                .execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR,
                responseLoanProductsRequestAdvCustomInterestRecalculationAccelerateMaturityChargeOffBehaviourProgressiveLoanSchedule);

        // LP2 with progressive loan schedule + horizontal + interest EMI + 360/30 + accrual activity
        String name54 = DefaultLoanProduct.LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_ACCRUAL_ACTIVITY.getName();
        PostLoanProductsRequest loanProductsRequestLP2AdvancedPaymentInterestEmi36030AccrualActivity = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2Emi()//
                .name(name54)//
                .enableAccrualActivityPosting(true)//
                .daysInYearType(DaysInYearType.DAYS360.value)//
                .daysInMonthType(DaysInMonthType.DAYS30.value)//
                .isInterestRecalculationEnabled(true)//
                .preClosureInterestCalculationStrategy(1)//
                .rescheduleStrategyMethod(4)//
                .interestRecalculationCompoundingMethod(0)//
                .recalculationRestFrequencyType(2)//
                .recalculationRestFrequencyInterval(1)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT"), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")));//
        Response<PostLoanProductsResponse> responseLoanProductsRequestLP2AdvancedPaymentInterestEmi36030AccrualActivity = loanProductsApi
                .createLoanProduct(loanProductsRequestLP2AdvancedPaymentInterestEmi36030AccrualActivity).execute();
        TestContext.INSTANCE.set(
                TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_ACCRUAL_ACTIVITY,
                responseLoanProductsRequestLP2AdvancedPaymentInterestEmi36030AccrualActivity);

        // LP2 with progressive loan schedule + horizontal + accelerate-maturity chargeOff behaviour
        // (LP2_ADV_PYMNT_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR)
        final String name55 = DefaultLoanProduct.LP2_ADV_PYMNT_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR.getName();

        final PostLoanProductsRequest loanProductsRequestAdvCustomAccelerateMaturityChargeOffBehaviourProgressiveLoanSchedule = loanProductsRequestFactory
                .defaultLoanProductsRequestLP2()//
                .name(name55)//
                .enableDownPayment(false)//
                .enableAutoRepaymentForDownPayment(null)//
                .disbursedAmountPercentageForDownPayment(null)//
                .transactionProcessingStrategyCode(ADVANCED_PAYMENT_ALLOCATION.getValue())//
                .loanScheduleType("PROGRESSIVE") //
                .loanScheduleProcessingType("HORIZONTAL")//
                .interestRateFrequencyType(3)//
                .maxInterestRatePerPeriod(10.0)//
                .paymentAllocation(List.of(//
                        createPaymentAllocation("DEFAULT", "NEXT_INSTALLMENT",
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_PENALTY, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_FEE, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_INTEREST, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_PRINCIPAL, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_PENALTY, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_FEE, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_INTEREST, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_PRINCIPAL, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_PENALTY, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_FEE, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_INTEREST, //
                                LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_PRINCIPAL), //
                        createPaymentAllocation("GOODWILL_CREDIT", "LAST_INSTALLMENT"), //
                        createPaymentAllocation("MERCHANT_ISSUED_REFUND", "REAMORTIZATION"), //
                        createPaymentAllocation("PAYOUT_REFUND", "NEXT_INSTALLMENT")))//
                .chargeOffBehaviour("ACCELERATE_MATURITY");//
        final Response<PostLoanProductsResponse> responseLoanProductsRequestAdvCustomAccelerateMaturityChargeOffBehaviourProgressiveLoanSchedule = loanProductsApi
                .createLoanProduct(loanProductsRequestAdvCustomAccelerateMaturityChargeOffBehaviourProgressiveLoanSchedule).execute();
        TestContext.INSTANCE.set(TestContextKey.DEFAULT_LOAN_PRODUCT_CREATE_RESPONSE_LP2_ADV_PYMNT_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR,
                responseLoanProductsRequestAdvCustomAccelerateMaturityChargeOffBehaviourProgressiveLoanSchedule);
    }

    public static AdvancedPaymentData createPaymentAllocation(String transactionType, String futureInstallmentAllocationRule,
            LoanProductPaymentAllocationRule.AllocationTypesEnum... rules) {
        AdvancedPaymentData advancedPaymentData = new AdvancedPaymentData();
        advancedPaymentData.setTransactionType(transactionType);
        advancedPaymentData.setFutureInstallmentAllocationRule(futureInstallmentAllocationRule);

        List<PaymentAllocationOrder> paymentAllocationOrders;
        if (rules.length == 0) {
            paymentAllocationOrders = getPaymentAllocationOrder(//
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_PENALTY, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_FEE, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_PRINCIPAL, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_INTEREST, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_PENALTY, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_FEE, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_PRINCIPAL, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_INTEREST, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_PENALTY, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_FEE, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_PRINCIPAL, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_INTEREST);//
        } else {
            paymentAllocationOrders = getPaymentAllocationOrder(rules);
        }

        advancedPaymentData.setPaymentAllocationOrder(paymentAllocationOrders);

        return advancedPaymentData;
    }

    public static AdvancedPaymentData createPaymentAllocationPenFeeIntPrincipal(String transactionType,
            String futureInstallmentAllocationRule, LoanProductPaymentAllocationRule.AllocationTypesEnum... rules) {
        AdvancedPaymentData advancedPaymentData = new AdvancedPaymentData();
        advancedPaymentData.setTransactionType(transactionType);
        advancedPaymentData.setFutureInstallmentAllocationRule(futureInstallmentAllocationRule);

        List<PaymentAllocationOrder> paymentAllocationOrders;
        if (rules.length == 0) {
            paymentAllocationOrders = getPaymentAllocationOrder(//
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_PENALTY, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_FEE, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_INTEREST, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.PAST_DUE_PRINCIPAL, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_PENALTY, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_FEE, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_INTEREST, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.DUE_PRINCIPAL, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_PENALTY, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_FEE, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_INTEREST, //
                    LoanProductPaymentAllocationRule.AllocationTypesEnum.IN_ADVANCE_PRINCIPAL);//
        } else {
            paymentAllocationOrders = getPaymentAllocationOrder(rules);
        }

        advancedPaymentData.setPaymentAllocationOrder(paymentAllocationOrders);

        return advancedPaymentData;
    }

    public static AdvancedPaymentData editPaymentAllocationFutureInstallment(String transactionType, String futureInstallmentAllocationRule,
            List<PaymentAllocationOrder> paymentAllocationOrder) {
        AdvancedPaymentData advancedPaymentData = new AdvancedPaymentData();
        advancedPaymentData.setTransactionType(transactionType);
        advancedPaymentData.setFutureInstallmentAllocationRule(futureInstallmentAllocationRule);
        advancedPaymentData.setPaymentAllocationOrder(paymentAllocationOrder);

        return advancedPaymentData;
    }

    private static CreditAllocationData createCreditAllocation(String transactionType, List<String> creditAllocationRules) {
        CreditAllocationData creditAllocationData = new CreditAllocationData();
        creditAllocationData.setTransactionType(transactionType);

        List<CreditAllocationOrder> creditAllocationOrders = new ArrayList<>();
        for (int i = 0; i < creditAllocationRules.size(); i++) {
            CreditAllocationOrder e = new CreditAllocationOrder();
            e.setOrder(i + 1);
            e.setCreditAllocationRule(creditAllocationRules.get(i));
            creditAllocationOrders.add(e);
        }

        creditAllocationData.setCreditAllocationOrder(creditAllocationOrders);
        return creditAllocationData;
    }

    private static List<PaymentAllocationOrder> getPaymentAllocationOrder(
            LoanProductPaymentAllocationRule.AllocationTypesEnum... paymentAllocations) {
        AtomicInteger integer = new AtomicInteger(1);
        return Arrays.stream(paymentAllocations).map(pat -> {
            PaymentAllocationOrder paymentAllocationOrder = new PaymentAllocationOrder();
            paymentAllocationOrder.setPaymentAllocationRule(pat.name());
            paymentAllocationOrder.setOrder(integer.getAndIncrement());
            return paymentAllocationOrder;
        }).toList();
    }
}
