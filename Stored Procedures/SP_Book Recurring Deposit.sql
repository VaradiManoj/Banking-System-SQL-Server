/* ======================================================================
   BOOK_RECURRING_DEPOSIT
   ====================================================================== */

CREATE OR ALTER PROCEDURE BookRecurringDeposit
(
    @ACCOUNTID       INT,
    @DEPOSITAMOUNT   DECIMAL(18,2),
    @INTEREST        DECIMAL(5,2),
    @TENURE          INT,
    @CHANNEL         VARCHAR(20) = 'Branch'
)
AS
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        -- 1. Validate deposit amount

        IF @DEPOSITAMOUNT <= 0
        BEGIN
            THROW 50001,'Deposit amount must be greater than zero.',1;
        END;

        -- 2. Validate tenure

        IF @TENURE <= 0
        BEGIN
            THROW 50002,'Tenure must be greater than zero.',1;
        END;

        -- 3. Validate interest rate

        IF @INTEREST <= 0
        BEGIN
            THROW 50003,'Interest rate must be greater than zero.',1;
        END;

        -- 4. Validate channel

        IF @CHANNEL NOT IN
        (
            'Branch',
            'Internet Banking',
            'Mobile Banking'
        )
        BEGIN
            THROW 50004,'Invalid channel for Recurring Deposit.',1;
        END;

        -- 5. Validate account

        IF NOT EXISTS
        (
            SELECT 1
            FROM Accounts
            WHERE AccountID = @ACCOUNTID
              AND AccountStatus = 'Active'
        )
        BEGIN
            THROW 50005,'Account does not exist or is not active.',1;
        END;

        -- 6. Get account balance with locking

        DECLARE
            @OPENINGBALANCE   DECIMAL(18,2),
            @AVAILABLEBALANCE DECIMAL(18,2);

        SELECT
            @OPENINGBALANCE   = CurrentBalance,
            @AVAILABLEBALANCE = AvailableBalance
        FROM Accounts WITH (UPDLOCK, HOLDLOCK)
        WHERE AccountID = @ACCOUNTID;

        -- 7. Validate available balance
        --    First RD installment must be available

        IF @AVAILABLEBALANCE < @DEPOSITAMOUNT
        BEGIN
            THROW 50006,'Insufficient available balance for Recurring Deposit.',1;
        END;

        -- 8. Generate RD opening date

        DECLARE @STARTDATE DATE;
        SET @STARTDATE = CAST(SYSDATETIME() AS DATE);

        -- 9. Calculate RD maturity date

        DECLARE @ENDDATE DATE;
        SET @ENDDATE =DATEADD(MONTH,@TENURE,@STARTDATE);

        -- 10. Calculate maturity amount using function

        DECLARE @MATURITYAMOUNT DECIMAL(18,2);
        SET @MATURITYAMOUNT =
            dbo.Calculate_RD_Maturity
            (
                @DEPOSITAMOUNT,
                @INTEREST,
                @TENURE
            );

        -- 11. Update account balance
        --     Deduct the first monthly installment

        UPDATE Accounts
        SET
            CurrentBalance      = CurrentBalance - @DEPOSITAMOUNT,
            AvailableBalance     = AvailableBalance - @DEPOSITAMOUNT,
            LastTransactionDate  = SYSDATETIME(),
            ModifiedDate         = SYSDATETIME()
        WHERE AccountID = @ACCOUNTID;

        -- 12. Insert Recurring Deposit record

        INSERT INTO RecurringDeposits
        (
            AccountID,
            MonthlyInstallment,
            InterestRate,
            TenureMonths,
            OpeningDate,
            MaturityDate,
            MaturityAmount,
            Status
        )
        VALUES
        (
            @ACCOUNTID,
            @DEPOSITAMOUNT,
            @INTEREST,
            @TENURE,
            @STARTDATE,
            @ENDDATE,
            @MATURITYAMOUNT,
            'Active'
        );

        -- 13. Insert financial transaction

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
            'RDB-'
            + CONVERT(VARCHAR(8),CAST(SYSDATETIME() AS DATE),112)
            + '-'
            + RIGHT('000000'+ CAST(NEXT VALUE FOR TransactionReferenceSeq AS VARCHAR(6)),6),
			NULL,
            @ACCOUNTID,
            'Debit',
            'RD Deposit',
            @CHANNEL,
            @DEPOSITAMOUNT,
            0.00,
            0.00,
            @OPENINGBALANCE,
            @OPENINGBALANCE - @DEPOSITAMOUNT,
            NULL,
            NULL,
            NULL,
            'Success',
            'Recurring Deposit booked via ' + @CHANNEL,
            NULL,
            NULL,
            SYSDATETIME(),
            SYSDATETIME()
        );

        -- 14. Commit complete RD booking

        COMMIT TRANSACTION;

        -- 15. Return booking result

        SELECT
            @ACCOUNTID AS AccountID,
            @DEPOSITAMOUNT AS MonthlyInstallment,
            @INTEREST AS InterestRate,
            @TENURE AS TenureMonths,
            @STARTDATE AS OpeningDate,
            @ENDDATE AS MaturityDate,
            @MATURITYAMOUNT AS MaturityAmount,
            'Recurring Deposit booked successfully.' AS Message;

    END TRY
    BEGIN CATCH

        -- Rollback entire operation if any error occurs

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO


