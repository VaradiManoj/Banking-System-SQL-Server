
/* ======================================================================
   3. TRANSFER_MONEY
   Transfers between two active accounts in the banking system
   ====================================================================== */

CREATE OR ALTER PROCEDURE Transfer_Money
(
    @FromAccountID   INT,
    @ToAccountID     INT,
    @TransferAmount  DECIMAL(18,2),
    @Category        VARCHAR(30),        --( UPI | IMPS | NEFT | RTGS )
    @Channel         VARCHAR(20)         --( Branch | Internet Banking | Mobile Banking )
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Validate transfer amount
        IF @TransferAmount <= 0
        BEGIN
            THROW 50001, 'Transfer amount must be greater than zero.', 1;
        END;

        -- 2. Sender and receiver cannot be the same account
        IF @FromAccountID = @ToAccountID
        BEGIN
            THROW 50002, 'Sender and receiver accounts cannot be the same.', 1;
        END;

        -- 3. Validate transfer category
        IF @Category NOT IN('UPI','IMPS','NEFT','RTGS')
        BEGIN
            THROW 50003, 'Invalid transfer category.', 1;
        END;

        -- 4. Validate sender account
        IF NOT EXISTS
        (
            SELECT 1
            FROM Accounts
            WHERE AccountID = @FromAccountID
              AND AccountStatus = 'Active'
        )
        BEGIN
            THROW 50004, 'Sender account does not exist or is not active.', 1;
        END;

        -- 5. Validate receiver account
        IF NOT EXISTS
        (
            SELECT 1
            FROM Accounts
            WHERE AccountID = @ToAccountID
              AND AccountStatus = 'Active'
        )
        BEGIN
            THROW 50005, 'Receiver account does not exist or is not active.', 1;
        END;

        -- 6. Validate Category + Payment Channel
        IF
        (
            (@Category = 'UPI' AND @Channel <> 'Mobile Banking')
			OR
			(@Category = 'IMPS' AND @Channel NOT IN ('Branch','Internet Banking','Mobile Banking'))
			OR
			(@Category = 'NEFT' AND @Channel NOT IN ('Branch','Internet Banking','Mobile Banking'))
			OR
			(@Category = 'RTGS' AND @Channel NOT IN ('Branch','Internet Banking','Mobile Banking'))
        )
        BEGIN
            THROW 50006, 'Invalid Category and Payment Channel combination.', 1;
        END;

        -- 7. Validate Mobile Banking
        IF @Channel = 'Mobile Banking'
        BEGIN
            IF NOT EXISTS
            (
                SELECT 1
                FROM DigitalBanking
                WHERE AccountID = @FromAccountID
                  AND MobileBankingEnabled = 1
            )
            BEGIN
                THROW 50007,'Mobile Banking is not enabled for the sender account.',1;
            END;
        END;

        -- 8. Validate Internet Banking
        IF @Channel = 'Internet Banking'
        BEGIN
            IF NOT EXISTS
            (
                SELECT 1
                FROM DigitalBanking
                WHERE AccountID = @FromAccountID
                  AND InternetBankingEnabled = 1
            )
            BEGIN
                THROW 50008,'Internet Banking is not enabled for the sender account.',1;
            END;
        END;

        -- 9. Validate UPI
        IF @Category = 'UPI'
        BEGIN
            IF NOT EXISTS
            (
                SELECT 1
                FROM DigitalBanking
                WHERE AccountID = @FromAccountID
                  AND UPIEnabled = 1
            )
            BEGIN
                THROW 50009,'UPI is not enabled for the sender account.',1;
            END;
        END;

        -- 10. Get sender balance
        DECLARE
            @FromOpeningBalance   DECIMAL(18,2),
            @FromAvailableBalance DECIMAL(18,2),
            @OverdraftLimit       DECIMAL(18,2);

        SELECT
            @FromOpeningBalance   = CurrentBalance,
            @FromAvailableBalance = AvailableBalance,
            @OverdraftLimit       = OverdraftLimit
        FROM Accounts WITH (UPDLOCK, HOLDLOCK)
        WHERE AccountID = @FromAccountID;

        -- 11. Validate sender funds
        IF (@FromAvailableBalance + @OverdraftLimit) < @TransferAmount
        BEGIN
            THROW 50010, 'Insufficient funds for this transfer.', 1;
        END;

        -- 12. Get receiver opening balance
        DECLARE @ToOpeningBalance DECIMAL(18,2);

        SELECT
            @ToOpeningBalance = CurrentBalance
        FROM Accounts WITH (UPDLOCK, HOLDLOCK)
        WHERE AccountID = @ToAccountID;

        -- 13. Get sender and receiver account numbers
        DECLARE
            @FromAccountNumber VARCHAR(20),
            @ToAccountNumber   VARCHAR(20);

        SELECT
            @FromAccountNumber = AccountNumber
        FROM Accounts
        WHERE AccountID = @FromAccountID;

        SELECT
            @ToAccountNumber = AccountNumber
        FROM Accounts
        WHERE AccountID = @ToAccountID;

        -- 14. Generate common transfer reference
        DECLARE @TransferReferenceNumber VARCHAR(30);

        SET @TransferReferenceNumber =
            'TRF-'
            + CONVERT(VARCHAR(8),CAST(SYSDATETIME() AS DATE),112)
            + '-'
            + RIGHT('000000'+ CAST(NEXT VALUE FOR TransactionReferenceSeq AS VARCHAR(6)),6);

        -- 15. Debit sender account
        UPDATE Accounts
        SET
            CurrentBalance      = CurrentBalance - @TransferAmount,
            AvailableBalance    = AvailableBalance - @TransferAmount,
            LastTransactionDate = SYSDATETIME(),
            ModifiedDate        = SYSDATETIME()
        WHERE AccountID = @FromAccountID;

        -- 16. Record sender debit transaction
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
            @TransferReferenceNumber + '-D',
            @TransferReferenceNumber,
            @FromAccountID,
            'Debit',
            @Category,
            @Channel,
            @TransferAmount,
            0.00,
            0.00,
            @FromOpeningBalance,
            @FromOpeningBalance - @TransferAmount,
            @ToAccountNumber,
            NULL,
            NULL,
            'Success',
            @Category + ' transfer sent via ' + @Channel,
            NULL,
            NULL,
            SYSDATETIME(),
            SYSDATETIME()
        );

        -- 17. Credit receiver account
        UPDATE Accounts
        SET
            CurrentBalance      = CurrentBalance + @TransferAmount,
            AvailableBalance    = AvailableBalance + @TransferAmount,
            LastTransactionDate = SYSDATETIME(),
            ModifiedDate        = SYSDATETIME()
        WHERE AccountID = @ToAccountID;

        -- 18. Record receiver credit transaction
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
            @TransferReferenceNumber + '-C',
            @TransferReferenceNumber,
            @ToAccountID,
            'Credit',
            @Category,
            @Channel,
            @TransferAmount,
            0.00,
            0.00,
            @ToOpeningBalance,
            @ToOpeningBalance + @TransferAmount,
            @FromAccountNumber,
            NULL,
            NULL,
            'Success',
			@Category + ' transfer received via ' + @Channel,
            NULL,
            NULL,
            SYSDATETIME(),
            SYSDATETIME()
        );

        -- 19. Commit complete transfer
        COMMIT TRANSACTION;

        -- 20. Return transfer result
        SELECT
            @TransferReferenceNumber AS TransferReferenceNumber,
            @FromAccountID AS FromAccountID,
            @ToAccountID AS ToAccountID,
            @TransferAmount AS TransferAmount,
            @FromOpeningBalance - @TransferAmount
                AS SenderClosingBalance,
            @ToOpeningBalance + @TransferAmount
                AS ReceiverClosingBalance,
            @Category AS TransferCategory,
            @Channel AS PaymentChannel,
            'Transfer successful.' AS Message;

    END TRY

    BEGIN CATCH

        -- Roll back complete transfer if any step fails
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO





