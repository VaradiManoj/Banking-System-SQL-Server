/* ======================================================================
   1. DEPOSIT_MONEY
   Covers: Cash Deposit, ATM Deposit, Cheque Deposit, Interest Credit
   ATM transactions are additionally recorded in ATMTransactions
   ====================================================================== */

CREATE OR ALTER PROCEDURE Deposit_Money
(
    @AccountId       INT,
    @DepositAmount   DECIMAL(18,2),
    @Category        VARCHAR(30),     --(Cash Deposit | ATM Deposit | Cheque Deposit | Interest Credit)
    @Channel         VARCHAR(20),     --(Branch | ATM | Internet Banking | Mobile Banking | System)
    @ATMID           INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Validate deposit amount
        IF @DepositAmount <= 0
        BEGIN
            THROW 50001, 'Deposit amount must be greater than zero.', 1;
        END;


        -- 2. Validate deposit category
        IF @Category NOT IN
        (
            'Cash Deposit',
            'ATM Deposit',
            'Cheque Deposit',
            'Interest Credit'
        )
        BEGIN
            THROW 50003, 'Invalid deposit category.', 1;
        END;


        -- 3. Validate account
        IF NOT EXISTS
        (
            SELECT 1
            FROM Accounts
            WHERE AccountID = @AccountId
              AND AccountStatus = 'Active'
        )
        BEGIN
            THROW 50002, 'Account does not exist or is not active.', 1;
        END;


        -- 4. Validate Category + Payment Channel
        IF
        (
            (@Category = 'Cash Deposit' AND @Channel NOT IN ('Branch', 'ATM'))
			OR
			(@Category = 'ATM Deposit' AND @Channel <> 'ATM')
			OR
			(@Category = 'Cheque Deposit' AND @Channel NOT IN ('Branch', 'ATM', 'Internet Banking', 'Mobile Banking'))
			OR
			(@Category = 'Interest Credit' AND @Channel <> 'System')
         )
        BEGIN
            THROW 50004, 'Invalid Category and Payment Channel combination.', 1;
        END;


        -- 5. Validate ATM details when transaction is through ATM
        IF @Channel = 'ATM'
        BEGIN
            IF @ATMID IS NULL
            BEGIN
                THROW 50005, 'ATMID is required for ATM transactions.', 1;
            END;


            IF NOT EXISTS
            (
                SELECT 1
                FROM ATM
                WHERE ATMID = @ATMID
                  AND Status = 'Active'
            )
            BEGIN
                THROW 50006, 'ATM does not exist or is not active.', 1;
            END;
        END;


        -- 6. ATMID must be NULL for non-ATM transactions
        IF @Channel <> 'ATM' 
		   AND 
		   @ATMID IS NOT NULL
        BEGIN
            THROW 50007, 'ATMID must be NULL for non-ATM transactions.', 1;
        END;


        -- 7. Get account opening balance
        DECLARE @OpeningBalance DECIMAL(18,2);

        SELECT @OpeningBalance = CurrentBalance
        FROM Accounts
        WHERE AccountID = @AccountId;


        -- 8. If ATM transaction, validate ATM cash capacity
        DECLARE @ATMOpeningBalance DECIMAL(18,2);
        DECLARE @ATMClosingBalance DECIMAL(18,2);
        DECLARE @CashCapacity DECIMAL(18,2);

        IF @Channel = 'ATM'
        BEGIN
            SELECT
                @ATMOpeningBalance = CashBalance,
                @CashCapacity = CashCapacity
            FROM ATM
            WHERE ATMID = @ATMID;


            IF @ATMOpeningBalance + @DepositAmount > @CashCapacity
            BEGIN
                THROW 50008, 'ATM cash capacity exceeded.', 1;
            END;
        END;

        -- 9. Update customer account balance
        UPDATE Accounts
        SET
            CurrentBalance      = CurrentBalance + @DepositAmount,
            AvailableBalance    = AvailableBalance + @DepositAmount,
            LastTransactionDate = SYSDATETIME(),
            ModifiedDate        = SYSDATETIME()
        WHERE AccountID = @AccountId;

        -- 10. Insert financial transaction
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
            'DEP-'
            + CONVERT(VARCHAR(8), CAST(SYSDATETIME() AS DATE), 112)
            + '-'
            + RIGHT('000000'+ CAST(NEXT VALUE FOR TransactionReferenceSeq AS VARCHAR(6)),6),
            NULL,
            @AccountId,
            'Credit',
            @Category,
            @Channel,
            @DepositAmount,
            0.00,
            0.00,
            @OpeningBalance,
            @OpeningBalance + @DepositAmount,
            NULL,
            NULL,
            NULL,
            'Success',
            'Deposit made via ' + @Channel,
            NULL,
            NULL,
            SYSDATETIME(),
            SYSDATETIME()
        );

        -- 11. Capture generated TransactionID
        DECLARE @TransactionID INT;

        SET @TransactionID = SCOPE_IDENTITY();

        -- 12. ATM-specific processing
        IF @Channel = 'ATM'
        BEGIN

            -- 12.1 Update physical ATM cash
            UPDATE ATM
            SET
                CashBalance = CashBalance + @DepositAmount,
                LastCashLoadDate = SYSDATETIME()
            WHERE ATMID = @ATMID;

            -- 12.2 Get remaining ATM cash
            SELECT @ATMClosingBalance = CashBalance
            FROM ATM
            WHERE ATMID = @ATMID;

            -- 12.3 Record ATM transaction
            INSERT INTO ATMTransactions
            (
                ATMID,
                AccountID,
                TransactionID,
                TransactionType,
                Amount,
                RemainingATMBalance,
                TransactionDate
            )
            VALUES
            (
                @ATMID,
                @AccountId,
                @TransactionID,
                'Deposit',
                @DepositAmount,
                @ATMClosingBalance,
                SYSDATETIME()
            );

        END;

        -- 13. Commit complete operation
        COMMIT TRANSACTION;

        -- 14. Return result
        SELECT
            @AccountId AS AccountID,
            @OpeningBalance AS OpeningBalance,
            @DepositAmount AS DepositAmount,
            @OpeningBalance + @DepositAmount AS ClosingBalance,
            @TransactionID AS TransactionID,
            @ATMID AS ATMID,
            'Deposit successful.' AS Message;

    END TRY

    BEGIN CATCH

        -- Roll back all changes if any error occurs
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO



