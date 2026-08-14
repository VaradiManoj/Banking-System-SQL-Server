
/* ======================================================================
   GENERATE EMI SCHEDULE
   ====================================================================== */

CREATE OR ALTER PROCEDURE Generate_EMI_Schedule
(
    @LoanID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Validate loan

        IF NOT EXISTS
        (
            SELECT 1
            FROM Loans
            WHERE LoanID = @LoanID
        )
        BEGIN
            THROW 50401, 'Loan does not exist.', 1;
		END;

        -- 2. Get loan details

        DECLARE
            @LoanAmount DECIMAL(18,2),
            @InterestRate DECIMAL(5,2),
            @TenureMonths INT,
            @EMIAmount DECIMAL(18,2),
            @DisbursementDate DATE,
            @LoanStatus VARCHAR(15);

        SELECT
            @LoanAmount = LoanAmount,
            @InterestRate = InterestRate,
            @TenureMonths = LoanTenureMonths,
            @EMIAmount = EMIAmount,
            @DisbursementDate = DisbursementDate,
            @LoanStatus = LoanStatus
        FROM Loans WITH (UPDLOCK, HOLDLOCK)
        WHERE LoanID = @LoanID;

        -- 3. Loan must be disbursed

        IF @LoanStatus <> 'Disbursed'
        BEGIN
            THROW 50402,
                  'EMI schedule can be generated only for a disbursed loan.',1;
        END;

        -- 4. Loan must have a disbursement date

        IF @DisbursementDate IS NULL
        BEGIN
            THROW 50403,'Loan has not been disbursed.',1;
        END;

        -- 5. Prevent duplicate EMI schedule

        IF EXISTS
        (
            SELECT 1
            FROM EMICollections
            WHERE LoanID = @LoanID
        )
        BEGIN
            THROW 50404,'EMI schedule already exists for this loan.',1;
        END;

        -- 6. Calculate EMI

        SET @EMIAmount =
            dbo.Calculate_EMI
            (
                @LoanAmount,
                @InterestRate,
                @TenureMonths
            );

        -- 7. Store calculated EMI in Loans table

        UPDATE Loans
        SET
            EMIAmount = @EMIAmount
        WHERE LoanID = @LoanID;

        -- 8. Variables for amortization

        DECLARE
            @InstallmentNumber INT = 1,
            @OpeningPrincipal DECIMAL(18,2) = @LoanAmount,
            @InterestAmount DECIMAL(18,2),
            @PrincipalAmount DECIMAL(18,2),
            @ClosingPrincipal DECIMAL(18,2),
            @DueDate DATE;

        -- 9. Generate EMI schedule

        WHILE @InstallmentNumber <= @TenureMonths
        BEGIN

            SET @DueDate = DATEADD(MONTH, @InstallmentNumber, @DisbursementDate);

            -- Calculate monthly interest

            SET @InterestAmount =
                ROUND(@OpeningPrincipal* (@InterestRate / 100.0)/ 12,2);

            -- Calculate principal portion

            SET @PrincipalAmount = @EMIAmount - @InterestAmount;

            -- Prevent final installment from exceeding
            -- remaining principal

            IF @PrincipalAmount > @OpeningPrincipal
            BEGIN
                SET @PrincipalAmount = @OpeningPrincipal;

                SET @EMIAmount = @PrincipalAmount + @InterestAmount;
            END;

            -- Calculate remaining principal

            SET @ClosingPrincipal = @OpeningPrincipal - @PrincipalAmount;

            -- Avoid tiny rounding differences

            IF ABS(@ClosingPrincipal) < 0.01
            BEGIN
                SET @ClosingPrincipal = 0.00;
            END;

            -- Insert EMI schedule

            INSERT INTO EMICollections
            (
                LoanID,
                InstallmentNumber,
                DueDate,
                PaidDate,
                AmountDue,
                AmountPaid,
                PenaltyAmount,
                PaymentStatus,
                TransactionID,
                PrincipalAmount,
                InterestAmount,
                OutstandingPrincipal
            )
            VALUES
            (
                @LoanID,
                @InstallmentNumber,
                @DueDate,
                NULL,
                @EMIAmount,
                0.00,
                0.00,
                'Pending',
                NULL,
                @PrincipalAmount,
                @InterestAmount,
                @ClosingPrincipal
            );

            -- Move to next month's opening principal

            SET @OpeningPrincipal = @ClosingPrincipal;

            SET @InstallmentNumber = @InstallmentNumber + 1;

        END;

        -- 10. Keep loan outstanding amount synchronized

        UPDATE Loans
        SET
            OutstandingAmount = @LoanAmount
        WHERE LoanID = @LoanID;

        COMMIT TRANSACTION;

        -- 11. Display generated schedule

        SELECT
            EMIID,
            LoanID,
            InstallmentNumber,
            DueDate,
            AmountDue,
            PrincipalAmount,
            InterestAmount,
            OutstandingPrincipal,
            PaymentStatus
        FROM EMICollections
        WHERE LoanID = @LoanID
        ORDER BY InstallmentNumber;


    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;

END;
GO




/* ======================================================================
   COLLECT EMI
   ====================================================================== */

CREATE OR ALTER PROCEDURE Collect_EMI
(
    @EMIID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Get EMI details

        DECLARE
            @LoanID INT,
            @InstallmentNumber INT,
            @AmountDue DECIMAL(18,2),
            @PenaltyAmount DECIMAL(18,2),
            @PrincipalAmount DECIMAL(18,2),
            @AccountID INT;

        SELECT
            @LoanID = E.LoanID,
            @InstallmentNumber = E.InstallmentNumber,
            @AmountDue = E.AmountDue,
            @PenaltyAmount = E.PenaltyAmount,
            @PrincipalAmount = E.PrincipalAmount,
            @AccountID = L.AccountID
        FROM EMICollections AS E
        INNER JOIN Loans AS L
            ON E.LoanID = L.LoanID
        WHERE E.EMIID = @EMIID;

        -- 2. Validate EMI

        IF @LoanID IS NULL
        BEGIN
            THROW 50501, 'EMI does not exist.', 1;
        END;

        -- 3. Check whether EMI is already paid

        IF EXISTS
        (
            SELECT 1
            FROM EMICollections
            WHERE EMIID = @EMIID
              AND PaymentStatus = 'Paid'
        )
        BEGIN
            THROW 50502, 'This EMI has already been paid.', 1;
        END;

        -- 4. Get account balance with locking

        DECLARE
            @OpeningBalance DECIMAL(18,2),
            @AvailableBalance DECIMAL(18,2);

        SELECT
            @OpeningBalance = CurrentBalance,
            @AvailableBalance = AvailableBalance
        FROM Accounts WITH (UPDLOCK, HOLDLOCK)
        WHERE AccountID = @AccountID
          AND AccountStatus = 'Active';

        -- 5. Validate account

        IF @OpeningBalance IS NULL
        BEGIN
            THROW 50503, 'Account does not exist or is not active.', 1;
        END;

        -- 6. Validate sufficient balance

        IF @AvailableBalance < (@AmountDue + @PenaltyAmount)
        BEGIN
            THROW 50504, 'Insufficient balance for EMI payment.', 1;
        END;

        -- 7. Debit customer account

        UPDATE Accounts
        SET
            CurrentBalance = CurrentBalance - (@AmountDue + @PenaltyAmount),
            AvailableBalance = AvailableBalance - (@AmountDue + @PenaltyAmount),
            LastTransactionDate = SYSDATETIME(),
            ModifiedDate = SYSDATETIME()
        WHERE AccountID = @AccountID;

        -- 8. Create financial transaction

        INSERT INTO Transactions
        (
            TransactionReferenceNumber,
            TransferReferenceNumber,
            AccountID,
            TransactionType,
            TransactionCategory,
            PaymentChannel,
            Amount,
            Charges,
            TaxAmount,
            OpeningBalance,
            ClosingBalance,
            CounterpartyAccountNumber,
            CounterpartyName,
            CounterpartyBank,
            TransactionStatus,
            Remarks,
            InitiatedBy,
            ApprovedBy,
            TransactionDate,
            CreatedDate
        )
        VALUES
        (
            'EMI-'
            + CONVERT(VARCHAR(8),CAST(SYSDATETIME() AS DATE),112)
            + '-'
            + RIGHT('000000'+ CAST(NEXT VALUE FOR TransactionReferenceSeq AS VARCHAR(6)),6),
            NULL,
            @AccountID,
            'Debit',
            'Loan EMI',
            'Auto Debit',
            @AmountDue + @PenaltyAmount,
            0.00,
            0.00,
            @OpeningBalance,
            @OpeningBalance - (@AmountDue + @PenaltyAmount),
            NULL,
            NULL,
            NULL,
            'Success',
            'EMI payment for LoanID '
            + CAST(@LoanID AS VARCHAR(20))
            + ', Installment '
            + CAST(@InstallmentNumber AS VARCHAR(10)),
            NULL,
            NULL,
            SYSDATETIME(),
            SYSDATETIME()
        );

        -- 9. Capture generated TransactionID

        DECLARE @TransactionID INT;
        SET @TransactionID = SCOPE_IDENTITY();

        -- 10. Mark EMI as Paid

        UPDATE EMICollections
        SET
            PaidDate = CAST(SYSDATETIME() AS DATE),
            AmountPaid = @AmountDue + @PenaltyAmount,
            PaymentStatus = 'Paid',
            TransactionID = @TransactionID
        WHERE EMIID = @EMIID;

        -- 11. Reduce loan outstanding amount

        UPDATE Loans
        SET
            OutstandingAmount =
                CASE
                    WHEN OutstandingAmount >= @PrincipalAmount
                    THEN OutstandingAmount - @PrincipalAmount
                    ELSE 0.00
                END
        WHERE LoanID = @LoanID;

        -- 12. Commit complete EMI payment

        COMMIT TRANSACTION;

        -- 13. Return payment result

        SELECT
            @EMIID AS EMIID,
            @LoanID AS LoanID,
            @InstallmentNumber AS InstallmentNumber,
            @AmountDue + @PenaltyAmount AS AmountPaid,
            @TransactionID AS TransactionID,
            'EMI payment successful.' AS Message;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;

END;
GO


