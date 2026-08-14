/* ======================================================================
   2. WITHDRAW_MONEY
   ATM transactions are additionally recorded in ATMTransactions
   ====================================================================== */

CREATE OR ALTER PROCEDURE Withdraw_Money
(
    @AccountId        INT,
    @WithdrawAmount   DECIMAL(18,2),
    @Category         VARCHAR(30),       --( Cash Withdrawal | ATM Withdrawal | Cheque Clearance | Charges)
    @Channel          VARCHAR(20),       --( Branch | ATM | Internet Banking | Mobile Banking | POS | Auto Debit)
    @ATMID            INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Validate withdrawal amount
        IF @WithdrawAmount <= 0
        BEGIN
            THROW 50001, 'Withdrawal amount must be greater than zero.', 1;
        END;

        -- 2. Validate withdrawal category
        IF @Category NOT IN
        (
            'Cash Withdrawal',
            'ATM Withdrawal',
            'Cheque Clearance',
            'Charges'
        )
        BEGIN
            THROW 50003, 'Invalid withdrawal category.', 1;
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
        IF((@Category = 'Cash Withdrawal'AND @Channel NOT IN ('Branch', 'ATM'))
			OR
			(@Category = 'ATM Withdrawal'AND @Channel <> 'ATM')
			OR
			(@Category = 'Cheque Clearance'AND @Channel <> 'Branch')
			OR
			(@Category = 'Charges'AND @Channel NOT IN('Branch','ATM','Internet Banking','Mobile Banking','POS','Auto Debit'))
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
        IF @Channel <> 'ATM' AND @ATMID IS NOT NULL
        BEGIN
            THROW 50007, 'ATMID must be NULL for non-ATM transactions.', 1;
        END;

        -- 7. Get account balances
        DECLARE @OpeningBalance DECIMAL(18,2);
        DECLARE @AvailableBalance DECIMAL(18,2);
        DECLARE @OverdraftLimit DECIMAL(18,2);

        SELECT
            @OpeningBalance = CurrentBalance,
            @AvailableBalance = AvailableBalance,
            @OverdraftLimit = OverdraftLimit
        FROM Accounts
        WHERE AccountID = @AccountId;

        -- 8. Validate sufficient funds
        IF (@AvailableBalance + @OverdraftLimit) < @WithdrawAmount
        BEGIN
            THROW 50008, 'Insufficient funds for this withdrawal.', 1;
        END;

        -- 9. ATM cash validation
        DECLARE @ATMOpeningBalance DECIMAL(18,2);
        DECLARE @ATMClosingBalance DECIMAL(18,2);

        IF @Channel = 'ATM'
        BEGIN
            SELECT
                @ATMOpeningBalance = CashBalance
            FROM ATM
            WHERE ATMID = @ATMID;

            IF @ATMOpeningBalance < @WithdrawAmount
            BEGIN
                THROW 50009, 'Insufficient cash available in ATM.', 1;
            END;
        END;

        -- 10. Update customer account balance
        UPDATE Accounts
        SET
            CurrentBalance      = CurrentBalance - @WithdrawAmount,
            AvailableBalance    = AvailableBalance - @WithdrawAmount,
            LastTransactionDate = SYSDATETIME(),
            ModifiedDate        = SYSDATETIME()
        WHERE AccountID = @AccountId;

        -- 11. Insert financial transaction
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
            'WDL-'
            + CONVERT(VARCHAR(8), CAST(SYSDATETIME() AS DATE), 112)
            + '-'
            + RIGHT('000000'+ CAST(NEXT VALUE FOR TransactionReferenceSeqAS VARCHAR(6)),6),
            NULL,
            @AccountId,
            'Debit',
            @Category,
            @Channel,
            @WithdrawAmount,
            0.00,
            0.00,
            @OpeningBalance,
            @OpeningBalance - @WithdrawAmount,
            NULL,
            NULL,
            NULL,
            'Success',
            'Withdrawal made via ' + @Channel,
            NULL,
            NULL,
            SYSDATETIME(),
            SYSDATETIME()
        );

        -- 12. Capture generated TransactionID
        DECLARE @TransactionID INT;
        SET @TransactionID = SCOPE_IDENTITY();

        -- 13. ATM-specific processing
        IF @Channel = 'ATM'
        BEGIN

            -- 13.1 Reduce physical ATM cash
            UPDATE ATM
            SET
                CashBalance = CashBalance - @WithdrawAmount
            WHERE ATMID = @ATMID;

            -- 13.2 Get remaining ATM cash
            SELECT
                @ATMClosingBalance = CashBalance
            FROM ATM
            WHERE ATMID = @ATMID;

            -- 13.3 Record ATM transaction
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
                'Withdrawal',
                @WithdrawAmount,
                @ATMClosingBalance,
                SYSDATETIME()
            );

        END;

        -- 14. Commit complete operation
        COMMIT TRANSACTION;

        -- 15. Return result
        SELECT
            @AccountId AS AccountID,
            @OpeningBalance AS OpeningBalance,
            @WithdrawAmount AS WithdrawAmount,
            @OpeningBalance - @WithdrawAmount AS ClosingBalance,
            @TransactionID AS TransactionID,
            @ATMID AS ATMID,
            'Withdrawal successful.' AS Message;

    END TRY

    BEGIN CATCH

        -- Roll back all changes if any error occurs
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO

