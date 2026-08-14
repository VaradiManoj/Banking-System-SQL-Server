/* ======================================================================
    BOOK_FIXED_DEPOSIT
   ====================================================================== */

CREATE OR ALTER PROCEDURE BookFixedDeposit
(
    @AccountId       INT,
    @DepositAmount   DECIMAL(18,2),
    @InterestRate    DECIMAL(5,2),
    @TenureMonths    INT,
    @NomineeID       INT = NULL,
    @Channel         VARCHAR(20) = 'Branch'
)
AS
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        -- 1. Validate deposit amount

        IF @DepositAmount <= 0
        BEGIN
            THROW 50001, 'FD deposit amount must be greater than zero.',1;
        END;

        -- 2. Validate interest rate

        IF @InterestRate <= 0
        BEGIN
            THROW 50002,'Interest rate must be greater than zero.',1;
        END;

        -- 3. Validate tenure

        IF @TenureMonths <= 0
        BEGIN
            THROW 50003,'Tenure must be greater than zero months.',1;
        END;

        -- 4. Validate channel

        IF @Channel NOT IN
        (
            'Branch',
            'Internet Banking',
            'Mobile Banking'
        )
        BEGIN
            THROW 50004,'Invalid channel for Fixed Deposit booking.',1;
        END;

        -- 5. Validate account

        IF NOT EXISTS
        (
            SELECT 1
            FROM Accounts
            WHERE AccountID = @AccountId
              AND AccountStatus = 'Active'
        )
        BEGIN
            THROW 50005,'Account does not exist or is not active.',1;
        END;

        -- 6. Get account balance with locking

        DECLARE
            @OpeningBalance   DECIMAL(18,2),
            @AvailableBalance DECIMAL(18,2);

        SELECT
            @OpeningBalance   = CurrentBalance,
            @AvailableBalance = AvailableBalance
        FROM Accounts WITH (UPDLOCK, HOLDLOCK)
        WHERE AccountID = @AccountId;


        -- 7. FD must be funded using available own balance
        --    Overdraft is NOT considered for FD booking

        IF @AvailableBalance < @DepositAmount
        BEGIN
            THROW 50006,'Insufficient available balance to book this Fixed Deposit.',1;
        END;

        -- 8. Validate nominee ownership

        IF @NomineeID IS NOT NULL
        BEGIN

            IF NOT EXISTS
            (
                SELECT 1
                FROM Nominees N
                INNER JOIN Accounts A
                    ON A.CustomerID = N.CustomerID
                WHERE N.NomineeID = @NomineeID
                  AND A.AccountID = @AccountId
            )
            BEGIN
                THROW 50007,'Nominee does not belong to this account holder.',1;
            END;

        END;

        -- 9. Generate FD dates

        DECLARE @StartDate DATE;
        SET @StartDate = CAST(SYSDATETIME() AS DATE);

        DECLARE @MaturityDate DATE;
        SET @MaturityDate = DATEADD(MONTH,@TenureMonths,@StartDate);

        -- 10. Calculate maturity amount using function

        DECLARE @MaturityAmount DECIMAL(18,2);

        SET @MaturityAmount =
            dbo.Calculate_FD_Maturity
            (
                @DepositAmount,
                @InterestRate,
                @TenureMonths
            );

        -- 11. Generate FD number

        DECLARE @FDNumber VARCHAR(20);

        SET @FDNumber ='FD-'+ CONVERT(VARCHAR(8),CAST(SYSDATETIME() AS DATE),112)
						+ '-'
						+ RIGHT('000000'+ CAST(NEXT VALUE FOR TransactionReferenceSeq AS VARCHAR(6)),6);

        -- 12. Debit account

        UPDATE Accounts
        SET
        
			CurrentBalance      = CurrentBalance - @DepositAmount,
            AvailableBalance    = AvailableBalance - @DepositAmount,
            LastTransactionDate = SYSDATETIME(),
            ModifiedDate        = SYSDATETIME()
        WHERE AccountID = @AccountId;

        -- 13. Insert Fixed Deposit
        INSERT INTO FixedDeposits
        (
            AccountID,
            FDNumber,
            DepositAmount,
            InterestRate,
            TenureMonths,
            StartDate,
            MaturityDate,
            MaturityAmount,
            NomineeID,
            Status
        )
        VALUES
        (
            @AccountId,
            @FDNumber,
            @DepositAmount,
            @InterestRate,
            @TenureMonths,
            @StartDate,
            @MaturityDate,
            @MaturityAmount,
            @NomineeID,
            'Active'
        );

        -- 14. Insert financial transaction

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
            'FDB-'
            + CONVERT
            (VARCHAR(8),CAST(SYSDATETIME() AS DATE),112)
            + '-'
            + RIGHT('000000'+ CAST(NEXT VALUE FOR TransactionReferenceSeq AS VARCHAR(6)),6),
            NULL,
            @AccountId,
            'Debit',
            'FD Booking',
            @Channel,
            @DepositAmount,
            0.00,
            0.00,
            @OpeningBalance,
            @OpeningBalance - @DepositAmount,
            NULL,
            NULL,
            NULL,
            'Success',
            'Fixed Deposit '
            + @FDNumber
            + ' booked via '
            + @Channel,
            NULL,
            NULL,
            SYSDATETIME(),
            SYSDATETIME()
        );

        -- 15. Commit complete FD booking

        COMMIT TRANSACTION;

        -- 16. Return result

        SELECT
            @FDNumber AS FDNumber,
            @AccountId AS AccountID,
            @DepositAmount AS DepositAmount,
            @InterestRate AS InterestRate,
            @TenureMonths AS TenureMonths,
            @StartDate AS StartDate,
            @MaturityDate AS MaturityDate,
            @MaturityAmount AS MaturityAmount,
            'Fixed Deposit booked successfully.' AS Message;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO


