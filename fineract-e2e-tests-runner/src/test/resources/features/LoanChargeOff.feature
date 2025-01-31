@ChargeOffFeature
Feature: Charge-off

  @TestRailId:C2565
  Scenario: As a user I want to do a Charge-off for non-fraud loan after disbursement
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "22 February 2023"
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name         | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable     |        | 1000.0 |
      | EXPENSE | 744007       | Credit Loss/Bad Debt | 1000.0 |        |

  @TestRailId:C2566
  Scenario: As a user I want to do a Charge-off for non-fraud loan after repayment
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "5 January 2023"
    And Customer makes "AUTOPAY" repayment on "5 January 2023" with 250 EUR transaction amount
    When Admin sets the business date to "22 February 2023"
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "REPAYMENT" transaction with date "05 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit | Credit |
      | ASSET     | 112601       | Loans Receivable          |       | 250.0  |
      | LIABILITY | 145023       | Suspense/Clearing account | 250.0 |        |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name         | Debit | Credit |
      | ASSET   | 112601       | Loans Receivable     |       | 750.0  |
      | EXPENSE | 744007       | Credit Loss/Bad Debt | 750.0 |        |

  @TestRailId:C2567
  Scenario: As a user I want to do a Repayment undo after Charge-off for non-fraud
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "5 January 2023"
    And Customer makes "AUTOPAY" repayment on "5 January 2023" with 250 EUR transaction amount
    When Admin sets the business date to "22 February 2023"
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    When Customer undo "1"th repayment on "05 January 2023"
    Then Loan status will be "ACTIVE"
    Then On Loan Transactions tab the "Repayment" Transaction with date "05 January 2023" is reverted
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "REPAYMENT" transaction with date "05 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit | Credit |
      | ASSET     | 112601       | Loans Receivable          |       | 250.0  |
      | LIABILITY | 145023       | Suspense/Clearing account | 250.0 |        |
      | ASSET     | 112601       | Loans Receivable          | 250.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |       | 250.0  |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name         | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable     |        | 1000.0 |
      | EXPENSE | 744007       | Credit Loss/Bad Debt | 1000.0 |        |

  @TestRailId:C2568
  Scenario: As a user I want to do Charge-off for fraud loan when FEE is added
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    And Admin adds an NSF fee because of payment bounce with "1 January 2023" transaction date
    When Admin sets the business date to "22 February 2023"
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name            | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable        |        | 1000.0 |
      | ASSET   | 112603       | Interest/Fee Receivable |        | 10.0   |
      | EXPENSE | 744007       | Credit Loss/Bad Debt    | 1000.0 |        |
      | INCOME  | 404008       | Fee Charge Off          | 10.0   |        |

  @TestRailId:C2569
  Scenario: As a user I want to do a Merchant Refund after charge-off (fee portion)
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    And Admin adds an NSF fee because of payment bounce with "1 January 2023" transaction date
    When Admin sets the business date to "22 February 2023"
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    When Admin makes "MERCHANT_ISSUED_REFUND" transaction with "AUTOPAY" payment type on "22 February 2023" with 100 EUR transaction amount
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name            | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable        |        | 1000.0 |
      | ASSET   | 112603       | Interest/Fee Receivable |        | 10.0   |
      | EXPENSE | 744007       | Credit Loss/Bad Debt    | 1000.0 |        |
      | INCOME  | 404008       | Fee Charge Off          | 10.0   |        |
    Then Loan Transactions tab has a "MERCHANT_ISSUED_REFUND" transaction with date "22 February 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit | Credit |
      | EXPENSE   | 744007       | Credit Loss/Bad Debt      |       | 90.0   |
      | INCOME    | 404008       | Fee Charge Off            |       | 10.0   |
      | LIABILITY | 145023       | Suspense/Clearing account | 100.0 |        |

  @TestRailId:C2570
  Scenario: As a user I want to do a Charge-off for non-fraud loan when FEE and PENALTY added
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    And Admin adds an NSF fee because of payment bounce with "1 January 2023" transaction date
    When Admin sets the business date to "22 February 2023"
    And Admin adds a 10 % Processing charge to the loan with "en" locale on date: "22 February 2023"
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name            | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable        |        | 1000.0 |
      | ASSET   | 112603       | Interest/Fee Receivable |        | 110.0  |
      | EXPENSE | 744007       | Credit Loss/Bad Debt    | 1000.0 |        |
      | INCOME  | 404008       | Fee Charge Off          | 110.0  |        |

  @Skip @TestRailId:C2571 @chargeoffOnLoanWithInterest
  Scenario: As a user I want to do Charge-off for non-fraud loan when FEE and PENALTY added (interest portion)
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct         | submitted on date | with Principal | ANNUAL interest rate % | interest type | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy                        |
      | LP1_INTEREST_FLAT | 1 January 2023    | 1000           | 12                     | FLAT          | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 3                 | MONTHS                | 1              | MONTHS                 | 3                  | 0                       | 0                      | 0                    | PENALTIES_FEES_INTEREST_PRINCIPAL_ORDER |
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    And Admin adds an NSF fee because of payment bounce with "1 January 2023" transaction date
    When Admin sets the business date to "22 February 2023"
    And Admin adds a 10 % Processing charge to the loan with "en" locale on date: "22 February 2023"
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name               | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable           |        | 1000.0 |
      | ASSET   | 112603       | Interest/Fee Receivable    |        | 143.0  |
      | EXPENSE | 744007       | Credit Loss/Bad Debt       | 1000.0 |        |
      | INCOME  | 404001       | Interest Income Charge Off | 30.0   |        |
      | INCOME  | 404008       | Fee Charge Off             | 113.0  |        |

  @Skip @TestRailId:C2572 @chargeoffOnLoanWithInterest
  Scenario: As a user I want to do a Merchant Refund after charge-off for non fraud loan (interest portion)
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct         | submitted on date | with Principal | ANNUAL interest rate % | interest type | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy                        |
      | LP1_INTEREST_FLAT | 1 January 2023    | 1000           | 12                     | FLAT          | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 3                 | MONTHS                | 1              | MONTHS                 | 3                  | 0                       | 0                      | 0                    | PENALTIES_FEES_INTEREST_PRINCIPAL_ORDER |
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    And Admin adds an NSF fee because of payment bounce with "1 January 2023" transaction date
    When Admin sets the business date to "22 February 2023"
    And Admin adds a 10 % Processing charge to the loan with "en" locale on date: "22 February 2023"
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    When Admin makes "MERCHANT_ISSUED_REFUND" transaction with "AUTOPAY" payment type on "22 February 2023" with 500 EUR transaction amount
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name               | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable           |        | 1000.0 |
      | ASSET   | 112603       | Interest/Fee Receivable    |        | 143.0  |
      | EXPENSE | 744007       | Credit Loss/Bad Debt       | 1000.0 |        |
      | INCOME  | 404001       | Interest Income Charge Off | 30.0   |        |
      | INCOME  | 404008       | Fee Charge Off             | 113.0  |        |
    Then Loan Transactions tab has a "MERCHANT_ISSUED_REFUND" transaction with date "22 February 2023" which has the following Journal entries:
      | Type      | Account code | Account name               | Debit | Credit |
      | EXPENSE   | 744007       | Credit Loss/Bad Debt       |       | 367.0  |
      | INCOME    | 404001       | Interest Income Charge Off |       | 20.0   |
      | INCOME    | 404008       | Fee Charge Off             |       | 113.0  |
      | LIABILITY | 145023       | Suspense/Clearing account  | 500.0 |        |


  @Skip @TestRailId:C2573 @chargeoffOnLoanWithInterest
  Scenario: As a user I want to do a Payout refund after charge-off for non fraud loan (interest portion)
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct         | submitted on date | with Principal | ANNUAL interest rate % | interest type | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy                        |
      | LP1_INTEREST_FLAT | 1 January 2023    | 1000           | 12                     | FLAT          | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 3                 | MONTHS                | 1              | MONTHS                 | 3                  | 0                       | 0                      | 0                    | PENALTIES_FEES_INTEREST_PRINCIPAL_ORDER |
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    And Admin adds an NSF fee because of payment bounce with "1 January 2023" transaction date
    When Admin sets the business date to "22 February 2023"
    And Admin adds a 10 % Processing charge to the loan with "en" locale on date: "22 February 2023"
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    When Admin makes "PAYOUT_REFUND" transaction with "AUTOPAY" payment type on "22 February 2023" with 500 EUR transaction amount
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name               | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable           |        | 1000.0 |
      | ASSET   | 112603       | Interest/Fee Receivable    |        | 143.0  |
      | EXPENSE | 744007       | Credit Loss/Bad Debt       | 1000.0 |        |
      | INCOME  | 404001       | Interest Income Charge Off | 30.0   |        |
      | INCOME  | 404008       | Fee Charge Off             | 113.0  |        |
    Then Loan Transactions tab has a "PAYOUT_REFUND" transaction with date "22 February 2023" which has the following Journal entries:
      | Type      | Account code | Account name               | Debit | Credit |
      | EXPENSE   | 744007       | Credit Loss/Bad Debt       |       | 367.0  |
      | INCOME    | 404001       | Interest Income Charge Off |       | 20.0   |
      | INCOME    | 404008       | Fee Charge Off             |       | 113.0  |
      | LIABILITY | 145023       | Suspense/Clearing account  | 500.0 |        |

  @Skip @TestRailId:C2574 @chargeoffOnLoanWithInterest
  Scenario:  As a user I want to do a Repayment after Charge-off for fraud loan when FEE and PENALTY added (product with interest)
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct         | submitted on date | with Principal | ANNUAL interest rate % | interest type | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy                        |
      | LP1_INTEREST_FLAT | 1 January 2023    | 1000           | 12                     | FLAT          | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 3                 | MONTHS                | 1              | MONTHS                 | 3                  | 0                       | 0                      | 0                    | PENALTIES_FEES_INTEREST_PRINCIPAL_ORDER |
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    And Admin adds an NSF fee because of payment bounce with "1 January 2023" transaction date
    When Admin sets the business date to "22 February 2023"
    And Admin adds a 10 % Processing charge to the loan with "en" locale on date: "22 February 2023"
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    When Customer makes "REPAYMENT" transaction with "AUTOPAY" payment type on "22 February 2023" with 500 EUR transaction amount and system-generated Idempotency key
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name               | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable           |        | 1000.0 |
      | ASSET   | 112603       | Interest/Fee Receivable    |        | 143.0  |
      | EXPENSE | 744007       | Credit Loss/Bad Debt       | 1000.0 |        |
      | INCOME  | 404001       | Interest Income Charge Off | 30.0   |        |
      | INCOME  | 404008       | Fee Charge Off             | 113.0  |        |
    Then Loan Transactions tab has a "REPAYMENT" transaction with date "22 February 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit | Credit |
      | INCOME    | 744008       | Recoveries                |       | 500.0  |
      | LIABILITY | 145023       | Suspense/Clearing account | 500.0 |        |


  @TestRailId:C2575
  Scenario: As a user I want to do a Charge-off for fraud loan after disbursement
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "22 February 2023"
    Then Admin can successfully set Fraud flag to the loan
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name               | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable           |        | 1000.0 |
      | EXPENSE | 744037       | Credit Loss/Bad Debt-Fraud | 1000.0 |        |

  @TestRailId:C2576
  Scenario: As a user I want to do a Repayment undo after Charge-off for fraud loan
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "5 January 2023"
    And Customer makes "AUTOPAY" repayment on "5 January 2023" with 250 EUR transaction amount
    When Admin sets the business date to "22 February 2023"
    Then Admin can successfully set Fraud flag to the loan
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    When Customer undo "1"th repayment on "05 January 2023"
    Then Loan status will be "ACTIVE"
    Then On Loan Transactions tab the "Repayment" Transaction with date "05 January 2023" is reverted
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "REPAYMENT" transaction with date "05 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit | Credit |
      | ASSET     | 112601       | Loans Receivable          |       | 250.0  |
      | LIABILITY | 145023       | Suspense/Clearing account | 250.0 |        |
      | ASSET     | 112601       | Loans Receivable          | 250.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |       | 250.0  |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name               | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable           |        | 1000.0 |
      | EXPENSE | 744037       | Credit Loss/Bad Debt-Fraud | 1000.0 |        |

  @TestRailId:C2577
  Scenario: As a user I want to do a Charge-off for fraud loan when FEE is added
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    And Admin adds an NSF fee because of payment bounce with "1 January 2023" transaction date
    When Admin sets the business date to "22 February 2023"
    Then Admin can successfully set Fraud flag to the loan
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name               | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable           |        | 1000.0 |
      | ASSET   | 112603       | Interest/Fee Receivable    |        | 10.0   |
      | EXPENSE | 744037       | Credit Loss/Bad Debt-Fraud | 1000.0 |        |
      | INCOME  | 404008       | Fee Charge Off             | 10.0   |        |

  @TestRailId:C2578
  Scenario: As a user I want to do a Charge-off for fraud loan when FEE and PENALTY added
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    And Admin adds an NSF fee because of payment bounce with "1 January 2023" transaction date
    When Admin sets the business date to "22 February 2023"
    And Admin adds a 10 % Processing charge to the loan with "en" locale on date: "22 February 2023"
    Then Admin can successfully set Fraud flag to the loan
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name               | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable           |        | 1000.0 |
      | ASSET   | 112603       | Interest/Fee Receivable    |        | 110.0  |
      | EXPENSE | 744037       | Credit Loss/Bad Debt-Fraud | 1000.0 |        |
      | INCOME  | 404008       | Fee Charge Off             | 110.0  |        |

  @Skip @TestRailId:C2579 @chargeoffOnLoanWithInterest
  Scenario: As a user I want to do a Charge-off for fraud loan when FEE and PENALTY added (interest portion)
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct         | submitted on date | with Principal | ANNUAL interest rate % | interest type | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy                        |
      | LP1_INTEREST_FLAT | 1 January 2023    | 1000           | 12                     | FLAT          | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 3                 | MONTHS                | 1              | MONTHS                 | 3                  | 0                       | 0                      | 0                    | PENALTIES_FEES_INTEREST_PRINCIPAL_ORDER |
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    And Admin adds an NSF fee because of payment bounce with "1 January 2023" transaction date
    When Admin sets the business date to "22 February 2023"
    And Admin adds a 10 % Processing charge to the loan with "en" locale on date: "22 February 2023"
    Then Admin can successfully set Fraud flag to the loan
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name               | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable           |        | 1000.0 |
      | ASSET   | 112603       | Interest/Fee Receivable    |        | 143.0  |
      | EXPENSE | 744037       | Credit Loss/Bad Debt-Fraud | 1000.0 |        |
      | INCOME  | 404001       | Interest Income Charge Off | 30.0   |        |
      | INCOME  | 404008       | Fee Charge Off             | 113.0  |        |

  @Skip @TestRailId:C2580 @chargeoffOnLoanWithInterest
  Scenario: As a user I want to do a Merchant issue refund for fraud loan when FEE and PENALTY added (interest portion)
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct         | submitted on date | with Principal | ANNUAL interest rate % | interest type | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy                        |
      | LP1_INTEREST_FLAT | 1 January 2023    | 1000           | 12                     | FLAT          | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 3                 | MONTHS                | 1              | MONTHS                 | 3                  | 0                       | 0                      | 0                    | PENALTIES_FEES_INTEREST_PRINCIPAL_ORDER |
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    And Admin adds an NSF fee because of payment bounce with "1 January 2023" transaction date
    When Admin sets the business date to "22 February 2023"
    And Admin adds a 10 % Processing charge to the loan with "en" locale on date: "22 February 2023"
    Then Admin can successfully set Fraud flag to the loan
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    When Admin makes "MERCHANT_ISSUED_REFUND" transaction with "AUTOPAY" payment type on "22 February 2023" with 500 EUR transaction amount
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name               | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable           |        | 1000.0 |
      | ASSET   | 112603       | Interest/Fee Receivable    |        | 143.0  |
      | EXPENSE | 744037       | Credit Loss/Bad Debt-Fraud | 1000.0 |        |
      | INCOME  | 404001       | Interest Income Charge Off | 30.0   |        |
      | INCOME  | 404008       | Fee Charge Off             | 113.0  |        |
    Then Loan Transactions tab has a "MERCHANT_ISSUED_REFUND" transaction with date "22 February 2023" which has the following Journal entries:
      | Type      | Account code | Account name               | Debit | Credit |
      | EXPENSE   | 744037       | Credit Loss/Bad Debt-Fraud |       | 367.0  |
      | INCOME    | 404001       | Interest Income Charge Off |       | 20.0   |
      | INCOME    | 404008       | Fee Charge Off             |       | 113.0  |
      | LIABILITY | 145023       | Suspense/Clearing account  | 500.0 |        |

  @Skip @TestRailId:C2581 @chargeoffOnLoanWithInterest
  Scenario: As a user I want to do Payout refund for fraud loan when FEE and PENALTY added (interest portion)
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct         | submitted on date | with Principal | ANNUAL interest rate % | interest type | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy                        |
      | LP1_INTEREST_FLAT | 1 January 2023    | 1000           | 12                     | FLAT          | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 3                 | MONTHS                | 1              | MONTHS                 | 3                  | 0                       | 0                      | 0                    | PENALTIES_FEES_INTEREST_PRINCIPAL_ORDER |
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    And Admin adds an NSF fee because of payment bounce with "1 January 2023" transaction date
    When Admin sets the business date to "22 February 2023"
    And Admin adds a 10 % Processing charge to the loan with "en" locale on date: "22 February 2023"
    Then Admin can successfully set Fraud flag to the loan
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    When Customer makes "PAYOUT_REFUND" transaction with "AUTOPAY" payment type on "22 February 2023" with 500 EUR transaction amount and system-generated Idempotency key
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name               | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable           |        | 1000.0 |
      | ASSET   | 112603       | Interest/Fee Receivable    |        | 143.0  |
      | EXPENSE | 744037       | Credit Loss/Bad Debt-Fraud | 1000.0 |        |
      | INCOME  | 404001       | Interest Income Charge Off | 30.0   |        |
      | INCOME  | 404008       | Fee Charge Off             | 113.0  |        |
    Then Loan Transactions tab has a "PAYOUT_REFUND" transaction with date "22 February 2023" which has the following Journal entries:
      | Type      | Account code | Account name               | Debit | Credit |
      | EXPENSE   | 744037       | Credit Loss/Bad Debt-Fraud |       | 367.0  |
      | INCOME    | 404001       | Interest Income Charge Off |       | 20.0   |
      | INCOME    | 404008       | Fee Charge Off             |       | 113.0  |
      | LIABILITY | 145023       | Suspense/Clearing account  | 500.0 |        |


  @Skip @TestRailId:C2582 @chargeoffOnLoanWithInterest
  Scenario: As a user I want to do a Repayment after Charge-off for fraud loan when FEE and PENALTY added
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct         | submitted on date | with Principal | ANNUAL interest rate % | interest type | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy                        |
      | LP1_INTEREST_FLAT | 1 January 2023    | 1000           | 12                     | FLAT          | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 3                 | MONTHS                | 1              | MONTHS                 | 3                  | 0                       | 0                      | 0                    | PENALTIES_FEES_INTEREST_PRINCIPAL_ORDER |
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    And Admin adds an NSF fee because of payment bounce with "1 January 2023" transaction date
    When Admin sets the business date to "22 February 2023"
    And Admin adds a 10 % Processing charge to the loan with "en" locale on date: "22 February 2023"
    Then Admin can successfully set Fraud flag to the loan
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    When Customer makes "REPAYMENT" transaction with "AUTOPAY" payment type on "22 February 2023" with 500 EUR transaction amount and system-generated Idempotency key
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name               | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable           |        | 1000.0 |
      | ASSET   | 112603       | Interest/Fee Receivable    |        | 143.0  |
      | EXPENSE | 744037       | Credit Loss/Bad Debt-Fraud | 1000.0 |        |
      | INCOME  | 404001       | Interest Income Charge Off | 30.0   |        |
      | INCOME  | 404008       | Fee Charge Off             | 113.0  |        |
    Then Loan Transactions tab has a "REPAYMENT" transaction with date "22 February 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit | Credit |
      | INCOME    | 744008       | Recoveries                |       | 500.0  |
      | LIABILITY | 145023       | Suspense/Clearing account | 500.0 |        |


  @Skip @TestRailId:C2591 @chargeoffOnLoanWithInterest
  Scenario: As a user I want to repay a loan which was charged-off
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct         | submitted on date | with Principal | ANNUAL interest rate % | interest type | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy                        |
      | LP1_INTEREST_FLAT | 1 January 2023    | 1000           | 12                     | FLAT          | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 3                 | MONTHS                | 1              | MONTHS                 | 3                  | 0                       | 0                      | 0                    | PENALTIES_FEES_INTEREST_PRINCIPAL_ORDER |
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    And Admin adds an NSF fee because of payment bounce with "1 January 2023" transaction date
    When Admin sets the business date to "22 February 2023"
    And Admin adds a 10 % Processing charge to the loan with "en" locale on date: "22 February 2023"
    Then Admin can successfully set Fraud flag to the loan
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    When Customer makes "REPAYMENT" transaction with "AUTOPAY" payment type on "22 February 2023" with 500 EUR transaction amount and system-generated Idempotency key
    Then Loan status will be "ACTIVE"
    When Admin sets the business date to "23 February 2023"
    When Customer makes "REPAYMENT" transaction with "AUTOPAY" payment type on "23 February 2023" with 643 EUR transaction amount and system-generated Idempotency key
    Then Loan status will be "CLOSED_OBLIGATIONS_MET"
    Then Loan marked as charged-off on "22 February 2023"
    Then Loan has 0 outstanding amount
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due    | Paid   | In advance | Late   | Outstanding |
      |    |      | 01 January 2023  |                  | 1000.0          |               |          | 0.0   |           | 0.0    | 0.0    |            |        |             |
      | 1  | 31   | 01 February 2023 | 22 February 2023 | 666.67          | 333.33        | 10.0     | 0.0   | 10.0      | 353.33 | 353.33 | 0.0        | 343.33 | 0.0         |
      | 2  | 28   | 01 March 2023    | 23 February 2023 | 333.34          | 333.33        | 10.0     | 103.0 | 0.0       | 446.33 | 446.33 | 446.33     | 0.0    | 0.0         |
      | 3  | 31   | 01 April 2023    | 23 February 2023 | 0.0             | 333.34        | 10.0     | 0.0   | 0.0       | 343.34 | 343.34 | 343.34     | 0.0    | 0.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late   | Outstanding |
      | 1000          | 30       | 103  | 10        | 1143 | 1143 | 789.67     | 343.33 | 0           |
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name               | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable           |        | 1000.0 |
      | ASSET   | 112603       | Interest/Fee Receivable    |        | 143.0  |
      | EXPENSE | 744037       | Credit Loss/Bad Debt-Fraud | 1000.0 |        |
      | INCOME  | 404001       | Interest Income Charge Off | 30.0   |        |
      | INCOME  | 404008       | Fee Charge Off             | 113.0  |        |
    Then Loan Transactions tab has a "REPAYMENT" transaction with date "22 February 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit | Credit |
      | INCOME    | 744008       | Recoveries                |       | 500.0  |
      | LIABILITY | 145023       | Suspense/Clearing account | 500.0 |        |
    Then Loan Transactions tab has a "ACCRUAL" transaction with date "23 February 2023" which has the following Journal entries:
      | Type   | Account code | Account name            | Debit | Credit |
      | ASSET  | 112603       | Interest/Fee Receivable | 30.0  |        |
      | INCOME | 404000       | Interest Income         |       | 30.0   |
      | ASSET  | 112603       | Interest/Fee Receivable | 103.0 |        |
      | INCOME | 404007       | Fee Income              |       | 103.0  |
      | ASSET  | 112603       | Interest/Fee Receivable | 10.0  |        |
      | INCOME | 404007       | Fee Income              |       | 10.0   |
    Then Loan Transactions tab has a "REPAYMENT" transaction with date "23 February 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit | Credit |
      | INCOME    | 744008       | Recoveries                |       | 643.0  |
      | LIABILITY | 145023       | Suspense/Clearing account | 643.0 |        |

  @Skip @TestRailId:C2592 @chargeoffOnLoanWithInterest
  Scenario: As a user I want to do a charge-off undo before any other transactions on the loan
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct         | submitted on date | with Principal | ANNUAL interest rate % | interest type | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy                        |
      | LP1_INTEREST_FLAT | 1 January 2023    | 1000           | 12                     | FLAT          | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 3                 | MONTHS                | 1              | MONTHS                 | 3                  | 0                       | 0                      | 0                    | PENALTIES_FEES_INTEREST_PRINCIPAL_ORDER |
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    And Admin adds an NSF fee because of payment bounce with "1 January 2023" transaction date
    When Admin sets the business date to "22 February 2023"
    And Admin adds a 10 % Processing charge to the loan with "en" locale on date: "22 February 2023"
    Then Admin can successfully set Fraud flag to the loan
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due    | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 1000.0          |               |          | 0.0   |           | 0.0    | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 666.67          | 333.33        | 10.0     | 0.0   | 10.0      | 353.33 | 0.0  | 0.0        | 0.0  | 353.33      |
      | 2  | 28   | 01 March 2023    |           | 333.34          | 333.33        | 10.0     | 103.0 | 0.0       | 446.33 | 0.0  | 0.0        | 0.0  | 446.33      |
      | 3  | 31   | 01 April 2023    |           | 0.0             | 333.34        | 10.0     | 0.0   | 0.0       | 343.34 | 0.0  | 0.0        | 0.0  | 343.34      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 30       | 103  | 10        | 1143 | 0    | 0          | 0    | 1143        |
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name               | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable           |        | 1000.0 |
      | ASSET   | 112603       | Interest/Fee Receivable    |        | 143.0  |
      | EXPENSE | 744037       | Credit Loss/Bad Debt-Fraud | 1000.0 |        |
      | INCOME  | 404001       | Interest Income Charge Off | 30.0   |        |
      | INCOME  | 404008       | Fee Charge Off             | 113.0  |        |
    Then Admin does a charge-off undo the loan
    When Admin sets the business date to "23 February 2023"
    When Customer makes "REPAYMENT" transaction with "AUTOPAY" payment type on "23 February 2023" with 200 EUR transaction amount and system-generated Idempotency key
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name               | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable           |        | 1000.0 |
      | ASSET   | 112603       | Interest/Fee Receivable    |        | 143.0  |
      | EXPENSE | 744037       | Credit Loss/Bad Debt-Fraud | 1000.0 |        |
      | INCOME  | 404001       | Interest Income Charge Off | 30.0   |        |
      | INCOME  | 404008       | Fee Charge Off             | 113.0  |        |
      | ASSET   | 112601       | Loans Receivable           | 1000.0 |        |
      | ASSET   | 112603       | Interest/Fee Receivable    | 143.0  |        |
      | EXPENSE | 744037       | Credit Loss/Bad Debt-Fraud |        | 1000.0 |
      | INCOME  | 404001       | Interest Income Charge Off |        | 30.0   |
      | INCOME  | 404008       | Fee Charge Off             |        | 113.0  |
    Then Loan Transactions tab has a "REPAYMENT" transaction with date "23 February 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit | Credit |
      | ASSET     | 112601       | Loans Receivable          |       | 180.0  |
      | ASSET     | 112603       | Interest/Fee Receivable   |       | 20.0   |
      | LIABILITY | 145023       | Suspense/Clearing account | 200.0 |        |

  @TestRailId:C2593
  Scenario: As a user I want to do a Charge-off before the last repayment
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "22 February 2023"
    When Customer makes "REPAYMENT" transaction with "AUTOPAY" payment type on "22 February 2023" with 200 EUR transaction amount and system-generated Idempotency key
    When Admin sets the business date to "23 February 2023"
    Then Charge-off undo is not possible on "21 February 2023"
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid  | In advance | Late  | Outstanding |
      |    |      | 01 January 2023 |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0   |            |       |             |
      | 1  | 30   | 31 January 2023 |           | 0.0             | 1000.0        | 0.0      | 0.0  | 0.0       | 1000.0 | 200.0 | 0.0        | 200.0 | 800.0       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 0    | 0         | 1000 | 200  | 0          | 200  | 800         |
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "REPAYMENT" transaction with date "22 February 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit | Credit |
      | ASSET     | 112601       | Loans Receivable          |       | 200.0  |
      | LIABILITY | 145023       | Suspense/Clearing account | 200.0 |        |

  @TestRailId:C2594
  Scenario: As a user I want to do a Charge-off between 2 repayments
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "22 February 2023"
    When Customer makes "REPAYMENT" transaction with "AUTOPAY" payment type on "22 February 2023" with 200 EUR transaction amount and system-generated Idempotency key
    When Admin sets the business date to "24 February 2023"
    When Customer makes "REPAYMENT" transaction with "AUTOPAY" payment type on "24 February 2023" with 200 EUR transaction amount and system-generated Idempotency key
    When Admin sets the business date to "25 February 2023"
    Then Charge-off undo is not possible on "23 February 2023"
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid  | In advance | Late  | Outstanding |
      |    |      | 01 January 2023 |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0   |            |       |             |
      | 1  | 30   | 31 January 2023 |           | 0.0             | 1000.0        | 0.0      | 0.0  | 0.0       | 1000.0 | 400.0 | 0.0        | 400.0 | 600.0       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 0    | 0         | 1000 | 400  | 0          | 400  | 600         |
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "REPAYMENT" transaction with date "22 February 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit | Credit |
      | ASSET     | 112601       | Loans Receivable          |       | 200.0  |
      | LIABILITY | 145023       | Suspense/Clearing account | 200.0 |        |

  @TestRailId:C2595
  Scenario: As a user I want to do a backdated Charge-off when only disbursement transaction happened
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "22 February 2023"
    And Admin does charge-off the loan on "10 February 2023"
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023 |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0  |            |      |             |
      | 1  | 30   | 31 January 2023 |           | 0.0             | 1000.0        | 0.0      | 0.0  | 0.0       | 1000.0 | 0.0  | 0.0        | 0.0  | 1000.0      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 0    | 0         | 1000 | 0    | 0          | 0    | 1000        |
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "10 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name         | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable     |        | 1000.0 |
      | EXPENSE | 744007       | Credit Loss/Bad Debt | 1000.0 |        |

  @TestRailId:C2596
  Scenario: As a user I want to do an undo on a transaction which was created before the Charge-off
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "22 February 2023"
    And Customer makes "AUTOPAY" repayment on "22 January 2023" with 250 EUR transaction amount
    When Admin sets the business date to "23 February 2023"
    And Admin does charge-off the loan on "23 February 2023"
    When Customer undo "1"th repayment on "22 January 2023"
    Then On Loan Transactions tab the "Repayment" Transaction with date "22 January 2023" is reverted
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023 |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0  |            |      |             |
      | 1  | 30   | 31 January 2023 |           | 0.0             | 1000.0        | 0.0      | 0.0  | 0.0       | 1000.0 | 0.0  | 0.0        | 0.0  | 1000.0      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 0    | 0         | 1000 | 0    | 0          | 0    | 1000        |

  @TestRailId:C2597
  Scenario: As a user I want to do an undo on a transaction which was created on the Charge-off day
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "22 February 2023"
    And Customer makes "AUTOPAY" repayment on "22 January 2023" with 250 EUR transaction amount
    And Admin does charge-off the loan on "22 February 2023"
    When Customer undo "1"th repayment on "22 January 2023"
    Then On Loan Transactions tab the "Repayment" Transaction with date "22 January 2023" is reverted
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023 |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0  |            |      |             |
      | 1  | 30   | 31 January 2023 |           | 0.0             | 1000.0        | 0.0      | 0.0  | 0.0       | 1000.0 | 0.0  | 0.0        | 0.0  | 1000.0      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 0    | 0         | 1000 | 0    | 0          | 0    | 1000        |

  @TestRailId:C2598
  Scenario: As a user I want to do a second Charge-off
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "22 February 2023"
    And Admin does charge-off the loan on "22 February 2023"
    Then Second Charge-off is not possible on "22 February 2023"
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023 |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0  |            |      |             |
      | 1  | 30   | 31 January 2023 |           | 0.0             | 1000.0        | 0.0      | 0.0  | 0.0       | 1000.0 | 0.0  | 0.0        | 0.0  | 1000.0      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 0    | 0         | 1000 | 0    | 0          | 0    | 1000        |
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name         | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable     |        | 1000.0 |
      | EXPENSE | 744007       | Credit Loss/Bad Debt | 1000.0 |        |

  @TestRailId:C2599
  Scenario: As a user I want to do a second Charge-off undo
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "22 February 2023"
    And Admin does charge-off the loan on "22 February 2023"
    When Admin does a charge-off undo the loan
    And Charge-off undo is not possible as the loan is not charged-off
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023 |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0  |            |      |             |
      | 1  | 30   | 31 January 2023 |           | 0.0             | 1000.0        | 0.0      | 0.0  | 0.0       | 1000.0 | 0.0  | 0.0        | 0.0  | 1000.0      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 0    | 0         | 1000 | 0    | 0          | 0    | 1000        |
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |

  @TestRailId:C2600
  Scenario: As a user I want to add charge after Charge-off
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "22 February 2023"
    And Admin does charge-off the loan on "22 February 2023"
    When Admin is not able to add "LOAN_SNOOZE_FEE" due date charge with "22 February 2023" due date and 200 EUR transaction amount because the of charged-off account
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023 |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0  |            |      |             |
      | 1  | 30   | 31 January 2023 |           | 0.0             | 1000.0        | 0.0      | 0.0  | 0.0       | 1000.0 | 0.0  | 0.0        | 0.0  | 1000.0      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 0    | 0         | 1000 | 0    | 0          | 0    | 1000        |
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name         | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable     |        | 1000.0 |
      | EXPENSE | 744007       | Credit Loss/Bad Debt | 1000.0 |        |

  @TestRailId:C2706
  Scenario: Verify that Charge-off NOT results an error anymore when to be applied on a loan with an interest
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct         | submitted on date | with Principal | ANNUAL interest rate % | interest type | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy                        |
      | LP1_INTEREST_FLAT | 1 January 2023    | 1000           | 12                     | FLAT          | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 3                 | MONTHS                | 1              | MONTHS                 | 3                  | 0                       | 0                      | 0                    | PENALTIES_FEES_INTEREST_PRINCIPAL_ORDER |
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    And Admin adds an NSF fee because of payment bounce with "1 January 2023" transaction date
    When Admin sets the business date to "22 February 2023"
    And Admin adds a 10 % Processing charge to the loan with "en" locale on date: "22 February 2023"
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 1000.0          |               |          | 0.0   |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 667.0           | 333.0         | 10.0     | 0.0   | 10.0      | 353.0 | 0.0  | 0.0        | 0.0  | 353.0       |
      | 2  | 28   | 01 March 2023    |           | 334.0           | 333.0         | 10.0     | 103.0 | 0.0       | 446.0 | 0.0  | 0.0        | 0.0  | 446.0       |
      | 3  | 31   | 01 April 2023    |           | 0.0             | 334.0         | 10.0     | 0.0   | 0.0       | 344.0 | 0.0  | 0.0        | 0.0  | 344.0       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 30       | 103  | 10        | 1143 | 0    | 0          | 0    | 1143        |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0   | 0.0       | 1000.0       |
      | 22 February 2023 | Charge-off       | 1143.0 | 1000.0    | 30.0     | 103.0 | 10.0      | 0.0          |

  @TestRailId:C2761
  Scenario: Verify that charge-off is reversed/replayed if Scheduled repayment which was placed on a date before the charge-off is reversed after the charge-off
    When Admin sets the business date to "01 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "01 January 2023"
    And Admin successfully approves the loan on "01 January 2023" with "1000" amount and expected disbursement date on "01 January 2023"
    And Admin successfully disburse the loan on "01 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "25 January 2023"
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "25 January 2023" due date and 20 EUR transaction amount
    When Admin sets the business date to "01 March 2023"
    When Customer makes "REPAYMENT" transaction with "SCHEDULED" payment type on "01 March 2023" with 1000 EUR transaction amount and system-generated Idempotency key
    When Admin sets the business date to "01 June 2023"
    And Admin does charge-off the loan on "01 June 2023"
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid   | In advance | Late   | Outstanding |
      |    |      | 01 January 2023 |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0    |            |        |             |
      | 1  | 30   | 31 January 2023 |           | 0.0             | 1000.0        | 0.0      | 20.0 | 0.0       | 1020.0 | 1000.0 | 0.0        | 1000.0 | 20.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 20   | 0         | 1020 | 1000 | 0          | 1000 | 20          |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 01 March 2023    | Repayment        | 1000.0 | 980.0     | 0.0      | 20.0 | 0.0       | 20.0         |
      | 01 June 2023     | Charge-off       | 20.0   | 20.0      | 0.0      | 0.0  | 0.0       | 0.0          |
    When Admin sets the business date to "05 June 2023"
    When Customer undo "1"th "Repayment" transaction made on "01 March 2023"
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023 |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0  |            |      |             |
      | 1  | 30   | 31 January 2023 |           | 0.0             | 1000.0        | 0.0      | 20.0 | 0.0       | 1020.0 | 0.0  | 0.0        | 0.0  | 1020.0      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 20   | 0         | 1020 | 0    | 0          | 0    | 1020        |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 01 March 2023    | Repayment        | 1000.0 | 980.0     | 0.0      | 20.0 | 0.0       | 20.0         |
      | 01 June 2023     | Charge-off       | 1020.0 | 1000.0    | 0.0      | 20.0 | 0.0       | 0.0          |
    Then On Loan Transactions tab the "Repayment" Transaction with date "01 March 2023" is reverted

  @TestRailId:C2762
  Scenario: Verify that charge-off is reversed/replayed if Real time repayment which was placed on a date before the charge-off is reversed after the charge-off
    When Admin sets the business date to "01 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "01 January 2023"
    And Admin successfully approves the loan on "01 January 2023" with "1000" amount and expected disbursement date on "01 January 2023"
    And Admin successfully disburse the loan on "01 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "25 January 2023"
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "25 January 2023" due date and 20 EUR transaction amount
    When Admin sets the business date to "10 February 2023"
    When Customer makes "REPAYMENT" transaction with "REAL_TIME" payment type on "10 February 2023" with 1020 EUR transaction amount and system-generated Idempotency key
    When Admin sets the business date to "15 February 2023"
    When Admin adds "LOAN_NSF_FEE" due date charge with "15 February 2023" due date and 15 EUR transaction amount
    When Admin sets the business date to "01 June 2023"
    And Admin does charge-off the loan on "01 June 2023"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid   | In advance | Late   | Outstanding |
      |    |      | 01 January 2023  |                  | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0    |            |        |             |
      | 1  | 30   | 31 January 2023  | 10 February 2023 | 0.0             | 1000.0        | 0.0      | 20.0 | 0.0       | 1020.0 | 1020.0 | 0.0        | 1020.0 | 0.0         |
      | 2  | 15   | 15 February 2023 |                  | 0.0             | 0.0           | 0.0      | 0.0  | 15.0      | 15.0   | 0.0    | 0.0        | 0.0    | 15.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 20   | 15        | 1035 | 1020 | 0          | 1020 | 15          |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 10 February 2023 | Repayment        | 1020.0 | 1000.0    | 0.0      | 20.0 | 0.0       | 0.0          |
      | 10 February 2023 | Accrual          | 20.0   | 0.0       | 0.0      | 20.0 | 0.0       | 0.0          |
      | 01 June 2023     | Charge-off       | 15.0   | 0.0       | 0.0      | 0.0  | 15.0      | 0.0          |
    When Admin sets the business date to "10 June 2023"
    When Customer undo "1"th "Repayment" transaction made on "10 February 2023"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0  |            |      |             |
      | 1  | 30   | 31 January 2023  |           | 0.0             | 1000.0        | 0.0      | 20.0 | 0.0       | 1020.0 | 0.0  | 0.0        | 0.0  | 1020.0      |
      | 2  | 15   | 15 February 2023 |           | 0.0             | 0.0           | 0.0      | 0.0  | 15.0      | 15.0   | 0.0  | 0.0        | 0.0  | 15.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 20   | 15        | 1035 | 0    | 0          | 0    | 1035        |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 10 February 2023 | Repayment        | 1020.0 | 1000.0    | 0.0      | 20.0 | 0.0       | 0.0          |
      | 10 February 2023 | Accrual          | 20.0   | 0.0       | 0.0      | 20.0 | 0.0       | 0.0          |
      | 01 June 2023     | Charge-off       | 1035.0 | 1000.0    | 0.0      | 20.0 | 15.0      | 0.0          |
    Then On Loan Transactions tab the "Repayment" Transaction with date "10 February 2023" is reverted

  @TestRailId:C2763
  Scenario: Verify that charge-off is reversed/replayed if Autopay repayment which was placed on a date before the charge-off is reversed after the charge-off
    When Admin sets the business date to "01 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "01 January 2023"
    And Admin successfully approves the loan on "01 January 2023" with "1000" amount and expected disbursement date on "01 January 2023"
    And Admin successfully disburse the loan on "01 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "25 January 2023"
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "25 January 2023" due date and 20 EUR transaction amount
    When Admin sets the business date to "10 February 2023"
    When Customer makes "REPAYMENT" transaction with "AUTOPAY" payment type on "10 February 2023" with 1020 EUR transaction amount and system-generated Idempotency key
    When Admin sets the business date to "15 February 2023"
    When Admin adds "LOAN_NSF_FEE" due date charge with "15 February 2023" due date and 15 EUR transaction amount
    When Admin sets the business date to "01 June 2023"
    And Admin does charge-off the loan on "01 June 2023"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid   | In advance | Late   | Outstanding |
      |    |      | 01 January 2023  |                  | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0    |            |        |             |
      | 1  | 30   | 31 January 2023  | 10 February 2023 | 0.0             | 1000.0        | 0.0      | 20.0 | 0.0       | 1020.0 | 1020.0 | 0.0        | 1020.0 | 0.0         |
      | 2  | 15   | 15 February 2023 |                  | 0.0             | 0.0           | 0.0      | 0.0  | 15.0      | 15.0   | 0.0    | 0.0        | 0.0    | 15.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 20   | 15        | 1035 | 1020 | 0          | 1020 | 15          |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 10 February 2023 | Repayment        | 1020.0 | 1000.0    | 0.0      | 20.0 | 0.0       | 0.0          |
      | 10 February 2023 | Accrual          | 20.0   | 0.0       | 0.0      | 20.0 | 0.0       | 0.0          |
      | 01 June 2023     | Charge-off       | 15.0   | 0.0       | 0.0      | 0.0  | 15.0      | 0.0          |
    When Admin sets the business date to "10 June 2023"
    When Customer undo "1"th "Repayment" transaction made on "10 February 2023"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0  |            |      |             |
      | 1  | 30   | 31 January 2023  |           | 0.0             | 1000.0        | 0.0      | 20.0 | 0.0       | 1020.0 | 0.0  | 0.0        | 0.0  | 1020.0      |
      | 2  | 15   | 15 February 2023 |           | 0.0             | 0.0           | 0.0      | 0.0  | 15.0      | 15.0   | 0.0  | 0.0        | 0.0  | 15.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 20   | 15        | 1035 | 0    | 0          | 0    | 1035        |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 10 February 2023 | Repayment        | 1020.0 | 1000.0    | 0.0      | 20.0 | 0.0       | 0.0          |
      | 10 February 2023 | Accrual          | 20.0   | 0.0       | 0.0      | 20.0 | 0.0       | 0.0          |
      | 01 June 2023     | Charge-off       | 1035.0 | 1000.0    | 0.0      | 20.0 | 15.0      | 0.0          |
    Then On Loan Transactions tab the "Repayment" Transaction with date "10 February 2023" is reverted

  @TestRailId:C2764
  Scenario: Verify that charge-off is NOT reversed/replayed if OCA repayment which was placed and reversed on a date after the charge-off
    When Admin sets the business date to "01 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "01 January 2023"
    And Admin successfully approves the loan on "01 January 2023" with "1000" amount and expected disbursement date on "01 January 2023"
    And Admin successfully disburse the loan on "01 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "25 January 2023"
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "25 January 2023" due date and 20 EUR transaction amount
    When Admin sets the business date to "01 June 2023"
    And Admin does charge-off the loan on "01 June 2023"
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023 |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0  |            |      |             |
      | 1  | 30   | 31 January 2023 |           | 0.0             | 1000.0        | 0.0      | 20.0 | 0.0       | 1020.0 | 0.0  | 0.0        | 0.0  | 1020.0      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 20   | 0         | 1020 | 0    | 0          | 0    | 1020        |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 01 June 2023     | Charge-off       | 1020.0 | 1000.0    | 0.0      | 20.0 | 0.0       | 0.0          |
    When Admin sets the business date to "10 June 2023"
    When Customer makes "REPAYMENT" transaction with "OCA_PAYMENT" payment type on "10 June 2023" with 1000 EUR transaction amount and system-generated Idempotency key
    When Customer undo "1"th "Repayment" transaction made on "10 June 2023"
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023 |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0  |            |      |             |
      | 1  | 30   | 31 January 2023 |           | 0.0             | 1000.0        | 0.0      | 20.0 | 0.0       | 1020.0 | 0.0  | 0.0        | 0.0  | 1020.0      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 20   | 0         | 1020 | 0    | 0          | 0    | 1020        |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 01 June 2023     | Charge-off       | 1020.0 | 1000.0    | 0.0      | 20.0 | 0.0       | 0.0          |
      | 10 June 2023     | Repayment        | 1000.0 | 980.0     | 0.0      | 20.0 | 0.0       | 20.0         |
    Then On Loan Transactions tab the "Repayment" Transaction with date "10 June 2023" is reverted

  @TestRailId:C2765
  Scenario: Verify that charge-off is reversed/replayed if Goodwill credit transaction is placed on a date before the charge-off on business date after the charge-off
    When Admin sets the business date to "01 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "01 January 2023"
    And Admin successfully approves the loan on "01 January 2023" with "1000" amount and expected disbursement date on "01 January 2023"
    And Admin successfully disburse the loan on "01 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "25 January 2023"
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "25 January 2023" due date and 20 EUR transaction amount
    When Admin sets the business date to "01 June 2023"
    And Admin does charge-off the loan on "01 June 2023"
    When Admin sets the business date to "10 June 2023"
    When Admin makes "GOODWILL_CREDIT" transaction with "AUTOPAY" payment type on "29 January 2023" with 500 EUR transaction amount
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2023 |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0   |            |      |             |
      | 1  | 30   | 31 January 2023 |           | 0.0             | 1000.0        | 0.0      | 20.0 | 0.0       | 1020.0 | 500.0 | 500.0      | 0.0  | 520.0       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 20   | 0         | 1020 | 500  | 500        | 0    | 520         |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 29 January 2023  | Goodwill Credit  | 500.0  | 480.0     | 0.0      | 20.0 | 0.0       | 520.0        |
      | 01 June 2023     | Charge-off       | 520.0  | 520.0     | 0.0      | 0.0  | 0.0       | 0.0          |

  @TestRailId:C2766
  Scenario: As a user I want to do a undo Charge-off with reversal external Id
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "22 February 2023"
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name         | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable     |        | 1000.0 |
      | EXPENSE | 744007       | Credit Loss/Bad Debt | 1000.0 |        |
    When Admin sets the business date to "23 February 2023"
    And Admin does a charge-off undo the loan with reversal external Id
    Then Loan Charge-off undo event has reversed on date "23 February 2023" for charge-off undo

  @TestRailId:C2767
  Scenario: Verify that charge-off is reversed/replayed in case of partial payment, charge-off, second part of payment, reverse 1st payment
    When Admin sets the business date to "01 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "01 January 2023"
    And Admin successfully approves the loan on "01 January 2023" with "1000" amount and expected disbursement date on "01 January 2023"
    And Admin successfully disburse the loan on "01 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "10 February 2023"
    When Customer makes "REPAYMENT" transaction with "AUTOPAY" payment type on "10 February 2023" with 500 EUR transaction amount and system-generated Idempotency key
    When Admin sets the business date to "01 June 2023"
    And Admin does charge-off the loan on "01 June 2023"
    When Admin sets the business date to "05 June 2023"
    When Customer makes "REPAYMENT" transaction with "AUTOPAY" payment type on "05 June 2023" with 500 EUR transaction amount and system-generated Idempotency key
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date    | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid   | In advance | Late   | Outstanding |
      |    |      | 01 January 2023 |              | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0    |            |        |             |
      | 1  | 30   | 31 January 2023 | 05 June 2023 | 0.0             | 1000.0        | 0.0      | 0.0  | 0.0       | 1000.0 | 1000.0 | 0.0        | 1000.0 | 0.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 0    | 0         | 1000 | 1000 | 0          | 1000 | 0           |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 10 February 2023 | Repayment        | 500.0  | 500.0     | 0.0      | 0.0  | 0.0       | 500.0        |
      | 01 June 2023     | Charge-off       | 500.0  | 500.0     | 0.0      | 0.0  | 0.0       | 0.0          |
      | 05 June 2023     | Repayment        | 500.0  | 500.0     | 0.0      | 0.0  | 0.0       | 0.0          |
    When Admin sets the business date to "10 June 2023"
    When Customer undo "1"th "Repayment" transaction made on "10 February 2023"
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid  | In advance | Late  | Outstanding |
      |    |      | 01 January 2023 |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0   |            |       |             |
      | 1  | 30   | 31 January 2023 |           | 0.0             | 1000.0        | 0.0      | 0.0  | 0.0       | 1000.0 | 500.0 | 0.0        | 500.0 | 500.0       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 0    | 0         | 1000 | 500  | 0          | 500  | 500         |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 10 February 2023 | Repayment        | 500.0  | 500.0     | 0.0      | 0.0  | 0.0       | 500.0        |
      | 01 June 2023     | Charge-off       | 1000.0 | 1000.0    | 0.0      | 0.0  | 0.0       | 0.0          |
      | 05 June 2023     | Repayment        | 500.0  | 500.0     | 0.0      | 0.0  | 0.0       | 500.0        |
    Then On Loan Transactions tab the "Repayment" Transaction with date "10 February 2023" is reverted
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "REPAYMENT" transaction with date "10 February 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit | Credit |
      | ASSET     | 112601       | Loans Receivable          |       | 500.0  |
      | LIABILITY | 145023       | Suspense/Clearing account | 500.0 |        |
      | ASSET     | 112601       | Loans Receivable          | 500.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |       | 500.0  |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "01 June 2023" which has the following Journal entries:
      | Type    | Account code | Account name         | Debit  | Credit |
      | ASSET   | 112601       | Loans Receivable     |        | 1000.0 |
      | EXPENSE | 744007       | Credit Loss/Bad Debt | 1000.0 |        |
    Then Loan Transactions tab has a "REPAYMENT" transaction with date "05 June 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit | Credit |
      | INCOME    | 744008       | Recoveries                |       | 500.0  |
      | LIABILITY | 145023       | Suspense/Clearing account | 500.0 |        |

  @TestRailId:C2768
  Scenario: Verify that charge-off is results an error in case of partial payment, charge-off, fee added after charge-off
    When Admin sets the business date to "01 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "01 January 2023"
    And Admin successfully approves the loan on "01 January 2023" with "1000" amount and expected disbursement date on "01 January 2023"
    And Admin successfully disburse the loan on "01 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "10 February 2023"
    When Customer makes "REPAYMENT" transaction with "AUTOPAY" payment type on "10 February 2023" with 300 EUR transaction amount and system-generated Idempotency key
    When Admin sets the business date to "01 June 2023"
    And Admin does charge-off the loan on "01 June 2023"
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid  | In advance | Late  | Outstanding |
      |    |      | 01 January 2023 |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0   |            |       |             |
      | 1  | 30   | 31 January 2023 |           | 0.0             | 1000.0        | 0.0      | 0.0  | 0.0       | 1000.0 | 300.0 | 0.0        | 300.0 | 700.0       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 0    | 0         | 1000 | 300  | 0          | 300  | 700         |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 10 February 2023 | Repayment        | 300.0  | 300.0     | 0.0      | 0.0  | 0.0       | 700.0        |
      | 01 June 2023     | Charge-off       | 700.0  | 700.0     | 0.0      | 0.0  | 0.0       | 0.0          |
    When Admin sets the business date to "10 June 2023"
    Then Loan charge transaction with the following data results a 403 error and "CHARGED_OFF" error message
      | Charge type     | dueDate      | amount |
      | LOAN_SNOOZE_FEE | 10 June 2023 | 20     |

  @TestRailId:C2779
  Scenario: Verify that on interest bearing loans the accrual of interest is stopped when the loan is charged-off
    When Admin sets the business date to "01 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                   | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy                        |
      | LP1_INTEREST_DECLINING_BALANCE_PERIOD_DAILY | 01 January 2023   | 1000           | 12                     | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 1                 | MONTHS                | 1              | MONTHS                 | 1                  | 0                       | 0                      | 0                    | PENALTIES_FEES_INTEREST_PRINCIPAL_ORDER |
    And Admin successfully approves the loan on "01 January 2023" with "1000" amount and expected disbursement date on "01 January 2023"
    And Admin successfully disburse the loan on "01 January 2023" with "1000" EUR transaction amount
    When Admin runs inline COB job for Loan
    When Admin sets the business date to "02 January 2023"
    When Admin runs inline COB job for Loan
    When Admin sets the business date to "03 January 2023"
    When Admin runs inline COB job for Loan
    When Admin sets the business date to "04 January 2023"
    When Admin runs inline COB job for Loan
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 1000.0          |               |          | 0.0  |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 0.0             | 1000.0        | 10.19    | 0.0  | 0.0       | 1010.19 | 0.0  | 0.0        | 0.0  | 1010.19     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 1000          | 10.19    | 0    | 0         | 1010.19 | 0    | 0          | 0    | 1010.19     |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 02 January 2023  | Accrual          | 0.33   | 0.0       | 0.33     | 0.0  | 0.0       | 0.0          |
      | 03 January 2023  | Accrual          | 0.33   | 0.0       | 0.33     | 0.0  | 0.0       | 0.0          |
    When Admin sets the business date to "05 January 2023"
    And Admin does charge-off the loan on "05 January 2023"
    When Admin runs inline COB job for Loan
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 1000.0          |               |          | 0.0  |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 0.0             | 1000.0        | 10.19    | 0.0  | 0.0       | 1010.19 | 0.0  | 0.0        | 0.0  | 1010.19     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 1000          | 10.19    | 0    | 0         | 1010.19 | 0    | 0          | 0    | 1010.19     |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0  | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 02 January 2023  | Accrual          | 0.33    | 0.0       | 0.33     | 0.0  | 0.0       | 0.0          |
      | 03 January 2023  | Accrual          | 0.33    | 0.0       | 0.33     | 0.0  | 0.0       | 0.0          |
      | 05 January 2023  | Charge-off       | 1010.19 | 1000.0    | 10.19    | 0.0  | 0.0       | 0.0          |

  @TestRailId:C2780
  Scenario: Verify that on interest bearing loans the accrual of interest is resumed and aggregated when the charge-off is reverted
    When Admin sets the business date to "01 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                   | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy                        |
      | LP1_INTEREST_DECLINING_BALANCE_PERIOD_DAILY | 01 January 2023   | 1000           | 12                     | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 1                 | MONTHS                | 1              | MONTHS                 | 1                  | 0                       | 0                      | 0                    | PENALTIES_FEES_INTEREST_PRINCIPAL_ORDER |
    And Admin successfully approves the loan on "01 January 2023" with "1000" amount and expected disbursement date on "01 January 2023"
    And Admin successfully disburse the loan on "01 January 2023" with "1000" EUR transaction amount
    When Admin runs inline COB job for Loan
    When Admin sets the business date to "02 January 2023"
    When Admin runs inline COB job for Loan
    When Admin sets the business date to "03 January 2023"
    When Admin runs inline COB job for Loan
    When Admin sets the business date to "04 January 2023"
    And Admin does charge-off the loan on "04 January 2023"
    When Admin runs inline COB job for Loan
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 1000.0          |               |          | 0.0  |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 0.0             | 1000.0        | 10.19    | 0.0  | 0.0       | 1010.19 | 0.0  | 0.0        | 0.0  | 1010.19     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 1000          | 10.19    | 0    | 0         | 1010.19 | 0    | 0          | 0    | 1010.19     |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0  | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 02 January 2023  | Accrual          | 0.33    | 0.0       | 0.33     | 0.0  | 0.0       | 0.0          |
      | 04 January 2023  | Charge-off       | 1010.19 | 1000.0    | 10.19    | 0.0  | 0.0       | 0.0          |
    When Admin sets the business date to "05 January 2023"
    When Admin runs inline COB job for Loan
    When Admin sets the business date to "06 January 2023"
    When Admin runs inline COB job for Loan
    When Admin sets the business date to "07 January 2023"
    Then Admin does a charge-off undo the loan
    When Admin runs inline COB job for Loan
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 1000.0          |               |          | 0.0  |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 0.0             | 1000.0        | 10.19    | 0.0  | 0.0       | 1010.19 | 0.0  | 0.0        | 0.0  | 1010.19     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 1000          | 10.19    | 0    | 0         | 1010.19 | 0    | 0          | 0    | 1010.19     |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0  | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 02 January 2023  | Accrual          | 0.33    | 0.0       | 0.33     | 0.0  | 0.0       | 0.0          |
      | 04 January 2023  | Charge-off       | 1010.19 | 1000.0    | 10.19    | 0.0  | 0.0       | 0.0          |
      | 06 January 2023  | Accrual          | 1.31    | 0.0       | 1.31     | 0.0  | 0.0       | 0.0          |
    Then On Loan Transactions tab the "Charge-off" Transaction with date "04 January 2023" is reverted

  @TestRailId:C2781
  Scenario: Verify that on interest bearing loans the accrual of interest is stopped when the loan is charged-off even if fully paid after the charge-off
    When Admin sets the business date to "01 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                   | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy                        |
      | LP1_INTEREST_DECLINING_BALANCE_PERIOD_DAILY | 01 January 2023   | 1000           | 12                     | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 1                 | MONTHS                | 1              | MONTHS                 | 1                  | 0                       | 0                      | 0                    | PENALTIES_FEES_INTEREST_PRINCIPAL_ORDER |
    And Admin successfully approves the loan on "01 January 2023" with "1000" amount and expected disbursement date on "01 January 2023"
    And Admin successfully disburse the loan on "01 January 2023" with "1000" EUR transaction amount
    When Admin runs inline COB job for Loan
    When Admin sets the business date to "02 January 2023"
    When Admin runs inline COB job for Loan
    When Admin sets the business date to "03 January 2023"
    When Admin runs inline COB job for Loan
    When Admin sets the business date to "04 January 2023"
    And Admin does charge-off the loan on "04 January 2023"
    When Admin runs inline COB job for Loan
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 1000.0          |               |          | 0.0  |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 0.0             | 1000.0        | 10.19    | 0.0  | 0.0       | 1010.19 | 0.0  | 0.0        | 0.0  | 1010.19     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 1000          | 10.19    | 0    | 0         | 1010.19 | 0    | 0          | 0    | 1010.19     |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0  | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 02 January 2023  | Accrual          | 0.33    | 0.0       | 0.33     | 0.0  | 0.0       | 0.0          |
      | 04 January 2023  | Charge-off       | 1010.19 | 1000.0    | 10.19    | 0.0  | 0.0       | 0.0          |
    When Admin sets the business date to "05 January 2023"
    When Admin runs inline COB job for Loan
    When Admin sets the business date to "06 January 2023"
    When Customer makes "REPAYMENT" transaction with "AUTOPAY" payment type on "06 January 2023" with 1010.19 EUR transaction amount and system-generated Idempotency key
    When Admin runs inline COB job for Loan
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date       | Balance of loan | Principal due | Interest | Fees | Penalties | Due     | Paid    | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |                 | 1000.0          |               |          | 0.0  |           | 0.0     | 0.0     |            |      |             |
      | 1  | 31   | 01 February 2023 | 06 January 2023 | 0.0             | 1000.0        | 10.19    | 0.0  | 0.0       | 1010.19 | 1010.19 | 1010.19    | 0.0  | 0.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid    | In advance | Late | Outstanding |
      | 1000          | 10.19    | 0    | 0         | 1010.19 | 1010.19 | 1010.19    | 0    | 0.0         |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0  | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 02 January 2023  | Accrual          | 0.33    | 0.0       | 0.33     | 0.0  | 0.0       | 0.0          |
      | 04 January 2023  | Charge-off       | 1010.19 | 1000.0    | 10.19    | 0.0  | 0.0       | 0.0          |
      | 06 January 2023  | Repayment        | 1010.19 | 1000.0    | 10.19    | 0.0  | 0.0       | 0.0          |

  @TestRailId:C2782
  Scenario: Verify that the accrual of charges is not happened when the loan is charged-off on charge's due date but resumed when the charge-off is reverted
    When Admin sets the business date to "01 January 2023"
    And Admin creates a client with random data
    When Admin creates a new default Loan with date: "01 January 2023"
    And Admin successfully approves the loan on "01 January 2023" with "1000" amount and expected disbursement date on "01 January 2023"
    And Admin successfully disburse the loan on "01 January 2023" with "1000" EUR transaction amount
    When Admin runs inline COB job for Loan
    When Admin sets the business date to "02 January 2023"
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "02 January 2023" due date and 10 EUR transaction amount
    When Admin runs inline COB job for Loan
    When Admin sets the business date to "03 January 2023"
    When Admin runs inline COB job for Loan
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023 |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0  |            |      |             |
      | 1  | 30   | 31 January 2023 |           | 0.0             | 1000.0        | 0.0      | 10.0 | 0.0       | 1010.0 | 0.0  | 0.0        | 0.0  | 1010.0      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due    | Paid | In advance | Late | Outstanding |
      | 1000          | 0.0      | 10   | 0         | 1010.0 | 0    | 0          | 0    | 1010.0      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 02 January 2023  | Accrual          | 10.0   | 0.0       | 0.0      | 10.0 | 0.0       | 0.0          |
    When Admin sets the business date to "04 January 2023"
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "04 January 2023" due date and 15 EUR transaction amount
    And Admin does charge-off the loan on "04 January 2023"
    When Admin runs inline COB job for Loan
    When Admin sets the business date to "05 January 2023"
    When Admin runs inline COB job for Loan
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023 |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0  |            |      |             |
      | 1  | 30   | 31 January 2023 |           | 0.0             | 1000.0        | 0.0      | 25.0 | 0.0       | 1025.0 | 0.0  | 0.0        | 0.0  | 1025.0      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due    | Paid | In advance | Late | Outstanding |
      | 1000          | 0.0      | 25   | 0         | 1025.0 | 0    | 0          | 0    | 1025.0      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 02 January 2023  | Accrual          | 10.0   | 0.0       | 0.0      | 10.0 | 0.0       | 0.0          |
      | 04 January 2023  | Charge-off       | 1025.0 | 1000.0    | 0.0      | 25.0 | 0.0       | 0.0          |
    When Admin sets the business date to "06 January 2023"
    When Admin runs inline COB job for Loan
    When Admin sets the business date to "07 January 2023"
    Then Admin does a charge-off undo the loan
    When Admin runs inline COB job for Loan
    Then Loan Repayment schedule has 1 periods, with the following data for periods:
      | Nr | Days | Date            | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023 |           | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0  |            |      |             |
      | 1  | 30   | 31 January 2023 |           | 0.0             | 1000.0        | 0.0      | 25.0 | 0.0       | 1025.0 | 0.0  | 0.0        | 0.0  | 1025.0      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due    | Paid | In advance | Late | Outstanding |
      | 1000          | 0.0      | 25   | 0         | 1025.0 | 0    | 0          | 0    | 1025.0      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 02 January 2023  | Accrual          | 10.0   | 0.0       | 0.0      | 10.0 | 0.0       | 0.0          |
      | 04 January 2023  | Charge-off       | 1025.0 | 1000.0    | 0.0      | 25.0 | 0.0       | 0.0          |
      | 06 January 2023  | Accrual          | 15.0   | 0.0       | 0.0      | 15.0 | 0.0       | 0.0          |
    Then On Loan Transactions tab the "Charge-off" Transaction with date "04 January 2023" is reverted

  @TestRailId:C2891 @AdvancedPaymentAllocation
  Scenario: Verify that the user is able to do a Charge-off for fraud loan when FEE and PENALTY added - LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION product
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                       | submitted on date | with Principal | ANNUAL interest rate % | interest type | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION | 01 January 2023   | 1000           | 0                      | FLAT          | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 45                | DAYS                  | 15             | DAYS                   | 3                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    And Admin adds an NSF fee because of payment bounce with "1 January 2023" transaction date
    When Admin sets the business date to "22 February 2023"
    And Admin adds a 10 % Processing charge to the loan with "en" locale on date: "22 February 2023"
    Then Admin can successfully set Fraud flag to the loan
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name               | Debit | Credit |
      | ASSET   | 112601       | Loans Receivable           |       | 750.0  |
      | ASSET   | 112603       | Interest/Fee Receivable    |       | 110.0  |
      | EXPENSE | 744037       | Credit Loss/Bad Debt-Fraud | 750.0 |        |
      | INCOME  | 404008       | Fee Charge Off             | 110.0 |        |

  @TestRailId:C2892 @AdvancedPaymentAllocation
  Scenario: Verify that the user is able to do a Charge-off for non-fraud loan after disbursement - LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION product
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                       | submitted on date | with Principal | ANNUAL interest rate % | interest type | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION | 01 January 2023   | 1000           | 0                      | FLAT          | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 45                | DAYS                  | 15             | DAYS                   | 3                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "22 February 2023"
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name         | Debit | Credit |
      | ASSET   | 112601       | Loans Receivable     |       | 750.0  |
      | EXPENSE | 744007       | Credit Loss/Bad Debt | 750.0 |        |

  @TestRailId:C2893 @AdvancedPaymentAllocation
  Scenario: Verify that the user is able to do a Charge-off for non-fraud loan after repayment - LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION product
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                       | submitted on date | with Principal | ANNUAL interest rate % | interest type | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION | 01 January 2023   | 1000           | 0                      | FLAT          | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 45                | DAYS                  | 15             | DAYS                   | 3                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "5 January 2023"
    And Customer makes "AUTOPAY" repayment on "5 January 2023" with 250 EUR transaction amount
    When Admin sets the business date to "22 February 2023"
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    Then Loan status will be "ACTIVE"
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "REPAYMENT" transaction with date "05 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit | Credit |
      | ASSET     | 112601       | Loans Receivable          |       | 250.0  |
      | LIABILITY | 145023       | Suspense/Clearing account | 250.0 |        |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name         | Debit | Credit |
      | ASSET   | 112601       | Loans Receivable     |       | 500.0  |
      | EXPENSE | 744007       | Credit Loss/Bad Debt | 500.0 |        |

  @TestRailId:C2894 @AdvancedPaymentAllocation
  Scenario: Verify that the user is able to do a Repayment undo after Charge-off for non-fraud - LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION product
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                       | submitted on date | with Principal | ANNUAL interest rate % | interest type | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION | 01 January 2023   | 1000           | 0                      | FLAT          | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 45                | DAYS                  | 15             | DAYS                   | 3                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "5 January 2023"
    And Customer makes "AUTOPAY" repayment on "5 January 2023" with 250 EUR transaction amount
    When Admin sets the business date to "22 February 2023"
    And Admin does charge-off the loan on "22 February 2023"
    Then Loan marked as charged-off on "22 February 2023"
    When Customer undo "1"th repayment on "05 January 2023"
    Then Loan status will be "ACTIVE"
    Then On Loan Transactions tab the "Repayment" Transaction with date "05 January 2023" is reverted
    Then Loan Transactions tab has a "DISBURSEMENT" transaction with date "01 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit  | Credit |
      | ASSET     | 112601       | Loans Receivable          | 1000.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |        | 1000.0 |
    Then Loan Transactions tab has a "REPAYMENT" transaction with date "05 January 2023" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit | Credit |
      | ASSET     | 112601       | Loans Receivable          |       | 250.0  |
      | LIABILITY | 145023       | Suspense/Clearing account | 250.0 |        |
      | ASSET     | 112601       | Loans Receivable          | 250.0 |        |
      | LIABILITY | 145023       | Suspense/Clearing account |       | 250.0  |
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "22 February 2023" which has the following Journal entries:
      | Type    | Account code | Account name         | Debit | Credit |
      | ASSET   | 112601       | Loans Receivable     |       | 750.0  |
      | EXPENSE | 744007       | Credit Loss/Bad Debt | 750.0 |        |

  @TestRailId:C2895 @AdvancedPaymentAllocation
  Scenario: Verify that the user is able to do a backdated Charge-off when only disbursement transaction happened - LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION product
    When Admin sets the business date to "1 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                       | submitted on date | with Principal | ANNUAL interest rate % | interest type | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION | 01 January 2023   | 1000           | 0                      | FLAT          | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 45                | DAYS                  | 15             | DAYS                   | 3                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "1 January 2023" with "1000" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "22 February 2023"
    And Admin does charge-off the loan on "10 February 2023"
    Then Loan Repayment schedule has 4 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date       | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |                 | 1000.0          |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 0    | 01 January 2023  | 01 January 2023 | 750.0           | 250.0         | 0.0      | 0.0  | 0.0       | 250.0 | 250.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 15   | 16 January 2023  |                 | 500.0           | 250.0         | 0.0      | 0.0  | 0.0       | 250.0 | 0.0   | 0.0        | 0.0  | 250.0       |
      | 3  | 15   | 31 January 2023  |                 | 250.0           | 250.0         | 0.0      | 0.0  | 0.0       | 250.0 | 0.0   | 0.0        | 0.0  | 250.0       |
      | 4  | 15   | 15 February 2023 |                 | 0.0             | 250.0         | 0.0      | 0.0  | 0.0       | 250.0 | 0.0   | 0.0        | 0.0  | 250.0       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 0    | 0         | 1000 | 250  | 0          | 0    | 750         |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 01 January 2023  | Down Payment     | 250.0  | 250.0     | 0.0      | 0.0  | 0.0       | 750.0        |
      | 10 February 2023 | Charge-off       | 750.0  | 750.0     | 0.0      | 0.0  | 0.0       | 0.0          |

  @TestRailId:C2896 @AdvancedPaymentAllocation
  Scenario: Verify that charge-off is reversed/replayed if Goodwill credit transaction is placed on a date before the charge-off on business date after the charge-off - - LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION product
    When Admin sets the business date to "01 January 2023"
    And Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                       | submitted on date | with Principal | ANNUAL interest rate % | interest type | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION | 01 January 2023   | 1000           | 0                      | FLAT          | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 45                | DAYS                  | 15             | DAYS                   | 3                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 January 2023" with "1000" amount and expected disbursement date on "01 January 2023"
    And Admin successfully disburse the loan on "01 January 2023" with "1000" EUR transaction amount
    When Admin sets the business date to "25 January 2023"
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "25 January 2023" due date and 20 EUR transaction amount
    When Admin sets the business date to "01 June 2023"
    And Admin does charge-off the loan on "01 June 2023"
    When Admin sets the business date to "10 June 2023"
    When Admin makes "GOODWILL_CREDIT" transaction with "AUTOPAY" payment type on "29 January 2023" with 500 EUR transaction amount
    Then Loan Repayment schedule has 4 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date       | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late  | Outstanding |
      |    |      | 01 January 2023  |                 | 1000.0          |               |          | 0.0  |           | 0.0   | 0.0   |            |       |             |
      | 1  | 0    | 01 January 2023  | 01 January 2023 | 750.0           | 250.0         | 0.0      | 0.0  | 0.0       | 250.0 | 250.0 | 0.0        | 0.0   | 0.0         |
      | 2  | 15   | 16 January 2023  | 29 January 2023 | 500.0           | 250.0         | 0.0      | 0.0  | 0.0       | 250.0 | 250.0 | 0.0        | 250.0 | 0.0         |
      | 3  | 15   | 31 January 2023  |                 | 250.0           | 250.0         | 0.0      | 20.0 | 0.0       | 270.0 | 0.0   | 0.0        | 0.0   | 270.0       |
      | 4  | 15   | 15 February 2023 | 29 January 2023 | 0.0             | 250.0         | 0.0      | 0.0  | 0.0       | 250.0 | 250.0 | 250.0      | 0.0   | 0.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due  | Paid | In advance | Late | Outstanding |
      | 1000          | 0        | 20   | 0         | 1020 | 750  | 250        | 250  | 270         |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 1000.0 | 0.0       | 0.0      | 0.0  | 0.0       | 1000.0       |
      | 01 January 2023  | Down Payment     | 250.0  | 250.0     | 0.0      | 0.0  | 0.0       | 750.0        |
      | 29 January 2023  | Goodwill Credit  | 500.0  | 500.0     | 0.0      | 0.0  | 0.0       | 250.0        |
      | 01 June 2023     | Charge-off       | 270.0  | 250.0     | 0.0      | 20.0 | 0.0       | 0.0          |

  @TestRailId:C3067 @AdvancedPaymentAllocation
  Scenario: Verify charge-off GL entries in case of reverse-replay on fraud loan
    When Admin sets the business date to "01 February 2024"
    When Admin creates a client with random data
    When Admin set "LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION" loan product "DEFAULT" transaction type to "NEXT_INSTALLMENT" future installment allocation rule
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                       | submitted on date | with Principal | ANNUAL interest rate % | interest type | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_DOWNPAYMENT_AUTO_ADVANCED_PAYMENT_ALLOCATION | 01 February 2024  | 1000           | 0                      | FLAT          | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 45                | DAYS                  | 15             | DAYS                   | 3                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 February 2024" with "1000" amount and expected disbursement date on "01 February 2024"
    When Admin successfully disburse the loan on "01 February 2024" with "1000" EUR transaction amount
    When Admin sets the business date to "02 February 2024"
    And Customer makes "AUTOPAY" repayment on "02 February 2024" with 100 EUR transaction amount
    When Admin sets the business date to "03 February 2024"
    Then Admin can successfully set Fraud flag to the loan
    When Admin sets the business date to "03 February 2024"
    And Admin does charge-off the loan on "03 February 2024"
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "03 February 2024" which has the following Journal entries:
      | Type    | Account code | Account name               | Debit | Credit |
      | ASSET   | 112601       | Loans Receivable           |       | 650.0  |
      | EXPENSE | 744037       | Credit Loss/Bad Debt-Fraud | 650.0 |        |
    When Admin sets the business date to "04 February 2024"
    When Customer undo "1"th "Repayment" transaction made on "02 February 2024"
    Then Loan Transactions tab has a "CHARGE_OFF" transaction with date "03 February 2024" which has the following Journal entries:
      | Type      | Account code | Account name              | Debit | Credit |
      | ASSET   | 112601       | Loans Receivable           |       | 750.0  |
      | EXPENSE | 744037       | Credit Loss/Bad Debt-Fraud | 750.0 |        |
    Then In Loan transactions the replayed "CHARGE_OFF" transaction with date "03 February 2024" has a reverted transaction pair with the following Journal entries:
      | Type    | Account code | Account name               | Debit | Credit |
      | ASSET   | 112601       | Loans Receivable           |       | 650.0  |
      | EXPENSE | 744037       | Credit Loss/Bad Debt-Fraud | 650.0 |        |
      | ASSET   | 112601       | Loans Receivable           | 650.0 |        |
      | EXPENSE | 744037       | Credit Loss/Bad Debt-Fraud |       | 650.0  |

  @TestRailId:C3326 @AdvancedPaymentAllocation
  Scenario: Verify the repayment schedule is updated before the Charge-off in case of interest recalculation = true
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                                                                     | submitted on date | with Principal | ANNUAL interest rate % | interest type           | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_EMI_360_30_INTEREST_RECALCULATION_DAILY_TILL_PRECLOSE_PMT_ALLOC_1  | 01 January 2024   | 1000           | 7                      | DECLINING_BALANCE       | DAILY                       | EQUAL_INSTALLMENTS | 3                 | MONTHS                | 1              | MONTHS                 | 3                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 January 2024" with "1000" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "1000" EUR transaction amount
    When Admin runs inline COB job for Loan
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date       | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid  | In advance | Late  | Outstanding |
      |    |      | 01 January 2024  |                 | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0   |            |       |             |
      | 1  | 31   | 01 February 2024 |                 | 668.6           | 331.4         | 5.83     | 0.0  | 0.0       | 337.23 | 0.0   | 0.0        | 0.0   | 337.23      |
      | 2  | 29   | 01 March 2024    |                 | 335.27          | 333.33        | 3.9      | 0.0  | 0.0       | 337.23 | 0.0   | 0.0        | 0.0   | 337.23      |
      | 3  | 31   | 01 April 2024    |                 | 0.0             | 335.27        | 1.96     | 0.0  | 0.0       | 337.23 | 0.0   | 0.0        | 0.0   | 337.23      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 1000          | 11.69    | 0    | 0         | 1011.69 | 0    | 0          | 0    | 1011.69     |
    When Admin sets the business date to "15 February 2024"
    When Admin runs inline COB job for Loan
    # Move the current date into the middle of the 2nd period, so 1st period is past due
    When Admin sets the business date to "15 August 2024"
    And Admin does charge-off the loan on "09 February 2024"
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date       | Balance of loan | Principal due | Interest | Fees | Penalties | Due    | Paid  | In advance | Late  | Outstanding |
      |    |      | 01 January 2024  |                 | 1000.0          |               |          | 0.0  |           | 0.0    | 0.0   |            |       |             |
      | 1  | 31   | 01 February 2024 |                 | 668.6           | 331.4         | 5.83     | 0.0  | 0.0       | 337.23 | 0.0   | 0.0        | 0.0   | 337.23      |
      | 2  | 29   | 01 March 2024    |                 | 335.8           | 332.8         | 4.43     | 0.0  | 0.0       | 337.23 | 0.0   | 0.0        | 0.0   | 337.23      |
      | 3  | 31   | 01 April 2024    |                 | 0.0             | 335.8         | 1.96     | 0.0  | 0.0       | 337.76 | 0.0   | 0.0        | 0.0   | 337.76      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 1000          | 12.22    | 0    | 0         | 1012.22 | 0    | 0          | 0    | 1012.22     |

  Scenario: Charge-off on due date when loan behaviour is zero-interest and interestRecalculation = true
    When Admin sets the business date to "1 March 2023"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan with interest recalculation and date: "1 January 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2023 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 28   | 01 March 2023    |           | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2023    |           | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2023      |           | 33.71           | 16.72	       | 0.29     | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 5  | 31   | 01 June 2023     |           | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0 	| 0.0  | 0.0        | 0.0  | 17.0 	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.05     | 0    | 0         | 102.05  | 0    | 0          | 0    | 102.05      |
    And Admin successfully approves the loan on "1 January 2023" with "100" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "100" EUR transaction amount
    And Admin does charge-off the loan on "1 March 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 28   | 01 March 2023    |           | 67.14           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2023    |           | 50.13           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2023      |           | 33.12           | 17.01	       | 0.0      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 5  | 31   | 01 June 2023     |           | 16.11           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.11         | 0.0      | 0.0   | 0.0       | 16.11	| 0.0  | 0.0        | 0.0  | 16.11	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 1.16     | 0    | 0         | 101.16  | 0    | 0          | 0    | 101.16      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        |
      | 01 March 2023    | Charge-off       | 101.16  | 100.0     | 1.16     | 0.0   | 0.0       | 0.0          |

  Scenario: Charge-off after installment date when loan behaviour is zero-interest and interestRecalculation = true
    When Admin sets the business date to "1 March 2023"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan with interest recalculation and date: "1 January 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2023 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 28   | 01 March 2023    |           | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2023    |           | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2023      |           | 33.71           | 16.72	       | 0.29     | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 5  | 31   | 01 June 2023     |           | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0 	| 0.0  | 0.0        | 0.0  | 17.0 	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.05     | 0    | 0         | 102.05  | 0    | 0          | 0    | 102.05      |
    And Admin successfully approves the loan on "1 January 2023" with "100" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "100" EUR transaction amount
    And Admin does charge-off the loan on "28 February 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 28   | 01 March 2023    |           | 67.12           | 16.45         | 0.56     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2023    |           | 50.11           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2023      |           | 33.1            | 17.01	       | 0.0      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 5  | 31   | 01 June 2023     |           | 16.09           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.09         | 0.0      | 0.0   | 0.0       | 16.09	| 0.0  | 0.0        | 0.0  | 16.09	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 1.14     | 0    | 0         | 101.14  | 0    | 0          | 0    | 101.14      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        |
      | 28 February 2023 | Charge-off       | 101.14  | 100.0     | 1.14     | 0.0   | 0.0       | 0.0          |

  Scenario: Charge-off in the middle of installment period when loan behaviour is zero-interest and interestRecalculation = true
    When Admin sets the business date to "1 March 2023"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan with interest recalculation and date: "1 January 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2023 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 28   | 01 March 2023    |           | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2023    |           | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2023      |           | 33.71           | 16.72	       | 0.29     | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 5  | 31   | 01 June 2023     |           | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0 	| 0.0  | 0.0        | 0.0  | 17.0 	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.05     | 0    | 0         | 102.05  | 0    | 0          | 0    | 102.05      |
    And Admin successfully approves the loan on "1 January 2023" with "100" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "100" EUR transaction amount
    And Admin does charge-off the loan on "14 February 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 28   | 01 March 2023    |           | 66.83           | 16.74         | 0.27     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2023    |           | 49.82           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2023      |           | 32.81           | 17.01	       | 0.0      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 5  | 31   | 01 June 2023     |           | 15.8            | 17.01         | 0.0      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 15.8          | 0.0      | 0.0   | 0.0       | 15.8	| 0.0  | 0.0        | 0.0  | 15.8	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 0.85     | 0    | 0         | 100.85  | 0    | 0          | 0    | 100.85      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        |
      | 14 February 2023 | Charge-off       | 100.85  | 100.0     | 0.85     | 0.0   | 0.0       | 0.0          |

  Scenario: Charge-off after maturity date when loan behaviour is zero-interest and interestRecalculation = true
    When Admin sets the business date to "1 August 2023"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan with interest recalculation and date: "1 January 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2023 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 28   | 01 March 2023    |           | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2023    |           | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2023      |           | 33.71           | 16.72	       | 0.29     | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 5  | 31   | 01 June 2023     |           | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0 	| 0.0  | 0.0        | 0.0  | 17.0 	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.05     | 0    | 0         | 102.05  | 0    | 0          | 0    | 102.05      |
    And Admin successfully approves the loan on "1 January 2023" with "100" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "100" EUR transaction amount
    And Admin does charge-off the loan on "15 July 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 28   | 01 March 2023    |           | 67.14           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2023    |           | 50.71           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2023      |           | 34.28           | 16.43	       | 0.58     | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 5  | 31   | 01 June 2023     |           | 17.85           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 17.85         | 0.58     | 0.0   | 0.0       | 18.43	| 0.0  | 0.0        | 0.0  | 18.43	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 3.48     | 0    | 0         | 103.48  | 0    | 0          | 0    | 103.48      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        |
      | 15 July 2023     | Charge-off       | 103.48  | 100.0     | 3.48     | 0.0   | 0.0       | 0.0          |

  Scenario: Charge-off when charge is added before the charge-off date, loan behaviour is zero-interest and interestRecalculation = true
    When Admin sets the business date to "1 March 2023"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan with interest recalculation and date: "1 January 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2023 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 28   | 01 March 2023    |           | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2023    |           | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2023      |           | 33.71           | 16.72	       | 0.29     | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 5  | 31   | 01 June 2023     |           | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0 	| 0.0  | 0.0        | 0.0  | 17.0 	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.05     | 0    | 0         | 102.05  | 0    | 0          | 0    | 102.05      |
    And Admin successfully approves the loan on "1 January 2023" with "100" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "100" EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "27 February 2023" due date and 3 EUR transaction amount
    And Admin does charge-off the loan on "28 February 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 28   | 01 March 2023    |           | 67.12           | 16.45         | 0.56     | 3.0   | 0.0       | 20.01   | 0.0  | 0.0        | 0.0  | 20.01       |
      | 3  | 31   | 01 April 2023    |           | 50.11           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2023      |           | 33.1            | 17.01	       | 0.0      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 5  | 31   | 01 June 2023     |           | 16.09           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.09         | 0.0      | 0.0   | 0.0       | 16.09	| 0.0  | 0.0        | 0.0  | 16.09	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 1.14     | 3.0  | 0         | 104.14  | 0    | 0          | 0    | 104.14      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        |
      | 28 February 2023 | Charge-off       | 104.14  | 100.0     | 1.14     | 3.0   | 0.0       | 0.0          |

  Scenario: Charge-off when charge is added on charge-off date, loan behaviour is zero-interest and interestRecalculation = true
    When Admin sets the business date to "1 March 2023"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan with interest recalculation and date: "1 January 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2023 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 28   | 01 March 2023    |           | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2023    |           | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2023      |           | 33.71           | 16.72	       | 0.29     | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 5  | 31   | 01 June 2023     |           | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0 	| 0.0  | 0.0        | 0.0  | 17.0 	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.05     | 0    | 0         | 102.05  | 0    | 0          | 0    | 102.05      |
    And Admin successfully approves the loan on "1 January 2023" with "100" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "100" EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "28 February 2023" due date and 3 EUR transaction amount
    And Admin does charge-off the loan on "28 February 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 28   | 01 March 2023    |           | 67.12           | 16.45         | 0.56     | 3.0   | 0.0       | 20.01   | 0.0  | 0.0        | 0.0  | 20.01       |
      | 3  | 31   | 01 April 2023    |           | 50.11           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2023      |           | 33.1            | 17.01	       | 0.0      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 5  | 31   | 01 June 2023     |           | 16.09           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.09         | 0.0      | 0.0   | 0.0       | 16.09	| 0.0  | 0.0        | 0.0  | 16.09	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 1.14     | 3.0  | 0         | 104.14  | 0    | 0          | 0    | 104.14      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        |
      | 28 February 2023 | Charge-off       | 104.14  | 100.0     | 1.14     | 3.0   | 0.0       | 0.0          |

  Scenario: Charge-off when charge is added after the charge off date, loan behaviour is zero-interest and interestRecalculation = true
    When Admin sets the business date to "1 March 2023"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan with interest recalculation and date: "1 January 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2023 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 28   | 01 March 2023    |           | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2023    |           | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2023      |           | 33.71           | 16.72	       | 0.29     | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 5  | 31   | 01 June 2023     |           | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0 	| 0.0  | 0.0        | 0.0  | 17.0 	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.05     | 0    | 0         | 102.05  | 0    | 0          | 0    | 102.05      |
    And Admin successfully approves the loan on "1 January 2023" with "100" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "100" EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "1 March 2023" due date and 3 EUR transaction amount
    And Admin does charge-off the loan on "28 February 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 28   | 01 March 2023    |           | 67.12           | 16.45         | 0.56     | 3.0   | 0.0       | 20.01   | 0.0  | 0.0        | 0.0  | 20.01       |
      | 3  | 31   | 01 April 2023    |           | 50.11           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2023      |           | 33.1            | 17.01	       | 0.0      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 5  | 31   | 01 June 2023     |           | 16.09           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.09         | 0.0      | 0.0   | 0.0       | 16.09	| 0.0  | 0.0        | 0.0  | 16.09	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 1.14     | 3.0  | 0         | 104.14  | 0    | 0          | 0    | 104.14      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        |
      | 28 February 2023 | Charge-off       | 101.14  | 100.0     | 1.14     | 0.0   | 0.0       | 0.0          |

  Scenario: Undo the charge-off when loan behaviour is zero-interest and interestRecalculation = true
    When Admin sets the business date to "1 March 2023"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan with interest recalculation and date: "1 January 2023"
    And Admin successfully approves the loan on "1 January 2023" with "100" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 28   | 01 March 2023    |           | 67.14           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2023    |           | 50.52           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2023      |           | 33.8            | 16.72	       | 0.29     | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 5  | 31   | 01 June 2023     |           | 16.99           | 16.81         | 0.2      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.99         | 0.1      | 0.0   | 0.0       | 17.09	| 0.0  | 0.0        | 0.0  | 17.09	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.14     | 0    | 0         | 102.14  | 0    | 0          | 0    | 102.14      |
    And Admin does charge-off the loan on "14 February 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 28   | 01 March 2023    |           | 66.83           | 16.74         | 0.27     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2023    |           | 49.82           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2023      |           | 32.81           | 17.01	       | 0.0      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 5  | 31   | 01 June 2023     |           | 15.8            | 17.01         | 0.0      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 15.8          | 0.0      | 0.0   | 0.0       | 15.8	| 0.0  | 0.0        | 0.0  | 15.8	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 0.85     | 0    | 0         | 100.85  | 0    | 0          | 0    | 100.85      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        |
      | 14 February 2023 | Charge-off       | 100.85  | 100.0     | 0.85     | 0.0   | 0.0       | 0.0          |
    And Admin does a charge-off undo the loan
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 28   | 01 March 2023    |           | 67.14           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2023    |           | 50.52           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2023      |           | 33.8            | 16.72	       | 0.29     | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 5  | 31   | 01 June 2023     |           | 16.99           | 16.81         | 0.2      | 0.0   | 0.0       | 17.01	| 0.0  | 0.0        | 0.0  | 17.01	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.99         | 0.1      | 0.0   | 0.0       | 17.09	| 0.0  | 0.0        | 0.0  | 17.09	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.14     | 0    | 0         | 102.14  | 0    | 0          | 0    | 102.14      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        |
      | 14 February 2023 | Charge-off       | 100.85  | 100.0     | 0.85     | 0.0   | 0.0       | 0.0          |

  Scenario: Charge-off on due date when loan behaviour is zero-interest and interestRecalculation = true - repayment after charge off
    When Admin sets the business date to "1 January 2024"
    And Admin creates a client with random data
    And Admin creates a fully customized loan with the following data:
      | LoanProduct                                                                            | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.05     | 0    | 0         | 102.05  | 0    | 0          | 0    | 102.05      |
    And Admin successfully approves the loan on "1 January 2024" with "100" amount and expected disbursement date on "1 January 2024"
    And Admin successfully disburse the loan on "1 January 2024" with "100" EUR transaction amount
    When Admin sets the business date to "1 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0    | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.05     | 0    | 0         | 102.05  | 17.01| 0          | 0    | 85.04       |
    When Admin sets the business date to "29 February 2024"
    And Admin does charge-off the loan on "29 February 2024"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.03           | 16.54         | 0.47     | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.02           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.01           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.0            | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.0          | 0.0      | 0.0   | 0.0       | 16.0    | 0.0   | 0.0        | 0.0  | 16.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100           | 1.05     | 0    | 0         | 101.05  | 17.01 | 0          | 0    | 84.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01   | 16.43     | 0.58     | 0.0   | 0.0       | 83.57        | false    | false    |
      | 29 February 2024 | Charge-off       | 84.04   | 83.57     | 0.47     | 0.0   | 0.0       | 0.0          | false    | false    |
#  ----- repayment after charge off on 1st March  ----- #
    When Admin sets the business date to "01 March 2024"
    And Customer makes "AUTOPAY" repayment on "01 March 2024" with 17.01 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    | 01 March 2024    | 67.03           | 16.54         | 0.47     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 3  | 31   | 01 April 2024    |                  | 50.02           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.01           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.0            | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.0          | 0.0      | 0.0   | 0.0       | 16.0    | 0.0   | 0.0        | 0.0  | 16.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100           | 1.05     | 0    | 0         | 101.05  | 34.02 | 0          | 0    | 67.03       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01   | 16.43     | 0.58     | 0.0   | 0.0       | 83.57        | false    | false    |
      | 29 February 2024 | Charge-off       | 84.04   | 83.57     | 0.47     | 0.0   | 0.0       | 0.0          | false    | false    |
      | 01 March 2024    | Repayment        | 17.01   | 16.54     | 0.47     | 0.0   | 0.0       | 67.03        | false    | false    |

  @PS-2137-s5
  Scenario: Charge-off on due date when loan behaviour is zero-interest and interestRecalculation = true - charge off after one installment is overdue (31st March)
    When Admin sets the business date to "1 January 2024"
    And Admin creates a client with random data
    And Admin creates a fully customized loan with the following data:
      | LoanProduct                                                                            | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0   |           | 0.0   |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0   | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.05     | 0    | 0         | 102.05  | 0    | 0          | 0    | 102.05      |
    And Admin successfully approves the loan on "1 January 2024" with "100" amount and expected disbursement date on "1 January 2024"
    And Admin successfully disburse the loan on "1 January 2024" with "100" EUR transaction amount
    When Admin sets the business date to "1 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0    | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.05     | 0    | 0         | 102.05  | 17.01| 0          | 0    | 85.04       |
    When Admin sets the business date to "31 March 2024"
    And Admin does charge-off the loan on "31 March 2024"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.51           | 16.54         | 0.47     | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.5            | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.49           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.49         | 0.0      | 0.0   | 0.0       | 16.49   | 0.0   | 0.0        | 0.0  | 16.49       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100           | 1.54     | 0    | 0         | 101.54  | 17.01 | 0          | 0    | 84.53      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01   | 16.43     | 0.58     | 0.0   | 0.0       | 83.57        | false    | false    |
      | 31 March 2024    | Charge-off       | 84.53   | 83.57     | 0.96     | 0.0   | 0.0       | 0.0          | false    | false    |

  @PS-2137-s6
  Scenario: Charge-off on due date when loan behaviour is zero-interest and interestRecalculation = true - backdated repayment
    When Admin sets the business date to "1 January 2024"
    And Admin creates a client with random data
    And Admin creates a fully customized loan with the following data:
      | LoanProduct                                                                            | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.05     | 0    | 0         | 102.05  | 0    | 0          | 0    | 102.05      |
    And Admin successfully approves the loan on "1 January 2024" with "100" amount and expected disbursement date on "1 January 2024"
    And Admin successfully disburse the loan on "1 January 2024" with "100" EUR transaction amount
    When Admin sets the business date to "1 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0    | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.05     | 0    | 0         | 102.05  | 17.01| 0          | 0    | 85.04       |
    When Admin sets the business date to "31 March 2024"
    And Admin does charge-off the loan on "31 March 2024"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.51           | 16.54         | 0.47     | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.5            | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.49           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.49         | 0.0      | 0.0   | 0.0       | 16.49   | 0.0   | 0.0        | 0.0  | 16.49       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100           | 1.54     | 0    | 0         | 101.54  | 17.01 | 0          | 0    | 84.53     |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01   | 16.43     | 0.58     | 0.0   | 0.0       | 83.57        | false    | false    |
      | 31 March 2024    | Charge-off       | 84.53   | 83.57     | 0.96     | 0.0   | 0.0       | 0.0          | false    | false    |
#  ----- backdated repayment  on 1 March made on 31 March ----- #
    And Customer makes "AUTOPAY" repayment on "01 March 2024" with 17.01 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    | 01 March 2024    | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 3  | 31   | 01 April 2024    |                  | 50.42           | 16.63         | 0.38     | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.41           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.4            | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.4          | 0.0      | 0.0   | 0.0       | 16.4    | 0.0   | 0.0        | 0.0  | 16.4        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100           | 1.45     | 0    | 0         | 101.45  | 34.02 | 0          | 0    | 67.43       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01   | 16.43     | 0.58     | 0.0   | 0.0       | 83.57        | false    | false    |
      | 01 March 2024    | Repayment        | 17.01   | 16.52     | 0.49     | 0.0   | 0.0       | 67.05        | false    | false    |
      | 31 March 2024    | Charge-off       | 67.43   | 67.05     | 0.38     | 0.0   | 0.0       | 0.0          | false    | true     |

  @PS-2137-s11
  Scenario: Charge-off on due date when loan behaviour is zero-interest and interestRecalculation = true - CBR scenario
    When Admin sets the business date to "1 January 2024"
    And Admin creates a client with random data
    And Admin set "LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR" loan product "DEFAULT" transaction type to "NEXT_INSTALLMENT" future installment allocation rule
    And Admin creates a fully customized loan with the following data:
      | LoanProduct                                                                            | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0   |           | 0.0   |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0   | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.05     | 0    | 0         | 102.05  | 0    | 0          | 0    | 102.05      |
    And Admin successfully approves the loan on "1 January 2024" with "100" amount and expected disbursement date on "1 January 2024"
    And Admin successfully disburse the loan on "1 January 2024" with "100" EUR transaction amount
    When Admin sets the business date to "1 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    When Admin sets the business date to "1 March 2024"
    And Customer makes "AUTOPAY" repayment on "01 March 2024" with 17.01 EUR transaction amount
    When Admin sets the business date to "1 April 2024"
    And Customer makes "AUTOPAY" repayment on "01 April 2024" with 17.01 EUR transaction amount
    When Admin sets the business date to "1 May 2024"
    And Customer makes "AUTOPAY" repayment on "01 May 2024" with 17.01 EUR transaction amount
    When Admin sets the business date to "1 June 2024"
    And Customer makes "AUTOPAY" repayment on "01 June 2024" with 17.01 EUR transaction amount
    When Admin sets the business date to "1 July 2024"
    And Customer makes "AUTOPAY" repayment on "01 July 2024" with 20 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    | 01 March 2024    | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 3  | 31   | 01 April 2024    | 01 April 2024    | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 4  | 30   | 01 May 2024      | 01 May 2024      | 33.71           | 16.72         | 0.29     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 5  | 31   | 01 June 2024     | 01 June 2024     | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 6  | 30   | 01 July 2024     | 01 July 2024     | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0    | 17.0  | 0.0        | 0.0  | 0.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid   | In advance | Late | Outstanding |
      | 100           | 2.05     | 0    | 0         | 102.05  | 102.05 | 0          | 0    | 0.0         |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type      | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement          | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment             | 17.01   | 16.43     | 0.58     | 0.0   | 0.0       | 83.57        | false    | false    |
      | 01 March 2024    | Repayment             | 17.01   | 16.52     | 0.49     | 0.0   | 0.0       | 67.05        | false    | false    |
      | 01 April 2024    | Repayment             | 17.01   | 16.62     | 0.39     | 0.0   | 0.0       | 50.43        | false    | false    |
      | 01 May 2024      | Repayment             | 17.01   | 16.72     | 0.29     | 0.0   | 0.0       | 33.71        | false    | false    |
      | 01 June 2024     | Repayment             | 17.01   | 16.81     | 0.2      | 0.0   | 0.0       | 16.9         | false    | false    |
      | 01 July 2024     | Repayment             | 20.0    | 16.9      | 0.1      | 0.0   | 0.0       | 0.0          | false    | false    |
      | 01 July 2024     | Accrual               | 2.05    | 0.0       | 2.05     | 0.0   | 0.0       | 0.0          | false    | false    |
    When Admin sets the business date to "2 July 2024"
    When Admin makes Credit Balance Refund transaction on "02 July 2024" with 3 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    | 01 March 2024    | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 3  | 31   | 01 April 2024    | 01 April 2024    | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 4  | 30   | 01 May 2024      | 01 May 2024      | 33.71           | 16.72         | 0.29     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 5  | 31   | 01 June 2024     | 01 June 2024     | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 6  | 30   | 01 July 2024     | 01 July 2024     | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0    | 17.0  | 0.0        | 0.0  | 0.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid   | In advance | Late | Outstanding |
      | 100           | 2.05     | 0    | 0         | 102.05  | 102.05 | 0          | 0    | 0.0         |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type      | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement          | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment             | 17.01   | 16.43     | 0.58     | 0.0   | 0.0       | 83.57        | false    | false    |
      | 01 March 2024    | Repayment             | 17.01   | 16.52     | 0.49     | 0.0   | 0.0       | 67.05        | false    | false    |
      | 01 April 2024    | Repayment             | 17.01   | 16.62     | 0.39     | 0.0   | 0.0       | 50.43        | false    | false    |
      | 01 May 2024      | Repayment             | 17.01   | 16.72     | 0.29     | 0.0   | 0.0       | 33.71        | false    | false    |
      | 01 June 2024     | Repayment             | 17.01   | 16.81     | 0.2      | 0.0   | 0.0       | 16.9         | false    | false    |
      | 01 July 2024     | Repayment             | 20.0    | 16.9      | 0.1      | 0.0   | 0.0       | 0.0          | false    | false    |
      | 01 July 2024     | Accrual               | 2.05    | 0.0       | 2.05     | 0.0   | 0.0       | 0.0          | false    | false    |
      | 02 July 2024     | Credit Balance Refund | 3.0     | 0.0       | 0.0      | 0.0   | 0.0       | 0.0          | false    | false    |
    When Customer undo "1"th "Repayment" transaction made on "01 July 2024"
    Then Loan Repayment schedule has 7 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    | 01 March 2024    | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 3  | 31   | 01 April 2024    | 01 April 2024    | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 4  | 30   | 01 May 2024      | 01 May 2024      | 33.71           | 16.72         | 0.29     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 5  | 31   | 01 June 2024     | 01 June 2024     | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0    | 0.0   | 0.0        | 0.0  | 17.0        |
      | 7  |  1   | 02 July 2024     |                  | 0.0             | 3.0           | 0.0      | 0.0   | 0.0       | 3.0     | 0.0   | 0.0        | 0.0  | 3.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 103           | 2.05     | 0    | 0         | 105.05  | 85.05| 0          | 0    | 20.0        |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type      | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement          | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment             | 17.01   | 16.43     | 0.58     | 0.0   | 0.0       | 83.57        | false    | false    |
      | 01 March 2024    | Repayment             | 17.01   | 16.52     | 0.49     | 0.0   | 0.0       | 67.05        | false    | false    |
      | 01 April 2024    | Repayment             | 17.01   | 16.62     | 0.39     | 0.0   | 0.0       | 50.43        | false    | false    |
      | 01 May 2024      | Repayment             | 17.01   | 16.72     | 0.29     | 0.0   | 0.0       | 33.71        | false    | false    |
      | 01 June 2024     | Repayment             | 17.01   | 16.81     | 0.2      | 0.0   | 0.0       | 16.9         | false    | false    |
      | 01 July 2024     | Repayment             | 20.0    | 16.9      | 0.1      | 0.0   | 0.0       | 0.0          | true     | false    |
      | 01 July 2024     | Accrual               | 2.05    | 0.0       | 2.05     | 0.0   | 0.0       | 0.0          | false    | false    |
      | 02 July 2024     | Credit Balance Refund | 3.0     | 3.0       | 0.0      | 0.0   | 0.0       | 19.9         | false    | true     |
    When Admin sets the business date to "15 July 2024"
    And Admin does charge-off the loan on "15 July 2024"
    Then Loan Repayment schedule has 7 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    | 01 March 2024    | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 3  | 31   | 01 April 2024    | 01 April 2024    | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 4  | 30   | 01 May 2024      | 01 May 2024      | 33.71           | 16.72         | 0.29     | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 5  | 31   | 01 June 2024     | 01 June 2024     | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01   | 17.01 | 0.0        | 0.0  | 0.0         |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0    | 0.0   | 0.0        | 0.0  | 17.0        |
      | 7  |  1   | 02 July 2024     |                  | 0.0             | 3.0           | 0.0      | 0.0   | 0.0       | 3.0     | 0.0   | 0.0        | 0.0  | 3.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 103           | 2.05     | 0    | 0         | 105.05  | 85.05| 0          | 0    | 20.0        |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type      | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement          | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment             | 17.01   | 16.43     | 0.58     | 0.0   | 0.0       | 83.57        | false    | false    |
      | 01 March 2024    | Repayment             | 17.01   | 16.52     | 0.49     | 0.0   | 0.0       | 67.05        | false    | false    |
      | 01 April 2024    | Repayment             | 17.01   | 16.62     | 0.39     | 0.0   | 0.0       | 50.43        | false    | false    |
      | 01 May 2024      | Repayment             | 17.01   | 16.72     | 0.29     | 0.0   | 0.0       | 33.71        | false    | false    |
      | 01 June 2024     | Repayment             | 17.01   | 16.81     | 0.2      | 0.0   | 0.0       | 16.9         | false    | false    |
      | 01 July 2024     | Repayment             | 20.0    | 16.9      | 0.1      | 0.0   | 0.0       | 0.0          | true     | false    |
      | 01 July 2024     | Accrual               | 2.05    | 0.0       | 2.05     | 0.0   | 0.0       | 0.0          | false    | false    |
      | 02 July 2024     | Credit Balance Refund | 3.0     | 3.0       | 0.0      | 0.0   | 0.0       | 19.9         | false    | true     |
      | 15 July 2024     | Charge-off            | 20.0    | 19.9      | 0.1      | 0.0   | 0.0       | 0.0          | false    | false    |

  @PS-2137-s12
  Scenario: Charge-off on due date when loan behaviour is zero-interest and interestRecalculation = true - adjust to last installment scenario
    When Admin sets the business date to "1 January 2024"
    And Admin creates a client with random data
    And Admin set "LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR" loan product "DEFAULT" transaction type to "LAST_INSTALLMENT" future installment allocation rule
    And Admin creates a fully customized loan with the following data:
      | LoanProduct                                                                            | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0   |           | 0.0   |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0   | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0   | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0   | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0   | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0   | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0   | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.05     | 0    | 0         | 102.05  | 0    | 0          | 0    | 102.05      |
    And Admin successfully approves the loan on "1 January 2024" with "100" amount and expected disbursement date on "1 January 2024"
    And Admin successfully disburse the loan on "1 January 2024" with "100" EUR transaction amount
    When Admin sets the business date to "15 January 2024"
    And Customer makes "AUTOPAY" repayment on "15 January 2024" with 17.01 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |                  | 83.52           | 16.48         | 0.53     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |                  | 66.9            | 16.62         | 0.39     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.18           | 16.72         | 0.29     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.36           | 16.82         | 0.19     | 0.0   | 0.0       | 17.01   | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 17.01           | 16.35         | 0.1      | 0.0   | 0.0       | 16.45   | 0.0  | 0.0        | 0.0  | 16.45       |
      | 6  | 30   | 01 July 2024     | 15 January 2024  | 0.0             | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 17.01| 17.01      | 0.0  | 0.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 1.5      | 0    | 0         | 101.5   | 17.01| 17.01      | 0    | 84.49       |
    When Admin sets the business date to "29 February 2024"
    And Admin does charge-off the loan on "29 February 2024"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 |                  | 83.52           | 16.48         | 0.53     | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |                  | 66.98           | 16.54         | 0.47     | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |                  | 49.97           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 32.96           | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 17.01           | 15.95         | 0.0      | 0.0   | 0.0       | 15.95   | 0.0   | 0.0        | 0.0  | 15.95       |
      | 6  | 30   | 01 July 2024     | 15 January 2024  | 0.0             | 17.01         | 0.0      | 0.0   | 0.0       | 17.01   | 17.01 | 17.01      | 0.0  | 0.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 1.0      | 0    | 0         | 101.0   | 17.01| 17.01      | 0    | 83.99       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 15 January 2024  | Repayment        | 17.01   | 17.01     | 0.0      | 0.0   | 0.0       | 82.99        | false    | false    |
      | 29 February 2024 | Charge-off       | 83.99   | 82.99     | 1.0      | 0.0   | 0.0       | 0.0          | false    | false    |
    And Admin set "LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR" loan product "DEFAULT" transaction type to "NEXT_INSTALLMENT" future installment allocation rule

  Scenario: Charge-off on due date when loan behaviour is zero-interest and interestRecalculation = false
    When Admin sets the business date to "1 March 2023"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan without interest recalculation and with date: "1 January 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2023 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 28   | 01 March 2023    |           | 67.04           | 16.55         | 0.45     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2023    |           | 50.44           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2023      |           | 33.73           | 16.71	       | 0.29     | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2023     |           | 16.93           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.93         | 0.1      | 0.0   | 0.0       | 17.03	| 0.0  | 0.0        | 0.0  | 17.03	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.03     | 0    | 0         | 102.03  | 0    | 0          | 0    | 102.03      |
    And Admin successfully approves the loan on "1 January 2023" with "100" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "100" EUR transaction amount
    And Admin does charge-off the loan on "1 March 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 28   | 01 March 2023    |           | 67.04           | 16.55         | 0.45     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2023    |           | 50.04           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2023      |           | 33.04           | 17.0 	       | 0.0      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2023     |           | 16.04           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.04         | 0.0      | 0.0   | 0.0       | 16.04	| 0.0  | 0.0        | 0.0  | 16.04	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 1.04     | 0    | 0         | 101.04  | 0    | 0          | 0    | 101.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        |
      | 01 March 2023    | Charge-off       | 101.04  | 100.0     | 1.04     | 0.0   | 0.0       | 0.0          |

  Scenario: Charge-off after installment date when loan behaviour is zero-interest and interestRecalculation = false
    When Admin sets the business date to "1 March 2023"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan without interest recalculation and with date: "1 January 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2023 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 28   | 01 March 2023    |           | 67.04           | 16.55         | 0.45     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2023    |           | 50.44           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2023      |           | 33.73           | 16.71	       | 0.29     | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2023     |           | 16.93           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.93         | 0.1      | 0.0   | 0.0       | 17.03	| 0.0  | 0.0        | 0.0  | 17.03	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.03     | 0    | 0         | 102.03  | 0    | 0          | 0    | 102.03      |
    And Admin successfully approves the loan on "1 January 2023" with "100" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "100" EUR transaction amount
    And Admin does charge-off the loan on "28 February 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 28   | 01 March 2023    |           | 67.02           | 16.57         | 0.43     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2023    |           | 50.02           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2023      |           | 33.02           | 17.0 	       | 0.0      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2023     |           | 16.02           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.02         | 0.0      | 0.0   | 0.0       | 16.02	| 0.0  | 0.0        | 0.0  | 16.02	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 1.02     | 0    | 0         | 101.02  | 0    | 0          | 0    | 101.02      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        |
      | 28 February 2023 | Charge-off       | 101.02  | 100.0     | 1.02     | 0.0   | 0.0       | 0.0          |

  Scenario: Charge-off in the middle of installment period when loan behaviour is zero-interest and interestRecalculation = false
    When Admin sets the business date to "1 March 2023"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan without interest recalculation and with date: "1 January 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2023 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 28   | 01 March 2023    |           | 67.04           | 16.55         | 0.45     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2023    |           | 50.44           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2023      |           | 33.73           | 16.71	       | 0.29     | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2023     |           | 16.93           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.93         | 0.1      | 0.0   | 0.0       | 17.03	| 0.0  | 0.0        | 0.0  | 17.03	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.03     | 0    | 0         | 102.03  | 0    | 0          | 0    | 102.03      |
    And Admin successfully approves the loan on "1 January 2023" with "100" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "100" EUR transaction amount
    And Admin does charge-off the loan on "14 February 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 28   | 01 March 2023    |           | 66.8            | 16.79         | 0.21     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2023    |           | 49.8            | 17.0          | 0.0      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2023      |           | 32.8            | 17.0 	       | 0.0      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2023     |           | 15.8            | 17.0          | 0.0      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 15.8          | 0.0      | 0.0   | 0.0       | 15.8	| 0.0  | 0.0        | 0.0  | 15.8	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 0.8      | 0    | 0         | 100.8   | 0    | 0          | 0    | 100.8       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        |
      | 14 February 2023 | Charge-off       | 100.8   | 100.0     | 0.8      | 0.0   | 0.0       | 0.0          |

  Scenario: Charge-off after maturity date when loan behaviour is zero-interest and interestRecalculation = false
    When Admin sets the business date to "1 August 2023"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan without interest recalculation and with date: "1 January 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2023 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 28   | 01 March 2023    |           | 67.04           | 16.55         | 0.45     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2023    |           | 50.44           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2023      |           | 33.73           | 16.71	       | 0.29     | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2023     |           | 16.93           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.93         | 0.1      | 0.0   | 0.0       | 17.03	| 0.0  | 0.0        | 0.0  | 17.03	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.03     | 0    | 0         | 102.03  | 0    | 0          | 0    | 102.03      |
    And Admin successfully approves the loan on "1 January 2023" with "100" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "100" EUR transaction amount
    And Admin does charge-off the loan on "15 July 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 28   | 01 March 2023    |           | 67.04           | 16.55         | 0.45     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2023    |           | 50.44           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2023      |           | 33.73           | 16.71	       | 0.29     | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2023     |           | 16.93           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.93         | 0.1      | 0.0   | 0.0       | 17.03	| 0.0  | 0.0        | 0.0  | 17.03	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.03     | 0    | 0         | 102.03  | 0    | 0          | 0    | 102.03      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        |
      | 15 July 2023     | Charge-off       | 102.03  | 100.0     | 2.03     | 0.0   | 0.0       | 0.0          |

  Scenario: Charge-off when charge is added before the charge-off date, loan behaviour is zero-interest and interestRecalculation = false
    When Admin sets the business date to "1 March 2023"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan without interest recalculation and with date: "1 January 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2023 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 28   | 01 March 2023    |           | 67.04           | 16.55         | 0.45     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2023    |           | 50.44           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2023      |           | 33.73           | 16.71	       | 0.29     | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2023     |           | 16.93           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.93         | 0.1      | 0.0   | 0.0       | 17.03	| 0.0  | 0.0        | 0.0  | 17.03	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.03     | 0    | 0         | 102.03  | 0    | 0          | 0    | 102.03      |
    And Admin successfully approves the loan on "1 January 2023" with "100" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "100" EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "27 February 2023" due date and 3 EUR transaction amount
    And Admin does charge-off the loan on "28 February 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 28   | 01 March 2023    |           | 67.02           | 16.57         | 0.43     | 3.0   | 0.0       | 20.0    | 0.0  | 0.0        | 0.0  | 20.0        |
      | 3  | 31   | 01 April 2023    |           | 50.02           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2023      |           | 33.02           | 17.0 	       | 0.0      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2023     |           | 16.02           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.02         | 0.0      | 0.0   | 0.0       | 16.02	| 0.0  | 0.0        | 0.0  | 16.02	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 1.02     | 3.0  | 0         | 104.02  | 0    | 0          | 0    | 104.02      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        |
      | 28 February 2023 | Charge-off       | 104.02  | 100.0     | 1.02     | 3.0   | 0.0       | 0.0          |

  Scenario: Charge-off when charge is added on charge-off date, loan behaviour is zero-interest and interestRecalculation = false
    When Admin sets the business date to "1 March 2023"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan without interest recalculation and with date: "1 January 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2023 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 28   | 01 March 2023    |           | 67.04           | 16.55         | 0.45     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2023    |           | 50.44           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2023      |           | 33.73           | 16.71	       | 0.29     | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2023     |           | 16.93           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.93         | 0.1      | 0.0   | 0.0       | 17.03	| 0.0  | 0.0        | 0.0  | 17.03	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.03     | 0    | 0         | 102.03  | 0    | 0          | 0    | 102.03      |
    And Admin successfully approves the loan on "1 January 2023" with "100" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "100" EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "28 February 2023" due date and 3 EUR transaction amount
    And Admin does charge-off the loan on "28 February 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 28   | 01 March 2023    |           | 67.02           | 16.57         | 0.43     | 3.0   | 0.0       | 20.0    | 0.0  | 0.0        | 0.0  | 20.0        |
      | 3  | 31   | 01 April 2023    |           | 50.02           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2023      |           | 33.02           | 17.0 	       | 0.0      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2023     |           | 16.02           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.02         | 0.0      | 0.0   | 0.0       | 16.02	| 0.0  | 0.0        | 0.0  | 16.02	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 1.02     | 3.0  | 0         | 104.02  | 0    | 0          | 0    | 104.02      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        |
      | 28 February 2023 | Charge-off       | 104.02  | 100.0     | 1.02     | 3.0   | 0.0       | 0.0          |

  Scenario: Charge-off when charge is added after the charge off date, loan behaviour is zero-interest and interestRecalculation = false
    When Admin sets the business date to "1 March 2023"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan without interest recalculation and with date: "1 January 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2023 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 28   | 01 March 2023    |           | 67.04           | 16.55         | 0.45     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2023    |           | 50.44           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2023      |           | 33.73           | 16.71	       | 0.29     | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2023     |           | 16.93           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.93         | 0.1      | 0.0   | 0.0       | 17.03	| 0.0  | 0.0        | 0.0  | 17.03	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.03     | 0    | 0         | 102.03  | 0    | 0          | 0    | 102.03      |
    And Admin successfully approves the loan on "1 January 2023" with "100" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "100" EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "1 March 2023" due date and 3 EUR transaction amount
    And Admin does charge-off the loan on "28 February 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 28   | 01 March 2023    |           | 67.02           | 16.57         | 0.43     | 3.0   | 0.0       | 20.0    | 0.0  | 0.0        | 0.0  | 20.0        |
      | 3  | 31   | 01 April 2023    |           | 50.02           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2023      |           | 33.02           | 17.0 	       | 0.0      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2023     |           | 16.02           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.02         | 0.0      | 0.0   | 0.0       | 16.02	| 0.0  | 0.0        | 0.0  | 16.02	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 1.02     | 3.0  | 0         | 104.02  | 0    | 0          | 0    | 104.02      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        |
      | 28 February 2023 | Charge-off       | 104.02  | 100.0     | 1.02     | 3.0   | 0.0       | 0.0          |

  Scenario: Undo the charge-off when loan behaviour is zero-interest and interestRecalculation = false
    When Admin sets the business date to "1 March 2023"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan without interest recalculation and with date: "1 January 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2023 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 28   | 01 March 2023    |           | 67.04           | 16.55         | 0.45     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2023    |           | 50.44           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2023      |           | 33.73           | 16.71	       | 0.29     | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2023     |           | 16.93           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.93         | 0.1      | 0.0   | 0.0       | 17.03	| 0.0  | 0.0        | 0.0  | 17.03	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.03     | 0    | 0         | 102.03  | 0    | 0          | 0    | 102.03      |
    And Admin successfully approves the loan on "1 January 2023" with "100" amount and expected disbursement date on "1 January 2023"
    And Admin successfully disburse the loan on "1 January 2023" with "100" EUR transaction amount
    And Admin does charge-off the loan on "14 February 2023"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 28   | 01 March 2023    |           | 66.8            | 16.79         | 0.21     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2023    |           | 49.8            | 17.0          | 0.0      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2023      |           | 32.8            | 17.0 	       | 0.0      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2023     |           | 15.8            | 17.0          | 0.0      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 15.8          | 0.0      | 0.0   | 0.0       | 15.8	| 0.0  | 0.0        | 0.0  | 15.8	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 0.8      | 0    | 0         | 100.8   | 0    | 0          | 0    | 100.8       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        |
      | 14 February 2023 | Charge-off       | 100.8   | 100.0     | 0.8      | 0.0   | 0.0       | 0.0          |
    And Admin does a charge-off undo the loan
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2023  |           | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2023 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 28   | 01 March 2023    |           | 67.04           | 16.55         | 0.45     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2023    |           | 50.44           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2023      |           | 33.73           | 16.71	       | 0.29     | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2023     |           | 16.93           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2023     |           | 0.0             | 16.93         | 0.1      | 0.0   | 0.0       | 17.03	| 0.0  | 0.0        | 0.0  | 17.03	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.03     | 0    | 0         | 102.03  | 0    | 0          | 0    | 102.03      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance |
      | 01 January 2023  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        |
      | 14 February 2023 | Charge-off       | 100.8   | 100.0     | 0.8      | 0.0   | 0.0       | 0.0          |

  Scenario: Charge-off on due date when loan behaviour is zero-interest and interestRecalculation = false - repayment after charge off
    When Admin sets the business date to "1 January 2024"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan without interest recalculation and with date: "1 January 2024"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04	| 0.0  | 0.0        | 0.0  | 17.04	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    And Admin successfully approves the loan on "1 January 2024" with "100" amount and expected disbursement date on "1 January 2024"
    And Admin successfully disburse the loan on "1 January 2024" with "100" EUR transaction amount
    When Admin sets the business date to "1 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 17.0 | 0          | 0    | 85.04       |
    When Admin sets the business date to "29 February 2024"
    And Admin does charge-off the loan on "29 February 2024"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.03           | 16.56         | 0.44     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.03           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.03           | 17.0	      | 0.0      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.03           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.03         | 0.0      | 0.0   | 0.0       | 16.03   | 0.0  | 0.0        | 0.0  | 16.03	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100           | 1.03     | 0    | 0         | 101.03  | 17.0  | 0          | 0    | 84.03       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0    | 16.41     | 0.59     | 0.0   | 0.0       | 83.59        | false    | false    |
      | 29 February 2024 | Charge-off       | 84.03   | 83.59     | 0.44     | 0.0   | 0.0       | 0.0          | false    | false    |
