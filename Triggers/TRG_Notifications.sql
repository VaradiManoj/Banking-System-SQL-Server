/* ======================================================================
   TRANSACTION NOTIFICATION
   Automatically creates notification after successful transaction
   ====================================================================== */

CREATE OR ALTER TRIGGER trg_Transactions_Notification
ON Transactions
AFTER INSERT
AS
BEGIN

    SET NOCOUNT ON;

    INSERT INTO Notifications
    (
        CustomerID,
        NotificationType,
        Subject,
        Message,
        DeliveryChannel,
        SentDate,
        DeliveryStatus
    )
    SELECT
        C.CustomerID,
        'Transaction',
        CASE
            WHEN I.TransactionType = 'Credit'
                THEN 'Money Credited'
            WHEN I.TransactionType = 'Debit'
                THEN 'Money Debited'
            ELSE 'Transaction Alert'
        END,

        'Transaction of Rs. '
        + CAST(I.Amount AS VARCHAR(30))
        + ' completed successfully. Reference: '
        + I.TransactionReferenceNumber,
        'SMS',
        SYSDATETIME(),
        'Pending'

    FROM inserted I
    INNER JOIN Accounts A
        ON I.AccountID = A.AccountID
    INNER JOIN Customers C
        ON A.CustomerID = C.CustomerID
    WHERE I.TransactionStatus = 'Success';

END;
GO

EXEC Deposit_Money
    @AccountId = 15,
    @DepositAmount = 5000,
    @Category = 'Cash Deposit',
    @Channel = 'Branch';

select * from Notifications