# AtlasPay — Oracle PL/SQL Banking & Payment Processing Engine

## 1. Project Overview

AtlasPay is a database-first banking and payment processing system built with Oracle Database and PL/SQL.

The system manages customer accounts, processes internal transfers and merchant payments, maintains a financial ledger, detects suspicious activity, reconciles payment records, and executes scheduled financial operations.

The primary objective is to build a realistic database system while developing a deep understanding of Oracle PL/SQL, from core language features to advanced transaction management, bulk processing, security, and performance tuning.

This is an educational portfolio project. It must not be used to process real money or store real customer financial data.

## 2. Project Goals

The project should demonstrate the ability to:

- Design and maintain a relational database for a financial domain.
- Build modular business logic using PL/SQL packages, procedures, and functions.
- Preserve financial correctness across successful operations, failures, retries, and concurrent requests.
- Use advanced PL/SQL language features to solve realistic business problems.
- Process and reconcile large volumes of transaction data.
- Diagnose database errors and investigate performance problems.
- Apply database security principles and least-privilege access.
- Test database behavior systematically and document design decisions.
- Produce a reproducible, well-documented GitHub portfolio project.

## 3. Business Context

AtlasPay provides financial services to individuals and merchants. Customers can hold accounts, transfer money, and pay merchants. The institution must keep accurate records of all financial movements and produce reliable operational and financial reports.

The system must handle duplicate requests, invalid operations, concurrent activity, failed processing, suspicious transactions, and discrepancies between internal records and external settlement data.

## 4. Functional Requirements

### 4.1 Customer and Account Management

The system must support:

- Customer registration and customer status management.
- Opening and managing financial accounts.
- Current and savings account types.
- Account activation, suspension, and closure subject to business rules.
- Account ownership validation.
- Support for account currencies.
- Balance and transaction-history inquiries.
- Configurable rules for account operations.

### 4.2 Payment Processing

The system must support:

- Transfers between eligible internal accounts.
- Merchant payment requests.
- Payment validation and authorization.
- Configurable transaction limits and fees.
- Payment lifecycle tracking, including pending, completed, rejected, and failed states where applicable.
- Unique request identifiers to prevent duplicate processing.
- Safe retries of previously submitted requests.
- Payment cancellation or reversal according to defined rules.
- A traceable relationship between payment requests and their financial effects.

### 4.3 Financial Ledger

The system must maintain a reliable record of financial movements.

Requirements:

- Every posted financial transaction must have corresponding debit and credit entries.
- The total debits and credits for a posted transaction must balance within the applicable currency.
- Posted ledger records must not be silently modified or deleted.
- Corrections must be represented through controlled reversal or adjustment entries.
- Each ledger entry must reference the relevant account and financial transaction.
- Account balances must remain consistent with the ledger under the system's defined rules.
- Financial history must be queryable by account, transaction, date, and reference.

### 4.4 Account Holds and Available Funds

The system must support:

- Placing a hold on funds for an eligible payment.
- Releasing or consuming a hold.
- Expiring eligible holds.
- Distinguishing an account's recorded balance from its available funds.
- Preventing a payment from using funds already reserved for another operation.
- Handling concurrent operations without overspending.

### 4.5 Fees and Business Rules

The system must support:

- Configurable transfer and merchant payment fees.
- Rules based on payment type, amount, account type, or other defined criteria.
- Effective dates for fee rules.
- Transfer and account limits.
- Consistent handling of rounding and monetary precision.
- Versioned or otherwise traceable business configuration changes.

### 4.6 Risk Monitoring

The system must support configurable rules that can flag potentially suspicious activity, such as:

- Transactions exceeding a defined threshold.
- Repeated transactions within a short period.
- Unusual transaction patterns according to configured criteria.
- Repeated rejected payment attempts.
- Transactions that violate configured limits.

The system must record alerts, their reasons, relevant payment references, review status, and any subsequent resolution.

Risk flags must be distinguishable from confirmed fraud. This project does not need to implement a machine-learning fraud detection model.

### 4.7 Reconciliation

The system must compare internal payment and ledger records with externally supplied settlement records.

It must identify and report:

- Matching records.
- Internal transactions missing from the external data.
- External records missing from internal data.
- Duplicate external records.
- Amount or currency mismatches.
- Status or reference mismatches.
- Records requiring manual investigation.

Each reconciliation run must have a traceable status and summary. Discrepancies must be retained with enough information to investigate and resolve them without rewriting historical financial facts.

### 4.8 Batch Processing and Scheduled Operations

The system must support scheduled or manually initiated operations, including:

- Reconciliation runs.
- Settlement processing.
- Statement generation.
- Expiry of eligible account holds.
- Periodic fee or interest calculations where applicable.
- Large-scale transaction and reporting jobs.

Batch operations must record their execution status, start and end times, processing counts, failures, and relevant diagnostics.

Failed batch work must be recoverable under a defined retry or restart policy, without duplicating already completed financial effects.

### 4.9 Reporting

The system must provide reports for:

- Account transaction histories.
- Payment status and failure reasons.
- Daily transaction totals.
- Account activity over a selected period.
- Fees collected.
- Reconciliation summaries and discrepancies.
- Risk alerts and their review status.
- Batch execution results.
- Operational and financial exceptions.

Reports must support relevant filters, sorting, aggregation, and date ranges.

### 4.10 Audit and Diagnostics

The system must retain an audit trail for important actions and state changes.

Audit information should include, where relevant:

- Actor or database principal.
- Operation and affected entity.
- Timestamp.
- Request or correlation identifier.
- Previous and new state when appropriate.
- Outcome and failure information.

Diagnostic records must help investigate errors without exposing unnecessary sensitive information.

### 4.11 Database Security

The system must distinguish between permitted operations and direct access to sensitive data.

Requirements:

- Separate database users or roles for administrative, application, and read-only responsibilities.
- Least-privilege access to financial tables and program units.
- Controlled access to payment posting and ledger operations.
- Protection against SQL injection in dynamic query features.
- Restrictions on unauthorized modification of posted ledger entries.
- Documented assumptions about authentication and authorization.

## 5. PL/SQL Learning Objectives

The project should provide meaningful opportunities to study and demonstrate the following features.

### Language Fundamentals and Program Structure

- Anonymous PL/SQL blocks.
- Variables, constants, scope, and nested blocks.
- `%TYPE` and `%ROWTYPE`.
- Conditional statements and loops.
- Records and user-defined types.
- Procedures and functions.
- `IN`, `OUT`, and `IN OUT` parameters.
- Package specifications and package bodies.
- Public and private package members.
- Overloaded subprograms.
- Package state and initialization behavior.

### Cursors and Collections

- Implicit and explicit cursors.
- Cursor attributes.
- Parameterized cursors.
- Cursor `FOR` loops.
- Strong and weak `REF CURSOR` types.
- Associative arrays, nested tables, and VARRAYs.
- Collection methods.
- `BULK COLLECT`.
- `FORALL`.
- `SAVE EXCEPTIONS`.
- Bounded batch processing with `LIMIT`.

### Error Handling

- Predefined exceptions.
- User-defined exceptions.
- `RAISE` and `RAISE_APPLICATION_ERROR`.
- `PRAGMA EXCEPTION_INIT`.
- Exception propagation.
- `SQLCODE` and `SQLERRM`.
- Error backtraces and diagnostics.
- Bulk DML error handling.
- Clear separation between business errors and unexpected technical failures.

### Transactions and Concurrency

- `COMMIT`, `ROLLBACK`, and `SAVEPOINT`.
- Transaction boundaries and ownership.
- `SELECT FOR UPDATE`.
- Lock waiting policies such as `NOWAIT` and `WAIT`.
- `SKIP LOCKED` for eligible work-queue patterns.
- Oracle read consistency and isolation behavior.
- Deadlocks and lock ordering.
- Idempotency and uniqueness guarantees.
- Safe retry behavior.
- Atomic financial posting and rollback.

### Database Programmability

- Row-level and statement-level triggers.
- `BEFORE` and `AFTER` triggers.
- Compound triggers.
- Trigger restrictions and mutating-table scenarios.
- Native dynamic SQL with `EXECUTE IMMEDIATE`.
- Bind variables and safe dynamic query construction.
- `DBMS_SQL` where appropriate.
- Views and materialized views where justified.
- Table functions and pipelined functions.
- SQL-visible object types as an optional extension.

### Automation and Advanced Processing

- `DBMS_SCHEDULER`.
- Batch status tracking and restartability.
- Bulk data processing.
- `DBMS_APPLICATION_INFO` and database instrumentation.
- Execution-plan inspection and SQL performance analysis.
- Profiling tools available in the chosen Oracle environment.
- Optional parallel chunk processing with `DBMS_PARALLEL_EXECUTE`.

### Security and Advanced Language Topics

- Definer's rights and invoker's rights.
- Package execution privileges.
- Least-privilege database access.
- SQL injection prevention.
- PL/SQL compiler warnings.
- Conditional compilation.
- Result caching where appropriate.
- Autonomous transactions as a separately evaluated advanced topic.
- Oracle-version-specific advanced features, documented separately.

Not every feature must be used in the core payment flow. Features that do not have a sound production use case may be demonstrated in isolated learning exercises within the repository.

## 6. Non-Functional Requirements

### Financial Correctness

- No completed transfer may leave only one side of its required ledger posting.
- Posted ledger transactions must satisfy the balancing invariant.
- Repeated requests must not duplicate financial effects.
- Failed operations must not leave unintended partial changes.
- Reversals must preserve the original transaction history.

### Concurrency

- Concurrent withdrawals must not spend the same available funds.
- Conflicting account operations must follow a documented locking strategy.
- Concurrent duplicate requests must not create duplicate payments.
- Deadlock and lock-timeout behavior must be understood and tested.

### Recoverability

- Failed batch operations must have a documented recovery strategy.
- Retried work must not duplicate completed financial effects.
- Failures must be observable through status records and diagnostics.

### Performance

- Large data volumes must be tested with reproducible datasets.
- Row-by-row processing must be compared with bulk processing where applicable.
- Query plans and indexing decisions must be documented.
- Performance claims must be supported by measured results and test conditions.

### Maintainability

- Business logic must be organized into coherent packages.
- Public package interfaces must be documented.
- Financial rules and transaction boundaries must be explicit.
- Database objects must be installable through version-controlled scripts.
- Tests and examples must be reproducible by another developer.

## 7. Constraints and Design Hints

These are project-level constraints, not step-by-step implementation instructions.

- Oracle Database and PL/SQL must remain the core of the project.
- Financial amounts must use exact decimal numeric types rather than binary floating-point types.
- Currency must be explicit wherever financial amounts are stored or compared.
- Ledger history must be append-oriented; corrections should use reversal or adjustment entries.
- Cross-row ledger balancing requires more than a simple row-level constraint.
- Payment posting must have a clearly defined transaction boundary.
- Reusable business procedures should not commit work unexpectedly on behalf of their callers.
- External payment-provider interactions cannot be made atomic with a local Oracle transaction alone.
- Dynamic SQL must use bind variables for values and controlled allowlists for dynamic identifiers.
- Triggers should not hide major business workflows.
- Autonomous transactions must not undermine the correctness of financial operations.
- Every advanced feature should have a clear use case, a test, or a documented learning experiment.
- Avoid adding microservices, message brokers, or a frontend before the database engine is reliable.

## 8. Testing Requirements

The project must include automated tests for successful operations, invalid inputs, failure scenarios, and boundary conditions.

At minimum, tests must cover:

- Successful internal transfers.
- Insufficient funds.
- Closed or suspended accounts.
- Invalid amounts and currencies.
- Duplicate payment requests.
- Duplicate reversal requests.
- Ledger balancing.
- Failure during payment posting.
- Concurrent withdrawals.
- Concurrent requests using the same idempotency key.
- Reconciliation mismatches and duplicate records.
- Batch failure and restart.
- Unauthorized direct modification of financial records.
- Dynamic SQL input validation.
- Large-volume batch correctness and performance.

Concurrency tests must use multiple database sessions. Unit tests alone are insufficient to prove concurrent behavior.

The project should use a PL/SQL testing framework such as utPLSQL where compatible with the chosen Oracle environment.

## 9. Portfolio Deliverables

The final repository should contain:

- A clear project README.
- Business requirements and assumptions.
- An entity-relationship diagram.
- A database architecture diagram.
- Documented financial invariants and transaction boundaries.
- Version-controlled database schema and program-unit scripts.
- Installation, seed-data, verification, and reset scripts.
- PL/SQL package specifications and bodies.
- Automated unit and integration tests.
- Multi-session concurrency test scenarios.
- Failure and recovery demonstrations.
- Reproducible performance benchmarks.
- Security and privilege documentation.
- Example calls to the public PL/SQL APIs.
- A feature coverage matrix linking learning objectives to project artifacts.
- Known limitations and future improvements.

An optional Spring Boot API or Angular frontend may be added after the database functionality is complete. The database project must remain useful and testable independently of any frontend.

## 10. Definition of Done

The project is considered complete when:

1. All core business requirements are implemented and documented.
2. Financial invariants are enforced and tested.
3. Transfers, retries, and reversals behave correctly under failure and concurrency.
4. The main PL/SQL learning objectives are demonstrated in working code.
5. Reconciliation can detect and report defined discrepancy types.
6. Batch operations can be monitored and safely resumed according to their documented policy.
7. Security privileges prevent unauthorized financial-table changes.
8. Automated tests run reproducibly in the documented Oracle environment.
9. Performance experiments include measured results rather than unsupported claims.
10. A developer can understand the architecture, install the database, run the tests, and reproduce the main demonstrations using the repository documentation.

## 11. Official References

- Oracle Database PL/SQL Language Reference: https://docs.oracle.com/en/database/oracle/oracle-database/19/lnpls/
- Oracle Database SQL Language Reference: https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/
- utPLSQL: https://utplsql.org/