#  ----- repayment after charge off on 1st March  ----- #
    When Admin sets the business date to "01 March 2024"
    And Customer makes "AUTOPAY" repayment on "01 March 2024" with 17.00 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    | 01 March 2024    | 67.03           | 16.56         | 0.44     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 3  | 31   | 01 April 2024    |                  | 50.03           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.03           | 17.0	      | 0.0      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.03           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.03         | 0.0      | 0.0   | 0.0       | 16.03   | 0.0  | 0.0        | 0.0  | 16.03	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100           | 1.03     | 0    | 0         | 101.03  | 34.0  | 0          | 0    | 67.03       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0    | 16.41     | 0.59     | 0.0   | 0.0       | 83.59        | false    | false    |
      | 29 February 2024 | Charge-off       | 84.03   | 83.59     | 0.44     | 0.0   | 0.0       | 0.0          | false    | false    |
      | 01 March 2024    | Repayment        | 17.0    | 16.56     | 0.44     | 0.0   | 0.0       | 67.03        | false    | false    |

  @PS-2137-s5
  Scenario: Charge-off on due date when loan behaviour is zero-interest and interestRecalculation = false - charge off after one installment is overdue (31st March)
    When Admin sets the business date to "1 January 2024"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan without interest recalculation and with date: "1 January 2024"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04	| 0.0  | 0.0        | 0.0  | 17.04	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    And Admin successfully approves the loan on "1 January 2024" with "100" amount and expected disbursement date on "1 January 2024"
    And Admin successfully disburse the loan on "1 January 2024" with "100" EUR transaction amount
    When Admin sets the business date to "1 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 17.0 | 0          | 0    | 85.04       |
    When Admin sets the business date to "31 March 2024"
    And Admin does charge-off the loan on "31 March 2024"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.44           | 16.61         | 0.39     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.44           | 17.0	      | 0.0      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.44           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.44         | 0.0      | 0.0   | 0.0       | 16.44   | 0.0  | 0.0        | 0.0  | 16.44	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100           | 1.44     | 0    | 0         | 101.44  | 17.0  | 0          | 0    | 84.44       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0    | 16.41     | 0.59     | 0.0   | 0.0       | 83.59        | false    | false    |
      | 31 March 2024    | Charge-off       | 84.44   | 83.59     | 0.85     | 0.0   | 0.0       | 0.0          | false    | false    |

  @PS-2137-s6
  Scenario: Charge-off on due date when loan behaviour is zero-interest and interestRecalculation = false - backdated repayment
    When Admin sets the business date to "1 January 2024"
    And Admin creates a client with random data
    When Admin creates a new zero charge-off Loan without interest recalculation and with date: "1 January 2024"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04	| 0.0  | 0.0        | 0.0  | 17.04	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    And Admin successfully approves the loan on "1 January 2024" with "100" amount and expected disbursement date on "1 January 2024"
    And Admin successfully disburse the loan on "1 January 2024" with "100" EUR transaction amount
    When Admin sets the business date to "1 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 17.0 | 0          | 0    | 85.04       |
    When Admin sets the business date to "31 March 2024"
    And Admin does charge-off the loan on "31 March 2024"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.44           | 16.61         | 0.39     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.44           | 17.0	      | 0.0      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.44           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.44         | 0.0      | 0.0   | 0.0       | 16.44   | 0.0  | 0.0        | 0.0  | 16.44	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100           | 1.44     | 0    | 0         | 101.44  | 17.0  | 0          | 0    | 84.44       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0    | 16.41     | 0.59     | 0.0   | 0.0       | 83.59        | false    | false    |
      | 31 March 2024    | Charge-off       | 84.44   | 83.59     | 0.85     | 0.0   | 0.0       | 0.0          | false    | false    |
#  ----- backdated repayment  on 1 March made on 31 March ----- #
    And Customer makes "AUTOPAY" repayment on "01 March 2024" with 17.00 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    | 01 March 2024    | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 3  | 31   | 01 April 2024    |                  | 50.44           | 16.61         | 0.39     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.44           | 17.0	      | 0.0      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.44           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.44         | 0.0      | 0.0   | 0.0       | 16.44   | 0.0  | 0.0        | 0.0  | 16.44	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100           | 1.44     | 0    | 0         | 101.44  | 34.0  | 0          | 0    | 67.44       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0    | 16.41     | 0.59     | 0.0   | 0.0       | 83.59        | false    | false    |
      | 01 March 2024    | Repayment        | 17.0    | 16.54     | 0.46     | 0.0   | 0.0       | 67.05        | false    | false    |
      | 31 March 2024    | Charge-off       | 67.44   | 67.05     | 0.39     | 0.0   | 0.0       | 0.0          | false    | true     |

  @PS-2137-s11
  Scenario: Charge-off on due date when loan behaviour is zero-interest and interestRecalculation = false - CBR scenario
    When Admin sets the business date to "1 January 2024"
    And Admin creates a client with random data
    And Admin set "LP2_ADV_PYMNT_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR" loan product "DEFAULT" transaction type to "NEXT_INSTALLMENT" future installment allocation rule
    When Admin creates a new zero charge-off Loan without interest recalculation and with date: "1 January 2024"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0   |           | 0.0   |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0   | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0 	   |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0	       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04	   |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    And Admin successfully approves the loan on "1 January 2024" with "100" amount and expected disbursement date on "1 January 2024"
    And Admin successfully disburse the loan on "1 January 2024" with "100" EUR transaction amount
    When Admin sets the business date to "1 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    When Admin sets the business date to "1 March 2024"
    And Customer makes "AUTOPAY" repayment on "01 March 2024" with 17.00 EUR transaction amount
    When Admin sets the business date to "1 April 2024"
    And Customer makes "AUTOPAY" repayment on "01 April 2024" with 17.00 EUR transaction amount
    When Admin sets the business date to "1 May 2024"
    And Customer makes "AUTOPAY" repayment on "01 May 2024" with 17.00 EUR transaction amount
    When Admin sets the business date to "1 June 2024"
    And Customer makes "AUTOPAY" repayment on "01 June 2024" with 17.00 EUR transaction amount
    When Admin sets the business date to "1 July 2024"
    And Customer makes "AUTOPAY" repayment on "01 July 2024" with 20.04 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0  | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    | 01 March 2024    | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 17.0  | 0.0        | 0.0  | 0.0         |
      | 3  | 31   | 01 April 2024    | 01 April 2024    | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 17.0  | 0.0        | 0.0  | 0.0         |
      | 4  | 30   | 01 May 2024      | 01 May 2024      | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 17.0  | 0.0        | 0.0  | 0.0 	     |
      | 5  | 31   | 01 June 2024     | 01 June 2024     | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 17.0  | 0.0        | 0.0  | 0.0	     |
      | 6  | 30   | 01 July 2024     | 01 July 2024     | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 17.04 | 0.0        | 0.0  | 0.0	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid   | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 102.04 | 0          | 0    | 0.0         |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type      | Amount | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement          | 100.0  | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment             | 17.0   | 16.41     | 0.59     | 0.0   | 0.0       | 83.59        | false    | false    |
      | 01 March 2024    | Repayment             | 17.0   | 16.54     | 0.46     | 0.0   | 0.0       | 67.05        | false    | false    |
      | 01 April 2024    | Repayment             | 17.0   | 16.6      | 0.4      | 0.0   | 0.0       | 50.45        | false    | false    |
      | 01 May 2024      | Repayment             | 17.0   | 16.71     | 0.29     | 0.0   | 0.0       | 33.74        | false    | false    |
      | 01 June 2024     | Repayment             | 17.0   | 16.8      | 0.2      | 0.0   | 0.0       | 16.94        | false    | false    |
      | 01 July 2024     | Repayment             | 20.04  | 16.94     | 0.1      | 0.0   | 0.0       | 0.0          | false    | false    |
      | 01 July 2024     | Accrual               | 2.04   | 0.0       | 2.04     | 0.0   | 0.0       | 0.0          | false    | false    |
    When Admin sets the business date to "2 July 2024"
    When Admin makes Credit Balance Refund transaction on "02 July 2024" with 3 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0  | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    | 01 March 2024    | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 17.0  | 0.0        | 0.0  | 0.0         |
      | 3  | 31   | 01 April 2024    | 01 April 2024    | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 17.0  | 0.0        | 0.0  | 0.0         |
      | 4  | 30   | 01 May 2024      | 01 May 2024      | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 17.0  | 0.0        | 0.0  | 0.0 	     |
      | 5  | 31   | 01 June 2024     | 01 June 2024     | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 17.0  | 0.0        | 0.0  | 0.0	     |
      | 6  | 30   | 01 July 2024     | 01 July 2024     | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 17.04 | 0.0        | 0.0  | 0.0	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid   | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 102.04 | 0          | 0    | 0.0         |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type      | Amount | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement          | 100.0  | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment             | 17.0   | 16.41     | 0.59     | 0.0   | 0.0       | 83.59        | false    | false    |
      | 01 March 2024    | Repayment             | 17.0   | 16.54     | 0.46     | 0.0   | 0.0       | 67.05        | false    | false    |
      | 01 April 2024    | Repayment             | 17.0   | 16.6      | 0.4      | 0.0   | 0.0       | 50.45        | false    | false    |
      | 01 May 2024      | Repayment             | 17.0   | 16.71     | 0.29     | 0.0   | 0.0       | 33.74        | false    | false    |
      | 01 June 2024     | Repayment             | 17.0   | 16.8      | 0.2      | 0.0   | 0.0       | 16.94        | false    | false    |
      | 01 July 2024     | Repayment             | 20.04  | 16.94     | 0.1      | 0.0   | 0.0       | 0.0          | false    | false    |
      | 01 July 2024     | Accrual               | 2.04   | 0.0       | 2.04     | 0.0   | 0.0       | 0.0          | false    | false    |
      | 02 July 2024     | Credit Balance Refund | 3.0    | 0.0       | 0.0      | 0.0   | 0.0       | 0.0          | false    | false    |
    When Customer undo "1"th "Repayment" transaction made on "01 July 2024"
    Then Loan Repayment schedule has 7 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0  | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    | 01 March 2024    | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 17.0  | 0.0        | 0.0  | 0.0         |
      | 3  | 31   | 01 April 2024    | 01 April 2024    | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 17.0  | 0.0        | 0.0  | 0.0         |
      | 4  | 30   | 01 May 2024      | 01 May 2024      | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 17.0  | 0.0        | 0.0  | 0.0 	     |
      | 5  | 31   | 01 June 2024     | 01 June 2024     | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 17.0  | 0.0        | 0.0  | 0.0	     |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0   | 0.0        | 0.0  | 17.04       |
      | 7  |  1   | 02 July 2024     |                  | 0.0             | 3.0           | 0.0      | 0.0   | 0.0       | 3.0     | 0.0   | 0.0        | 0.0  | 3.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 103           | 2.04     | 0    | 0         | 105.04  | 85.0 | 0          | 0    | 20.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type      | Amount | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement          | 100.0  | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment             | 17.0   | 16.41     | 0.59     | 0.0   | 0.0       | 83.59        | false    | false    |
      | 01 March 2024    | Repayment             | 17.0   | 16.54     | 0.46     | 0.0   | 0.0       | 67.05        | false    | false    |
      | 01 April 2024    | Repayment             | 17.0   | 16.6      | 0.4      | 0.0   | 0.0       | 50.45        | false    | false    |
      | 01 May 2024      | Repayment             | 17.0   | 16.71     | 0.29     | 0.0   | 0.0       | 33.74        | false    | false    |
      | 01 June 2024     | Repayment             | 17.0   | 16.8      | 0.2      | 0.0   | 0.0       | 16.94        | false    | false    |
      | 01 July 2024     | Repayment             | 20.04  | 16.94     | 0.1      | 0.0   | 0.0       | 0.0          | true     | false    |
      | 01 July 2024     | Accrual               | 2.04   | 0.0       | 2.04     | 0.0   | 0.0       | 0.0          | false    | false    |
      | 02 July 2024     | Credit Balance Refund | 3.0    | 3.0       | 0.0      | 0.0   | 0.0       | 19.94        | false    | true     |
    When Admin sets the business date to "15 July 2024"
    And Admin does charge-off the loan on "15 July 2024"
    Then Loan Repayment schedule has 7 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0  | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    | 01 March 2024    | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 17.0  | 0.0        | 0.0  | 0.0         |
      | 3  | 31   | 01 April 2024    | 01 April 2024    | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 17.0  | 0.0        | 0.0  | 0.0         |
      | 4  | 30   | 01 May 2024      | 01 May 2024      | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 17.0  | 0.0        | 0.0  | 0.0 	     |
      | 5  | 31   | 01 June 2024     | 01 June 2024     | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 17.0  | 0.0        | 0.0  | 0.0	     |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0   | 0.0        | 0.0  | 17.04       |
      | 7  |  1   | 02 July 2024     |                  | 0.0             | 3.0           | 0.0      | 0.0   | 0.0       | 3.0     | 0.0   | 0.0        | 0.0  | 3.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 103           | 2.04     | 0    | 0         | 105.04  | 85.0  | 0          | 0    | 20.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type      | Amount | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement          | 100.0  | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment             | 17.0   | 16.41     | 0.59     | 0.0   | 0.0       | 83.59        | false    | false    |
      | 01 March 2024    | Repayment             | 17.0   | 16.54     | 0.46     | 0.0   | 0.0       | 67.05        | false    | false    |
      | 01 April 2024    | Repayment             | 17.0   | 16.6      | 0.4      | 0.0   | 0.0       | 50.45        | false    | false    |
      | 01 May 2024      | Repayment             | 17.0   | 16.71     | 0.29     | 0.0   | 0.0       | 33.74        | false    | false    |
      | 01 June 2024     | Repayment             | 17.0   | 16.8      | 0.2      | 0.0   | 0.0       | 16.94        | false    | false    |
      | 01 July 2024     | Repayment             | 20.04  | 16.94     | 0.1      | 0.0   | 0.0       | 0.0          | true     | false    |
      | 01 July 2024     | Accrual               | 2.04   | 0.0       | 2.04     | 0.0   | 0.0       | 0.0          | false    | false    |
      | 02 July 2024     | Credit Balance Refund | 3.0    | 3.0       | 0.0      | 0.0   | 0.0       | 19.94        | false    | true     |
      | 15 July 2024     | Charge-off            | 20.04  | 19.94     | 0.1      | 0.0   | 0.0       | 0.0          | false    | false    |

  @PS-2137-s12
  Scenario: Charge-off on due date when loan behaviour is zero-interest and interestRecalculation = false - adjust to last installment scenario
    When Admin sets the business date to "1 January 2024"
    And Admin creates a client with random data
    And Admin set "LP2_ADV_PYMNT_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR" loan product "DEFAULT" transaction type to "LAST_INSTALLMENT" future installment allocation rule
    And Admin creates a fully customized loan with the following data:
      | LoanProduct                                      | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04	| 0.0  | 0.0        | 0.0  | 17.04	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    And Admin successfully approves the loan on "1 January 2024" with "100" amount and expected disbursement date on "1 January 2024"
    And Admin successfully disburse the loan on "1 January 2024" with "100" EUR transaction amount
    When Admin sets the business date to "15 January 2024"
    And Customer makes "AUTOPAY" repayment on "15 January 2024" with 17.04 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date       | Balance of loan | Principal due | Interest | Fees  | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                 | 100.0           |               |          | 0.0   |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 |                 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |                 | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                 | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                 | 33.74           | 16.71	     | 0.29     | 0.0   | 0.0       | 17.0	| 0.0   | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |                 | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	| 0.0   | 0.0        | 0.0  | 17.0	      |
      | 6  | 30   | 01 July 2024     | 15 January 2024 | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04 | 17.04 | 17.04      | 0.0  | 0.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 17.04 | 17.04      | 0    | 85.0        |
    When Admin sets the business date to "29 February 2024"
    And Admin does charge-off the loan on "29 February 2024"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date       | Balance of loan | Principal due | Interest | Fees  | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                 | 100.0           |               |          | 0.0   |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 |                 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |                 | 67.03           | 16.56         | 0.44     | 0.0   | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                 | 50.03           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                 | 33.03           | 17.0	         | 0.0      | 0.0   | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |                 | 16.94           | 16.09         | 0.0      | 0.0   | 0.0       | 16.09 | 0.0   | 0.0        | 0.0  | 16.09       |
      | 6  | 30   | 01 July 2024     | 15 January 2024 | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04 | 17.04 | 17.04      | 0.0  | 0.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100           | 1.13     | 0    | 0         | 101.13  | 17.04 | 17.04      | 0    | 84.09       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 15 January 2024  | Repayment        | 17.04   | 16.94     | 0.1      | 0.0   | 0.0       | 83.06        | false    | false    |
      | 29 February 2024 | Charge-off       | 84.09   | 83.06     | 1.03     | 0.0   | 0.0       | 0.0          | false    | false    |
    And Admin set "LP2_ADV_PYMNT_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR" loan product "DEFAULT" transaction type to "NEXT_INSTALLMENT" future installment allocation rule

  @PS-2137-s12
  Scenario: Charge-off on due date when loan behaviour is zero-interest and interestRecalculation = false - adjust to last installment scenario, not fully paid
    When Admin sets the business date to "1 January 2024"
    And Admin creates a client with random data
    And Admin set "LP2_ADV_PYMNT_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR" loan product "DEFAULT" transaction type to "LAST_INSTALLMENT" future installment allocation rule
    And Admin creates a fully customized loan with the following data:
      | LoanProduct                                      | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | SAME_AS_REPAYMENT_PERIOD    | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0   |           | 0.0     |      |            |      | 0.0         |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0 	     |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	| 0.0  | 0.0        | 0.0  | 17.0	     |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04	| 0.0  | 0.0        | 0.0  | 17.04	     |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    And Admin successfully approves the loan on "1 January 2024" with "100" amount and expected disbursement date on "1 January 2024"
    And Admin successfully disburse the loan on "1 January 2024" with "100" EUR transaction amount
    When Admin sets the business date to "15 January 2024"
    And Customer makes "AUTOPAY" repayment on "15 January 2024" with 17.15 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date       | Balance of loan | Principal due | Interest | Fees  | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                 | 100.0           |               |          | 0.0   |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 |                 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |                 | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                 | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                 | 33.74           | 16.71	     | 0.29     | 0.0   | 0.0       | 17.0	| 0.0   | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |                 | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	| 0.11  | 0.11       | 0.0  | 16.89	      |
      | 6  | 30   | 01 July 2024     | 15 January 2024 | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04 | 17.04 | 17.04      | 0.0  | 0.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 17.15 | 17.15      | 0    | 84.89       |
    When Admin sets the business date to "29 February 2024"
    And Admin does charge-off the loan on "29 February 2024"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date       | Balance of loan | Principal due | Interest | Fees  | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                 | 100.0           |               |          | 0.0   |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 |                 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |                 | 67.03           | 16.56         | 0.44     | 0.0   | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                 | 50.03           | 17.0          | 0.0      | 0.0   | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                 | 33.03           | 17.0	         | 0.0      | 0.0   | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |                 | 16.94           | 16.09         | 0.11     | 0.0   | 0.0       | 16.2  | 0.11  | 0.11       | 0.0  | 16.09       |
      | 6  | 30   | 01 July 2024     | 15 January 2024 | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04 | 17.04 | 17.04      | 0.0  | 0.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100           | 1.24     | 0    | 0         | 101.24  | 17.15 | 17.15      | 0    | 84.09       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount  | Principal | Interest | Fees  | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0   | 0.0       | 0.0      | 0.0   | 0.0       | 100.0        | false    | false    |
      | 15 January 2024  | Repayment        | 17.15   | 16.94     | 0.21     | 0.0   | 0.0       | 83.06        | false    | false    |
      | 29 February 2024 | Charge-off       | 84.09   | 83.06     | 1.03     | 0.0   | 0.0       | 0.0          | false    | false    |
    And Admin set "LP2_ADV_PYMNT_ZERO_INTEREST_CHARGE_OFF_BEHAVIOUR" loan product "DEFAULT" transaction type to "NEXT_INSTALLMENT" future installment allocation rule

  @TestRailId:C3352 @AdvancedPaymentAllocation
  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is enabled - case when charge-off occurs on due date
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                            | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR  | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 0.0  | 0.0        | 0.0  | 102.05      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 17.01 | 0.0        | 0.0  | 85.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
    When Admin sets the business date to "1 March 2024"
    And Admin does charge-off the loan on "1 March 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 0.0             | 83.57         | 0.49     | 0.0  | 0.0       | 84.06 | 0.0   | 0.0        | 0.0  | 84.06       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.07     | 0.0  | 0.0       | 101.07  | 17.01 | 0.0        | 0.0  | 84.06       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 01 March 2024    | Charge-off       | 84.06  | 83.57     | 0.49     | 0.0  | 0.0       | 0.0          | false    | false    |
    When Admin sets the business date to "1 March 2024"
    And Admin does a charge-off undo the loan
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late  | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |       |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0   | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0   | 17.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0   | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0   | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0   | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0   | 0.0        | 0.0   | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late  | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 17.01 | 0.0        |  0.0  | 85.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type    | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement        | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment           | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 01 March 2024    | Charge-off          | 84.06  | 83.57     | 0.49     | 0.0  | 0.0       | 0.0          | true     | false    |

  @TestRailId:C3353 @AdvancedPaymentAllocation
  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is enabled - case when charge-off occurs before installment date
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                            | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR  | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 0.0  | 0.0        | 0.0  | 102.05      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 17.01 | 0.0        | 0.0  | 85.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
    When Admin sets the business date to "29 February 2024"
    And Admin does charge-off the loan on "29 February 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 28   | 29 February 2024 |                  | 0.0             | 83.57         | 0.47     | 0.0  | 0.0       | 84.04 | 0.0   | 0.0        | 0.0  | 84.04       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.05     | 0.0  | 0.0       | 101.05  | 17.01 | 0.0        | 0.0  | 84.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 29 February 2024 | Charge-off       | 84.04  | 83.57     | 0.47     | 0.0  | 0.0       | 0.0          | false    | false    |

  @TestRailId:C3354 @AdvancedPaymentAllocation
  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is enabled - case when charge-off occurs in the middle of installment period
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                            | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR  | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 0.0  | 0.0        | 0.0  | 102.05      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 17.01 | 0.0        | 0.0  | 85.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
    When Admin sets the business date to "14 February 2024"
    And Admin does charge-off the loan on "14 February 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 13   | 14 February 2024 |                  | 0.0             | 83.57         | 0.22     | 0.0  | 0.0       | 83.79 | 0.0   | 0.0        | 0.0  | 83.79       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 0.8      | 0.0  | 0.0       | 100.8   | 17.01 | 0.0        | 0.0  | 83.79       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 14 February 2024 | Charge-off       | 83.79  | 83.57     | 0.22     | 0.0  | 0.0       | 0.0          | false    | false    |

  @TestRailId:C3355 @AdvancedPaymentAllocation
  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is enabled - case when charge-off occurs after maturity date
    Given Global configuration "is-principal-compounding-disabled-for-overdue-loans" is enabled
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                            | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR  | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 0.0  | 0.0        | 0.0  | 102.05      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    When Admin sets the business date to "01 March 2024"
    And Customer makes "AUTOPAY" repayment on "01 March 2024" with 17.01 EUR transaction amount
    When Admin sets the business date to "01 April 2024"
    And Customer makes "AUTOPAY" repayment on "01 April 2024" with 17.01 EUR transaction amount
    When Admin sets the business date to "01 May 2024"
    And Customer makes "AUTOPAY" repayment on "01 May 2024" with 17.01 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    | 01 March 2024    | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 3  | 31   | 01 April 2024    | 01 April 2024    | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 4  | 30   | 01 May 2024      | 01 May 2024      | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 68.04 | 0.0        | 0.0  | 34.01       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 01 March 2024    | Repayment        | 17.01  | 16.52     | 0.49     | 0.0  | 0.0       | 67.05        | false    | false    |
      | 01 April 2024    | Repayment        | 17.01  | 16.62     | 0.39     | 0.0  | 0.0       | 50.43        | false    | false    |
      | 01 May 2024      | Repayment        | 17.01  | 16.72     | 0.29     | 0.0  | 0.0       | 33.71        | false    | false    |
    When Admin sets the business date to "15 July 2024"
    And Admin does charge-off the loan on "15 July 2024"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    | 01 March 2024    | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 3  | 31   | 01 April 2024    | 01 April 2024    | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 4  | 30   | 01 May 2024      | 01 May 2024      | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.2      | 0.0  | 0.0       | 17.1  | 0.0   | 0.0        | 0.0  | 17.1        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.15     | 0.0  | 0.0       | 102.15  | 68.04 | 0.0        | 0.0  | 34.11       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 01 March 2024    | Repayment        | 17.01  | 16.52     | 0.49     | 0.0  | 0.0       | 67.05        | false    | false    |
      | 01 April 2024    | Repayment        | 17.01  | 16.62     | 0.39     | 0.0  | 0.0       | 50.43        | false    | false    |
      | 01 May 2024      | Repayment        | 17.01  | 16.72     | 0.29     | 0.0  | 0.0       | 33.71        | false    | false    |
      | 15 July 2024     | Charge-off       | 34.11  | 33.71     | 0.4      | 0.0  | 0.0       | 0.0          | false    | false    |
    Given Global configuration "is-principal-compounding-disabled-for-overdue-loans" is disabled

  @TestRailId:C3356 @AdvancedPaymentAllocation
  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is enabled - case when charge-off occurs after one installment is overdue
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                            | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR  | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 0.0  | 0.0        | 0.0  | 102.05      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 17.01 | 0.0        | 0.0  | 85.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
    When Admin sets the business date to "31 March 2024"
    And Admin does charge-off the loan on "31 March 2024"
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late  | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |       |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0   | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0   | 17.01       |
      | 3  | 30   | 31 March 2024    |                  | 0.0             | 67.05         | 0.47     | 0.0  | 0.0       | 67.52 | 0.0   | 0.0        | 0.0   | 67.52       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late   | Outstanding |
      | 100.0         | 1.54     | 0.0  | 0.0       | 101.54  | 17.01 | 0.0        | 0.0    | 84.53       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 31 March 2024    | Charge-off       | 84.53  | 83.57     | 0.96     | 0.0  | 0.0       | 0.0          | false    | false    |
    When Admin sets the business date to "02 April 2024"
    When Admin runs inline COB job for Loan
    Then Loan has 17.01 total overdue amount
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late  | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |       |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0   | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0   | 17.01       |
      | 3  | 30   | 31 March 2024    |                  | 0.0             | 67.05         | 0.47     | 0.0  | 0.0       | 67.52 | 0.0   | 0.0        | 0.0   | 67.52       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late  | Outstanding |
      | 100.0         | 1.54     | 0.0  | 0.0       | 101.54  | 17.01 | 0.0        | 0.0   | 84.53       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 31 March 2024    | Charge-off       | 84.53  | 83.57     | 0.96     | 0.0  | 0.0       | 0.0          | false    | false    |

  @TestRailId:C3359 @AdvancedPaymentAllocation
  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is enabled - case when repayment occurs after charge-off
    Given Global configuration "is-principal-compounding-disabled-for-overdue-loans" is enabled
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                                                                   | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR  | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 0.0  | 0.0        | 0.0  | 102.05      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 17.01 | 0.0        | 0.0  | 85.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
    When Admin sets the business date to "29 February 2024"
    And Admin does charge-off the loan on "29 February 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 28   | 29 February 2024 |                  | 0.0             | 83.57         | 0.47     | 0.0  | 0.0       | 84.04 | 0.0   | 0.0        | 0.0  | 84.04       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.05     | 0.0  | 0.0       | 101.05  | 17.01 | 0.0        | 0.0  | 84.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 29 February 2024 | Charge-off       | 84.04  | 83.57     | 0.47     | 0.0  | 0.0       | 0.0          | false    | false    |
    When Admin sets the business date to "01 March 2024"
    And Customer makes "AUTOPAY" repayment on "01 March 2024" with 17.01 EUR transaction amount
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late  | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |       |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0   | 0.0         |
      | 2  | 28   | 29 February 2024 |                  | 0.0             | 83.57         | 0.47     | 0.0  | 0.0       | 84.04 | 17.01 | 0.0        | 17.01 | 67.03       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late  | Outstanding |
      | 100.0         | 1.05     | 0.0  | 0.0       | 101.05  | 34.02 | 0.0        | 17.01 | 67.03       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 29 February 2024 | Charge-off       | 84.04  | 83.57     | 0.47     | 0.0  | 0.0       | 0.0          | false    | false    |
      | 01 March 2024    | Repayment        | 17.01  | 16.54     | 0.47     | 0.0  | 0.0       | 67.03        | false    | false    |
    And Global configuration "is-principal-compounding-disabled-for-overdue-loans" is disabled

  @TestRailId:C3358 @AdvancedPaymentAllocation
  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is enabled - case when repayment reversal occurs after charge-off
    Given Global configuration "is-principal-compounding-disabled-for-overdue-loans" is enabled
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                                                                   | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR  | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 0.0  | 0.0        | 0.0  | 102.05      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 17.01 | 0.0        | 0.0  | 85.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
    When Admin sets the business date to "29 February 2024"
    And Admin does charge-off the loan on "29 February 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 28   | 29 February 2024 |                  | 0.0             | 83.57         | 0.47     | 0.0  | 0.0       | 84.04 | 0.0   | 0.0        | 0.0  | 84.04       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.05     | 0.0  | 0.0       | 101.05  | 17.01 | 0.0        | 0.0  | 84.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 29 February 2024 | Charge-off       | 84.04  | 83.57     | 0.47     | 0.0  | 0.0       | 0.0          | false    | false    |
    When Customer undo "1"th repayment on "01 February 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late  | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |       |             |
      | 1  | 31   | 01 February 2024 |                  | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0   | 17.01       |
      | 2  | 28   | 29 February 2024 |                  | 0.0             | 83.57         | 0.56     | 0.0  | 0.0       | 84.13 | 0.0   | 0.0        | 0.0   | 84.13       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late  | Outstanding |
      | 100.0         | 1.14     | 0.0  | 0.0       | 101.14  | 0.0   | 0.0        | 0.0   | 101.14      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | true     | false    |
      | 29 February 2024 | Charge-off       | 101.14 | 100.0     | 1.14     | 0.0  | 0.0       | 0.0          | false    | true     |
    And Global configuration "is-principal-compounding-disabled-for-overdue-loans" is disabled

  @TestRailId:C3357 @AdvancedPaymentAllocation
  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is enabled - case when backdated repayment occurs after charge-off
    Given Global configuration "is-principal-compounding-disabled-for-overdue-loans" is enabled
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                                                                   | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR  | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 0.0  | 0.0        | 0.0  | 102.05      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 17.01 | 0.0        | 0.0  | 85.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
    When Admin sets the business date to "31 March 2024"
    And Admin does charge-off the loan on "31 March 2024"
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late  | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |       |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0   | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0   | 17.01       |
      | 3  | 30   | 31 March 2024    |                  | 0.0             | 67.05         | 0.47     | 0.0  | 0.0       | 67.52 | 0.0   | 0.0        | 0.0   | 67.52       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late   | Outstanding |
      | 100.0         | 1.54     | 0.0  | 0.0       | 101.54  | 17.01 | 0.0        | 0.0    | 84.53       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 31 March 2024    | Charge-off       | 84.53  | 83.57     | 0.96     | 0.0  | 0.0       | 0.0          | false    | false    |
#    --- Backdated repayment ---
    And Customer makes "AUTOPAY" repayment on "01 March 2024" with 17.01 EUR transaction amount
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late  | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |       |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0   | 0.0         |
      | 2  | 29   | 01 March 2024    |  01 March 2024   | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0   | 0.0         |
      | 3  | 30   | 31 March 2024    |                  | 0.0             | 67.05         | 0.38     | 0.0  | 0.0       | 67.43 | 0.0   | 0.0        | 0.0   | 67.43       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late   | Outstanding |
      | 100.0         | 1.45     | 0.0  | 0.0       | 101.45  | 34.02 | 0.0        | 0.0    | 67.43       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 01 March 2024    | Repayment        | 17.01  | 16.52     | 0.49     | 0.0  | 0.0       | 67.05        | false    | false    |
      | 31 March 2024    | Charge-off       | 67.43  | 67.05     | 0.38     | 0.0  | 0.0       | 0.0          | false    | true     |
    And Global configuration "is-principal-compounding-disabled-for-overdue-loans" is disabled

  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is enabled - case when one fee charge due date is before charge-off date
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                                                                   | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR  | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 0.0  | 0.0        | 0.0  | 102.05      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "15 February 2024" due date and 5 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 5.0  | 0.0       | 22.01 | 0.0   | 0.0        | 0.0  | 22.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 5.0  | 0.0       | 107.05  | 17.01 | 0.0        | 0.0  | 90.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
    When Admin sets the business date to "01 March 2024"
    And Admin does charge-off the loan on "01 March 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 0.0             | 83.57         | 0.49     | 5.0  | 0.0       | 89.06 | 0.0   | 0.0        | 0.0  | 89.06       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.07     | 5.0  | 0.0       | 106.07  | 17.01 | 0.0        | 0.0  | 89.06       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 01 March 2024    | Charge-off       | 89.06  | 83.57     | 0.49     | 5.0  | 0.0       | 0.0          | false    | false    |

  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is enabled - case when couple fee charges due dates is before charge-off date
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                                                                   | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR  | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 0.0  | 0.0        | 0.0  | 102.05      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "15 February 2024" due date and 5 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "20 February 2024" due date and 3 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 8.0  | 0.0       | 25.01 | 0.0   | 0.0        | 0.0  | 25.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 8.0  | 0.0       | 110.05  | 17.01 | 0.0        | 0.0  | 93.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
    When Admin sets the business date to "01 March 2024"
    And Admin does charge-off the loan on "01 March 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 0.0             | 83.57         | 0.49     | 8.0  | 0.0       | 92.06 | 0.0   | 0.0        | 0.0  | 92.06       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.07     | 8.0  | 0.0       | 109.07  | 17.01 | 0.0        | 0.0  | 92.06       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 01 March 2024    | Charge-off       | 92.06  | 83.57     | 0.49     | 8.0  | 0.0       | 0.0          | false    | false    |

  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is enabled - case when fee and penalty charges due dates is before charge-off date
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                                                                   | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR  | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 0.0  | 0.0        | 0.0  | 102.05      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "15 February 2024" due date and 5 EUR transaction amount
    When Admin sets the business date to "15 February 2024"
    And Admin adds an NSF fee because of payment bounce with "15 February 2024" transaction date
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 5.0  | 10.0      | 32.01 | 0.0   | 0.0        | 0.0  | 32.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 5.0  | 10.0      | 117.05  | 17.01 | 0.0        | 0.0  | 100.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
    When Admin sets the business date to "01 March 2024"
    And Admin does charge-off the loan on "01 March 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 0.0             | 83.57         | 0.49     | 5.0  | 10.0      | 99.06 | 0.0   | 0.0        | 0.0  | 99.06       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.07     | 5.0  | 10.0      | 116.07  | 17.01 | 0.0        | 0.0  | 99.06       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 01 March 2024    | Charge-off       | 99.06  | 83.57     | 0.49     | 5.0  | 10.0      | 0.0          | false    | false    |

  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is enabled - case when fee and penalty charges due dates is before charge-off date, and one charge is waived after charge-off
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                                                                   | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR  | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 0.0  | 0.0        | 0.0  | 102.05      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "15 February 2024" due date and 5 EUR transaction amount
    When Admin sets the business date to "15 February 2024"
    And Admin adds an NSF fee because of payment bounce with "15 February 2024" transaction date
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 5.0  | 10.0      | 32.01 | 0.0   | 0.0        | 0.0  | 32.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 5.0  | 10.0      | 117.05  | 17.01 | 0.0        | 0.0  | 100.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
    When Admin sets the business date to "01 March 2024"
    And Admin does charge-off the loan on "01 March 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 0.0             | 83.57         | 0.49     | 5.0  | 10.0      | 99.06 | 0.0   | 0.0        | 0.0  | 99.06       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.07     | 5.0  | 10.0      | 116.07  | 17.01 | 0.0        | 0.0  | 99.06       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 01 March 2024    | Charge-off       | 99.06  | 83.57     | 0.49     | 5.0  | 10.0      | 0.0          | false    | false    |
    And Admin waives due date charge
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 0.0             | 83.57         | 0.49     | 5.0  | 10.0      | 99.06 | 0.0   | 0.0        | 0.0  | 94.06       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.07     | 5.0  | 10.0      | 116.07  | 17.01 | 0.0        | 0.0  | 94.06       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type   | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement       | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment          | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 15 February 2024 | Waive loan charges | 5.0    | 0.0       | 0.0      | 0.0  | 0.0       | 83.57        | false    | false    |
      | 01 March 2024    | Charge-off         | 94.06  | 83.57     | 0.49     | 0.0  | 10.0      | 0.0          | false    | true     |

  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is enabled - case when one fee charge is added after the charge off date
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                                                                   | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR  | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 0.0  | 0.0        | 0.0  | 102.05      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "05 March 2024" due date and 5 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 5.0  | 0.0       | 22.01 | 0.0   | 0.0        | 0.0  | 22.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 5.0  | 0.0       | 107.05  | 17.01 | 0.0        | 0.0  | 90.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
    When Admin sets the business date to "01 March 2024"
    And Admin does charge-off the loan on "01 March 2024"
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 0.0             | 83.57         | 0.49     | 0.0  | 0.0       | 84.06 | 0.0   | 0.0        | 0.0  | 84.06       |
      | 3  | 4    | 05 March 2024    |                  | 0.0             | 0.0           | 0.0      | 5.0  | 0.0       | 5.0   | 0.0   | 0.0        | 0.0  | 5.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.07     | 5.0  | 0.0       | 106.07  | 17.01 | 0.0        | 0.0  | 89.06       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 01 March 2024    | Charge-off       | 89.06  | 83.57     | 0.49     | 5.0  | 0.0       | 0.0          | false    | false    |

  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is enabled - case when couple fee charges due dates is after charge-off date
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                                                                   | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR  | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 0.0  | 0.0        | 0.0  | 102.05      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "05 March 2024" due date and 5 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "15 April 2024" due date and 2 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 5.0  | 0.0       | 22.01 | 0.0   | 0.0        | 0.0  | 22.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 2.0  | 0.0       | 19.01 | 0.0   | 0.0        | 0.0  | 19.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 7.0  | 0.0       | 109.05  | 17.01 | 0.0        | 0.0  | 92.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
    When Admin sets the business date to "01 March 2024"
    And Admin does charge-off the loan on "01 March 2024"
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 0.0             | 83.57         | 0.49     | 0.0  | 0.0       | 84.06 | 0.0   | 0.0        | 0.0  | 84.06       |
      | 3  | 45   | 15 April 2024    |                  | 0.0             | 0.0           | 0.0      | 7.0  | 0.0       | 7.0   | 0.0   | 0.0        | 0.0  | 7.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.07     | 7.0  | 0.0       | 108.07  | 17.01 | 0.0        | 0.0  | 91.06       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 01 March 2024    | Charge-off       | 91.06  | 83.57     | 0.49     | 7.0  | 0.0       | 0.0          | false    | false    |

  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is enabled - case when fee and penalty charges due dates is after charge-off date
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                                                                   | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR  | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 0.0  | 0.0        | 0.0  | 102.05      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "05 March 2024" due date and 5 EUR transaction amount
    When Admin sets the business date to "29 February 2024"
    And Admin adds an NSF fee because of payment bounce with "29 February 2024" transaction date
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0  | 10.0      | 27.01 | 0.0   | 0.0        | 0.0  | 27.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 5.0  | 0.0       | 22.01 | 0.0   | 0.0        | 0.0  | 22.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 5.0  | 10.0      | 117.05  | 17.01 | 0.0        | 0.0  | 100.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
    When Admin sets the business date to "15 February 2024"
    And Admin does charge-off the loan on "15 February 2024"
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 14   | 15 February 2024 |                  | 0.0             | 83.57         | 0.24     | 0.0  | 0.0       | 83.81 | 0.0   | 0.0        | 0.0  | 83.81       |
      | 3  | 19   | 05 March 2024    |                  | 0.0             | 0.0           | 0.0      | 5.0  | 10.0      | 15.0  | 0.0   | 0.0        | 0.0  | 15.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 0.82     | 5.0  | 10.0      | 115.82  | 17.01 | 0.0        | 0.0  | 98.81       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 15 February 2024 | Charge-off       | 88.81  | 83.57     | 0.24     | 5.0  | 0.0       | 0.0          | false    | false    |

  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is enabled - case when fee and penalty charges due dates is after charge-off date, and one charge is waived after charge-off
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a fully customized loan with the following data:
      | LoanProduct                                                                                   | submitted on date | with Principal | ANNUAL interest rate % | interest type     | interest calculation period | amortization type  | loanTermFrequency | loanTermFrequencyType | repaymentEvery | repaymentFrequencyType | numberOfRepayments | graceOnPrincipalPayment | graceOnInterestPayment | interest free period | Payment strategy            |
      | LP2_ADV_PYMNT_INTEREST_DAILY_INTEREST_RECALCULATION_ACCELERATE_MATURITY_CHARGE_OFF_BEHAVIOUR  | 01 January 2024   | 100            | 7                      | DECLINING_BALANCE | DAILY                       | EQUAL_INSTALLMENTS | 6                 | MONTHS                | 1              | MONTHS                 | 6                  | 0                       | 0                      | 0                    | ADVANCED_PAYMENT_ALLOCATION |
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.52         | 0.49     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 3  | 31   | 01 April 2024    |           | 50.43           | 16.62         | 0.39     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 4  | 30   | 01 May 2024      |           | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |           | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0  | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 0.0  | 0.0       | 102.05  | 0.0  | 0.0        | 0.0  | 102.05      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.01 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "05 March 2024" due date and 5 EUR transaction amount
    When Admin sets the business date to "29 February 2024"
    And Admin adds an NSF fee because of payment bounce with "29 February 2024" transaction date
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.52         | 0.49     | 0.0  | 10.0      | 27.01 | 0.0   | 0.0        | 0.0  | 27.01       |
      | 3  | 31   | 01 April 2024    |                  | 50.43           | 16.62         | 0.39     | 5.0  | 0.0       | 22.01 | 0.0   | 0.0        | 0.0  | 22.01       |
      | 4  | 30   | 01 May 2024      |                  | 33.71           | 16.72         | 0.29     | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 5  | 31   | 01 June 2024     |                  | 16.9            | 16.81         | 0.2      | 0.0  | 0.0       | 17.01 | 0.0   | 0.0        | 0.0  | 17.01       |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.9          | 0.1      | 0.0  | 0.0       | 17.0  | 0.0   | 0.0        | 0.0  | 17.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.05     | 5.0  | 10.0      | 117.05  | 17.01 | 0.0        | 0.0  | 100.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
    When Admin sets the business date to "15 February 2024"
    And Admin does charge-off the loan on "15 February 2024"
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 14   | 15 February 2024 |                  | 0.0             | 83.57         | 0.24     | 0.0  | 0.0       | 83.81 | 0.0   | 0.0        | 0.0  | 83.81       |
      | 3  | 19   | 05 March 2024    |                  | 0.0             | 0.0           | 0.0      | 5.0  | 10.0      | 15.0  | 0.0   | 0.0        | 0.0  | 15.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 0.82     | 5.0  | 10.0      | 115.82  | 17.01 | 0.0        | 0.0  | 98.81       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 15 February 2024 | Charge-off       | 88.81  | 83.57     | 0.24     | 5.0  | 0.0       | 0.0          | false    | false    |
    And Admin waives due date charge
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.57           | 16.43         | 0.58     | 0.0  | 0.0       | 17.01 | 17.01 | 0.0        | 0.0  | 0.0         |
      | 2  | 14   | 15 February 2024 |                  | 0.0             | 83.57         | 0.24     | 0.0  | 0.0       | 83.81 | 0.0   | 0.0        | 0.0  | 83.81       |
      | 3  | 19   | 05 March 2024    |                  | 0.0             | 0.0           | 0.0      | 5.0  | 10.0      | 15.0  | 0.0   | 0.0        | 0.0  | 15.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 0.82     | 5.0  | 10.0      | 115.82  | 17.01 | 0.0        | 0.0  | 98.81       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type   | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement       | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment          | 17.01  | 16.43     | 0.58     | 0.0  | 0.0       | 83.57        | false    | false    |
      | 15 February 2024 | Charge-off         | 88.81  | 83.57     | 0.24     | 5.0  | 0.0       | 0.0          | false    | false    |
      | 15 February 2024 | Waive loan charges | 5.0    | 0.0       | 0.0      | 0.0  | 0.0       | 83.57        | false    | false    |

  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is disabled - case when one fee charge due date is before charge-off date
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a new accelerate maturity charge-off Loan without interest recalculation and with date: "1 January 2024"
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0	      |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0  | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04	      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "15 February 2024" due date and 5 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 5.0   | 0.0       | 22.0    | 0.0  | 0.0        | 0.0  | 22.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 5    | 0         | 107.04  | 17.0 | 0          | 0    | 90.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
    When Admin sets the business date to "1 March 2024"
    And Admin does charge-off the loan on "1 March 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 0.0             | 83.59         | 0.46     | 5.0  | 0.0       | 89.05 | 0.0  | 0.0        | 0.0  | 89.05       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.05     | 5.0  | 0.0       | 106.05  | 17.0  | 0.0        | 0.0  | 89.05       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 01 March 2024    | Charge-off       | 89.05  | 83.59     | 0.46     | 5.0  | 0.0       | 0.0          | false    | false    |

  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is disabled - case when couple fee charges due dates is before charge-off date
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a new accelerate maturity charge-off Loan without interest recalculation and with date: "1 January 2024"
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0	      |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0  | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04	      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "15 February 2024" due date and 5 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "20 February 2024" due date and 3 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 8.0   | 0.0       | 25.0    | 0.0  | 0.0        | 0.0  | 25.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 8    | 0         | 110.04  | 17.0 | 0          | 0    | 93.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
    When Admin sets the business date to "1 March 2024"
    And Admin does charge-off the loan on "1 March 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 0.0             | 83.59         | 0.46     | 8.0  | 0.0       | 92.05 | 0.0  | 0.0        | 0.0  | 92.05       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.05     | 8.0  | 0.0       | 109.05  | 17.0  | 0.0        | 0.0  | 92.05       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 01 March 2024    | Charge-off       | 92.05  | 83.59     | 0.46     | 8.0  | 0.0       | 0.0          | false    | false    |

  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is disabled - case when fee and penalty charges due dates is before charge-off date
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a new accelerate maturity charge-off Loan without interest recalculation and with date: "1 January 2024"
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0	      |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0  | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04	      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "15 February 2024" due date and 5 EUR transaction amount
    When Admin sets the business date to "15 February 2024"
    And Admin adds an NSF fee because of payment bounce with "15 February 2024" transaction date
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 5.0   | 10.0      | 32.0    | 0.0  | 0.0        | 0.0  | 32.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 5    | 10        | 117.04  | 17.0 | 0          | 0    | 100.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
    When Admin sets the business date to "1 March 2024"
    And Admin does charge-off the loan on "1 March 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 0.0             | 83.59         | 0.46     | 5.0  | 10.0      | 99.05 | 0.0  | 0.0        | 0.0  | 99.05       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.05     | 5.0  | 10.0      | 116.05  | 17.0  | 0.0        | 0.0  | 99.05       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 01 March 2024    | Charge-off       | 99.05  | 83.59     | 0.46     | 5.0  | 10.0      | 0.0          | false    | false    |

  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is disabled - case when fee and penalty charges due dates is before charge-off date, and one charge is waived after charge-off
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a new accelerate maturity charge-off Loan without interest recalculation and with date: "1 January 2024"
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0	      |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0  | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04	      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "15 February 2024" due date and 5 EUR transaction amount
    When Admin sets the business date to "15 February 2024"
    And Admin adds an NSF fee because of payment bounce with "15 February 2024" transaction date
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 5.0   | 10.0      | 32.0    | 0.0  | 0.0        | 0.0  | 32.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 5    | 10        | 117.04  | 17.0 | 0          | 0    | 100.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
    When Admin sets the business date to "1 March 2024"
    And Admin does charge-off the loan on "1 March 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 0.0             | 83.59         | 0.46     | 5.0  | 10.0      | 99.05 | 0.0  | 0.0        | 0.0  | 99.05       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.05     | 5.0  | 10.0      | 116.05  | 17.0  | 0.0        | 0.0  | 99.05       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 01 March 2024    | Charge-off       | 99.05  | 83.59     | 0.46     | 5.0  | 10.0      | 0.0          | false    | false    |
    And Admin waives due date charge
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 0.0             | 83.59         | 0.46     | 5.0  | 10.0      | 99.05 | 0.0  | 0.0        | 0.0  | 94.05       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.05     | 5.0  | 10.0      | 116.05  | 17.0  | 0.0        | 0.0  | 94.05       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type   | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement       | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment          | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 15 February 2024 | Waive loan charges | 5.0    | 0.0       | 0.0      | 0.0  | 0.0       | 83.59        | false    | false    |
      | 01 March 2024    | Charge-off         | 94.05  | 83.59     | 0.46     | 0.0  | 10.0      | 0.0          | false    | true     |

  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is disabled - case when one fee charge is added after the charge off date
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a new accelerate maturity charge-off Loan without interest recalculation and with date: "1 January 2024"
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0	      |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0  | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04	      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "05 March 2024" due date and 5 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 5.0   | 0.0       | 22.0    | 0.0  | 0.0        | 0.0  | 22.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 5    | 0         | 107.04  | 17.0 | 0          | 0    | 90.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
    When Admin sets the business date to "1 March 2024"
    And Admin does charge-off the loan on "1 March 2024"
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 0.0             | 83.59         | 0.46     | 0.0  | 0.0       | 84.05 | 0.0  | 0.0        | 0.0  | 84.05       |
      | 3  | 4    | 05 March 2024    |                  | 0.0             | 0.0           | 0.0      | 5.0  | 0.0       | 5.0   | 0.0  | 0.0        | 0.0  | 5.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.05     | 5.0  | 0.0       | 106.05  | 17.0  | 0.0        | 0.0  | 89.05       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 01 March 2024    | Charge-off       | 89.05  | 83.59     | 0.46     | 5.0  | 0.0       | 0.0          | false    | false    |

  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is disabled - case when couple fee charges due dates is after charge-off date
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a new accelerate maturity charge-off Loan without interest recalculation and with date: "1 January 2024"
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0	      |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0  | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04	      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "05 March 2024" due date and 5 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "15 April 2024" due date and 2 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 5.0   | 0.0       | 22.0    | 0.0  | 0.0        | 0.0  | 22.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 2.0   | 0.0       | 19.0    | 0.0  | 0.0        | 0.0  | 19.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 7    | 0         | 109.04  | 17.0 | 0          | 0    | 92.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
    When Admin sets the business date to "1 March 2024"
    And Admin does charge-off the loan on "1 March 2024"
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 0.0             | 83.59         | 0.46     | 0.0  | 0.0       | 84.05 | 0.0  | 0.0        | 0.0  | 84.05       |
      | 3  | 45   | 15 April 2024    |                  | 0.0             | 0.0           | 0.0      | 7.0  | 0.0       | 7.0   | 0.0  | 0.0        | 0.0  | 7.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.05     | 7.0  | 0.0       | 108.05  | 17.0  | 0.0        | 0.0  | 91.05       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 01 March 2024    | Charge-off       | 91.05  | 83.59     | 0.46     | 7.0  | 0.0       | 0.0          | false    | false    |

  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is disabled - case when fee and penalty charges due dates is after charge-off date
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a new accelerate maturity charge-off Loan without interest recalculation and with date: "1 January 2024"
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0	      |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0  | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04	      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "05 March 2024" due date and 5 EUR transaction amount
    When Admin sets the business date to "29 February 2024"
    And Admin adds an NSF fee because of payment bounce with "29 February 2024" transaction date
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0   | 10.0      | 27.0    | 0.0  | 0.0        | 0.0  | 27.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 5.0   | 0.0       | 22.0    | 0.0  | 0.0        | 0.0  | 22.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 5    | 10        | 117.04  | 17.0 | 0          | 0    | 100.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
    When Admin sets the business date to "15 February 2024"
    And Admin does charge-off the loan on "15 February 2024"
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0  | 0.0        | 0.0  | 0.0         |
      | 2  | 14   | 15 February 2024 |                  | 0.0             | 83.59         | 0.22     | 0.0  | 10.0      | 93.81 | 0.0   | 0.0        | 0.0  | 93.81       |
      | 3  | 19   | 05 March 2024    |                  | 0.0             | 0.0           | 0.0      | 5.0  | 0.0       | 5.0   | 0.0   | 0.0        | 0.0  | 5.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 0.81     | 5.0  | 10.0      | 115.81  | 17.0  | 0.0        | 0.0  | 98.81       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 15 February 2024 | Charge-off       | 98.81  | 83.59     | 0.22     | 5.0  | 10.0      | 0.0          | false    | false    |

  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is disabled - case when fee and penalty charges due dates is after charge-off date, and one charge is waived after charge-off
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a new accelerate maturity charge-off Loan without interest recalculation and with date: "1 January 2024"
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0	      |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0  | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04	      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    When Admin adds "LOAN_SNOOZE_FEE" due date charge with "05 March 2024" due date and 5 EUR transaction amount
    When Admin sets the business date to "29 February 2024"
    And Admin adds an NSF fee because of payment bounce with "29 February 2024" transaction date
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0   | 10.0      | 27.0    | 0.0  | 0.0        | 0.0  | 27.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 5.0   | 0.0       | 22.0    | 0.0  | 0.0        | 0.0  | 22.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 5    | 10        | 117.04  | 17.0 | 0          | 0    | 100.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
    When Admin sets the business date to "15 February 2024"
    And Admin does charge-off the loan on "15 February 2024"
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0  | 0.0        | 0.0  | 0.0         |
      | 2  | 14   | 15 February 2024 |                  | 0.0             | 83.59         | 0.22     | 0.0  | 10.0      | 93.81 | 0.0   | 0.0        | 0.0  | 93.81       |
      | 3  | 19   | 05 March 2024    |                  | 0.0             | 0.0           | 0.0      | 5.0  | 0.0       | 5.0   | 0.0   | 0.0        | 0.0  | 5.0         |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 0.81     | 5.0  | 10.0      | 115.81  | 17.0  | 0.0        | 0.0  | 98.81       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 15 February 2024 | Charge-off       | 98.81  | 83.59     | 0.22     | 5.0  | 10.0      | 0.0          | false    | false    |
    And Admin waives due date charge
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0  | 0.0        | 0.0  | 0.0         |
      | 2  | 14   | 15 February 2024 |                  | 0.0             | 83.59         | 0.22     | 0.0  | 0.0       | 83.81 | 0.0   | 0.0        | 0.0  | 83.81       |
      | 3  | 19   | 05 March 2024    |                  | 0.0             | 0.0           | 0.0      | 5.0  | 10.0      | 15.0  | 0.0   | 0.0        | 0.0  | 15.0        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 0.81     | 5.0  | 10.0      | 115.81  | 17.0  | 0.0        | 0.0  | 98.81       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type   | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement       | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment          | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 15 February 2024 | Waive loan charges | 5.0    | 0.0       | 0.0      | 0.0  | 0.0       | 83.59        | false    | false    |
      | 15 February 2024 | Charge-off         | 88.81  | 83.59     | 0.22     | 5.0  | 0.0       | 0.0          | false    | true     |

  @TestRailId:C3352 @AdvancedPaymentAllocation
  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is disabled - case when charge-off occurs on due date
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a new accelerate maturity charge-off Loan without interest recalculation and with date: "1 January 2024"
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0	      |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0  | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04	      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 17.0 | 0          | 0    | 85.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
    When Admin sets the business date to "1 March 2024"
    And Admin does charge-off the loan on "1 March 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 0.0             | 83.59         | 0.46     | 0.0  | 0.0       | 84.05 | 0.0  | 0.0        | 0.0  | 84.05       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.05     | 0.0  | 0.0       | 101.05  | 17.0  | 0.0        | 0.0  | 84.05       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 01 March 2024    | Charge-off       | 84.05  | 83.59     | 0.46     | 0.0  | 0.0       | 0.0          | false    | false    |
    When Admin sets the business date to "1 March 2024"
    And Admin does a charge-off undo the loan
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 17.0 | 0          | 0    | 85.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 01 March 2024    | Charge-off       | 84.05  | 83.59     | 0.46     | 0.0  | 0.0       | 0.0          | true     | false    |

  @TestRailId:C3353 @AdvancedPaymentAllocation
  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is disabled - case when charge-off occurs before installment date
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a new accelerate maturity charge-off Loan without interest recalculation and with date: "1 January 2024"
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0	      |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0  | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04	      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 17.0 | 0          | 0    | 85.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
    When Admin sets the business date to "29 February 2024"
    And Admin does charge-off the loan on "29 February 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 28   | 29 February 2024 |                  | 0.0             | 83.59         | 0.44     | 0.0  | 0.0       | 84.03 | 0.0  | 0.0        | 0.0  | 84.03       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.03     | 0.0  | 0.0       | 101.03  | 17.0  | 0.0        | 0.0  | 84.03       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 29 February 2024 | Charge-off       | 84.03  | 83.59     | 0.44     | 0.0  | 0.0       | 0.0          | false    | false    |

  @TestRailId:C3354 @AdvancedPaymentAllocation
  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is disabled - case when charge-off occurs in the middle of installment period
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a new accelerate maturity charge-off Loan without interest recalculation and with date: "1 January 2024"
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0	      |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0  | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04	      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 17.0 | 0          | 0    | 85.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
    When Admin sets the business date to "14 February 2024"
    And Admin does charge-off the loan on "14 February 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0      | 17.0  | 17.0  | 0.0        | 0.0  | 0.0         |
      | 2  | 13   | 14 February 2024 |                  | 0.0             | 83.59         | 0.21     | 0.0  | 0.0       | 83.8  | 0.0   | 0.0        | 0.0  | 83.8        |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100.0         | 0.8      | 0.0  | 0.0       | 100.8   | 17.0 | 0.0        | 0.0  | 83.8        |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 14 February 2024 | Charge-off       | 83.8   | 83.59     | 0.21     | 0.0  | 0.0       | 0.0          | false    | false    |

  @TestRailId:C3355 @AdvancedPaymentAllocation
  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is disabled - case when charge-off occurs after maturity date
    Given Global configuration "is-principal-compounding-disabled-for-overdue-loans" is enabled
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a new accelerate maturity charge-off Loan without interest recalculation and with date: "1 January 2024"
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0	      |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0  | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04	      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    When Admin sets the business date to "01 March 2024"
    And Customer makes "AUTOPAY" repayment on "01 March 2024" with 17.00 EUR transaction amount
    When Admin sets the business date to "01 April 2024"
    And Customer makes "AUTOPAY" repayment on "01 April 2024" with 17.00 EUR transaction amount
    When Admin sets the business date to "01 May 2024"
    And Customer makes "AUTOPAY" repayment on "01 May 2024" with 17.00 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    | 01 March 2024    | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 3  | 31   | 01 April 2024    | 01 April 2024    | 50.45           | 16.6          | 0.4      | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 4  | 30   | 01 May 2024      | 01 May 2024      | 33.74           | 16.71	      | 0.29     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0  | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.04     | 0.0  | 0.0       | 102.04  | 68.0  | 0.0        | 0.0  | 34.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 01 March 2024    | Repayment        | 17.0   | 16.54     | 0.46     | 0.0  | 0.0       | 67.05        | false    | false    |
      | 01 April 2024    | Repayment        | 17.0   | 16.6      | 0.4      | 0.0  | 0.0       | 50.45        | false    | false    |
      | 01 May 2024      | Repayment        | 17.0   | 16.71     | 0.29     | 0.0  | 0.0       | 33.74        | false    | false    |
    When Admin sets the business date to "15 July 2024"
    And Admin does charge-off the loan on "15 July 2024"
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    | 01 March 2024    | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 3  | 31   | 01 April 2024    | 01 April 2024    | 50.45           | 16.6          | 0.4      | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 4  | 30   | 01 May 2024      | 01 May 2024      | 33.74           | 16.71	      | 0.29     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0  | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 2.04     | 0.0  | 0.0       | 102.04  | 68.0  | 0.0        | 0.0  | 34.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 01 March 2024    | Repayment        | 17.0   | 16.54     | 0.46     | 0.0  | 0.0       | 67.05        | false    | false    |
      | 01 April 2024    | Repayment        | 17.0   | 16.6      | 0.4      | 0.0  | 0.0       | 50.45        | false    | false    |
      | 01 May 2024      | Repayment        | 17.0   | 16.71     | 0.29     | 0.0  | 0.0       | 33.74        | false    | false    |
      | 15 July 2024     | Charge-off       | 34.04  | 33.74     | 0.3      | 0.0  | 0.0       | 0.0          | false    | false    |
    Given Global configuration "is-principal-compounding-disabled-for-overdue-loans" is disabled

  @TestRailId:C3356 @AdvancedPaymentAllocation
  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is disabled - case when charge-off occurs after one installment is overdue
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a new accelerate maturity charge-off Loan without interest recalculation and with date: "1 January 2024"
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0	      |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0  | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04	      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 17.0 | 0          | 0    | 85.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
    When Admin sets the business date to "31 March 2024"
    And Admin does charge-off the loan on "31 March 2024"
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 30   | 31 March 2024    |                  | 0.0             | 67.05         | 0.39     | 0.0  | 0.0       | 67.44 | 0.0  | 0.0        | 0.0  | 67.44       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late   | Outstanding |
      | 100.0         | 1.44     | 0.0  | 0.0       | 101.44  | 17.0  | 0.0        | 0.0    | 84.44       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 31 March 2024    | Charge-off       | 84.44  | 83.59     | 0.85     | 0.0  | 0.0       | 0.0          | false    | false    |
    When Admin sets the business date to "02 April 2024"
    When Admin runs inline COB job for Loan
    Then Loan has 17.0 total overdue amount
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 30   | 31 March 2024    |                  | 0.0             | 67.05         | 0.39     | 0.0  | 0.0       | 67.44 | 0.0  | 0.0        | 0.0  | 67.44       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late   | Outstanding |
      | 100.0         | 1.44     | 0.0  | 0.0       | 101.44  | 17.0  | 0.0        | 0.0    | 84.44       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 31 March 2024    | Charge-off       | 84.44  | 83.59     | 0.85     | 0.0  | 0.0       | 0.0          | false    | false    |

  @TestRailId:C3359 @AdvancedPaymentAllocation
  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is disabled - case when repayment occurs after charge-off
    Given Global configuration "is-principal-compounding-disabled-for-overdue-loans" is enabled
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a new accelerate maturity charge-off Loan without interest recalculation and with date: "1 January 2024"
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0	      |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0  | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04	      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 17.0 | 0          | 0    | 85.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
    When Admin sets the business date to "29 February 2024"
    And Admin does charge-off the loan on "29 February 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 28   | 29 February 2024 |                  | 0.0             | 83.59         | 0.44     | 0.0  | 0.0       | 84.03 | 0.0  | 0.0        | 0.0  | 84.03       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.03     | 0.0  | 0.0       | 101.03  | 17.0  | 0.0        | 0.0  | 84.03       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 29 February 2024 | Charge-off       | 84.03  | 83.59     | 0.44     | 0.0  | 0.0       | 0.0          | false    | false    |
    When Admin sets the business date to "01 March 2024"
    And Customer makes "AUTOPAY" repayment on "01 March 2024" with 17.0 EUR transaction amount
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 28   | 29 February 2024 |                  | 0.0             | 83.59         | 0.44     | 0.0  | 0.0       | 84.03 | 17.0 | 0.0        | 17.0 | 67.03       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late  | Outstanding |
      | 100.0         | 1.03     | 0.0  | 0.0       | 101.03  | 34.0  | 0.0        | 17.0  | 67.03       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 29 February 2024 | Charge-off       | 84.03  | 83.59     | 0.44     | 0.0  | 0.0       | 0.0          | false    | false    |
      | 01 March 2024    | Repayment        | 17.0   | 16.56     | 0.44     | 0.0  | 0.0       | 67.03        | false    | false    |
    And Global configuration "is-principal-compounding-disabled-for-overdue-loans" is disabled

  @TestRailId:C3358 @AdvancedPaymentAllocation
  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is disabled - case when repayment reversal occurs after charge-off
    Given Global configuration "is-principal-compounding-disabled-for-overdue-loans" is enabled
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a new accelerate maturity charge-off Loan without interest recalculation and with date: "1 January 2024"
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0	      |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0  | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04	      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 17.0 | 0          | 0    | 85.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
    When Admin sets the business date to "29 February 2024"
    And Admin does charge-off the loan on "29 February 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 28   | 29 February 2024 |                  | 0.0             | 83.59         | 0.44     | 0.0  | 0.0       | 84.03 | 0.0  | 0.0        | 0.0  | 84.03       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late | Outstanding |
      | 100.0         | 1.03     | 0.0  | 0.0       | 101.03  | 17.0  | 0.0        | 0.0  | 84.03       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 29 February 2024 | Charge-off       | 84.03  | 83.59     | 0.44     | 0.0  | 0.0       | 0.0          | false    | false    |
    When Customer undo "1"th repayment on "01 February 2024"
    Then Loan Repayment schedule has 2 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late  | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |       |             |
      | 1  | 31   | 01 February 2024 |                  | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 0.0   | 0.0        | 0.0   | 17.0        |
      | 2  | 28   | 29 February 2024 |                  | 0.0             | 83.59         | 0.44     | 0.0  | 0.0       | 84.03 | 0.0   | 0.0        | 0.0   | 84.03       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late  | Outstanding |
      | 100.0         | 1.03     | 0.0  | 0.0       | 101.03  | 0.0   | 0.0        | 0.0   | 101.03      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | true     | false    |
      | 29 February 2024 | Charge-off       | 101.03 | 100.0     | 1.03     | 0.0  | 0.0       | 0.0          | false    | true     |
    And Global configuration "is-principal-compounding-disabled-for-overdue-loans" is disabled

  @TestRailId:C3357 @AdvancedPaymentAllocation
  Scenario: Verify accelerate maturity to charge-off date when interest recalculation is disabled - case when backdated repayment occurs after charge-off
    Given Global configuration "is-principal-compounding-disabled-for-overdue-loans" is enabled
    When Admin sets the business date to "01 January 2024"
    When Admin creates a client with random data
    When Admin creates a new accelerate maturity charge-off Loan without interest recalculation and with date: "1 January 2024"
    And Admin successfully approves the loan on "01 January 2024" with "100" amount and expected disbursement date on "01 January 2024"
    When Admin successfully disburse the loan on "01 January 2024" with "100" EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |           | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 |           | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 2  | 29   | 01 March 2024    |           | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |           | 50.45           | 16.6          | 0.4      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |           | 33.74           | 16.71	       | 0.29     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0 	      |
      | 5  | 31   | 01 June 2024     |           | 16.94           | 16.8          | 0.2      | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0	      |
      | 6  | 30   | 01 July 2024     |           | 0.0             | 16.94         | 0.1      | 0.0  | 0.0       | 17.04 | 0.0  | 0.0        | 0.0  | 17.04	      |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 0    | 0          | 0    | 102.04      |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
    When Admin sets the business date to "01 February 2024"
    And Customer makes "AUTOPAY" repayment on "01 February 2024" with 17.00 EUR transaction amount
    Then Loan Repayment schedule has 6 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees  | Penalties | Due     | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0   |           | 0.0     | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0   | 0.0       | 17.0    | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 31   | 01 April 2024    |                  | 50.45           | 16.6          | 0.4      | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0        |
      | 4  | 30   | 01 May 2024      |                  | 33.74           | 16.71	      | 0.29     | 0.0   | 0.0       | 17.0    | 0.0  | 0.0        | 0.0  | 17.0 	    |
      | 5  | 31   | 01 June 2024     |                  | 16.94           | 16.8          | 0.2      | 0.0   | 0.0       | 17.0	   | 0.0  | 0.0        | 0.0  | 17.0	    |
      | 6  | 30   | 01 July 2024     |                  | 0.0             | 16.94         | 0.1      | 0.0   | 0.0       | 17.04   | 0.0  | 0.0        | 0.0  | 17.04	    |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid | In advance | Late | Outstanding |
      | 100           | 2.04     | 0    | 0         | 102.04  | 17.0 | 0          | 0    | 85.04       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
    When Admin sets the business date to "31 March 2024"
    And Admin does charge-off the loan on "31 March 2024"
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid | In advance | Late | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0  |            |      |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0 | 0.0        | 0.0  | 0.0         |
      | 2  | 29   | 01 March 2024    |                  | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 0.0  | 0.0        | 0.0  | 17.0        |
      | 3  | 30   | 31 March 2024    |                  | 0.0             | 67.05         | 0.39     | 0.0  | 0.0       | 67.44 | 0.0  | 0.0        | 0.0  | 67.44       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late   | Outstanding |
      | 100.0         | 1.44     | 0.0  | 0.0       | 101.44  | 17.0  | 0.0        | 0.0    | 84.44       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 31 March 2024    | Charge-off       | 84.44  | 83.59     | 0.85     | 0.0  | 0.0       | 0.0          | false    | false    |
#    --- Backdated repayment ---
    And Customer makes "AUTOPAY" repayment on "01 March 2024" with 17.0 EUR transaction amount
    Then Loan Repayment schedule has 3 periods, with the following data for periods:
      | Nr | Days | Date             | Paid date        | Balance of loan | Principal due | Interest | Fees | Penalties | Due   | Paid  | In advance | Late  | Outstanding |
      |    |      | 01 January 2024  |                  | 100.0           |               |          | 0.0  |           | 0.0   | 0.0   |            |       |             |
      | 1  | 31   | 01 February 2024 | 01 February 2024 | 83.59           | 16.41         | 0.59     | 0.0  | 0.0       | 17.0  | 17.0  | 0.0        | 0.0   | 0.0         |
      | 2  | 29   | 01 March 2024    | 01 March 2024    | 67.05           | 16.54         | 0.46     | 0.0  | 0.0       | 17.0  | 17.0  | 0.0        | 0.0   | 0.0         |
      | 3  | 30   | 31 March 2024    |                  | 0.0             | 67.05         | 0.39     | 0.0  | 0.0       | 67.44 | 0.0   | 0.0        | 0.0   | 67.44       |
    Then Loan Repayment schedule has the following data in Total row:
      | Principal due | Interest | Fees | Penalties | Due     | Paid  | In advance | Late   | Outstanding |
      | 100.0         | 1.44     | 0.0  | 0.0       | 101.44  | 34.0  | 0.0        | 0.0    | 67.44       |
    Then Loan Transactions tab has the following data:
      | Transaction date | Transaction Type | Amount | Principal | Interest | Fees | Penalties | Loan Balance | Reverted | Replayed |
      | 01 January 2024  | Disbursement     | 100.0  | 0.0       | 0.0      | 0.0  | 0.0       | 100.0        | false    | false    |
      | 01 February 2024 | Repayment        | 17.0   | 16.41     | 0.59     | 0.0  | 0.0       | 83.59        | false    | false    |
      | 01 March 2024    | Repayment        | 17.0   | 16.54     | 0.46     | 0.0  | 0.0       | 67.05        | false    | false    |
      | 31 March 2024    | Charge-off       | 67.44  | 67.05     | 0.39     | 0.0  | 0.0       | 0.0          | false    | true     |
    And Global configuration "is-principal-compounding-disabled-for-overdue-loans" is disabled
