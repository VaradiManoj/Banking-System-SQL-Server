/* ======================================================================
   TRANSACTION NOTIFICATION
   Automatically creates context-specific notification after
   every successful transaction
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

        -- Notification type
        'Transaction',

        -- Transaction-specific subject
        CASE
            WHEN I.TransactionCategory = 'Cash Deposit'
                THEN 'Cash Deposit Successful'

            WHEN I.TransactionCategory = 'ATM Deposit'
                THEN 'ATM Deposit Successful'

            WHEN I.TransactionCategory = 'Cheque Deposit'
                THEN 'Cheque Deposit Successful'

            WHEN I.TransactionCategory = 'Interest Credit'
                THEN 'Interest Credited'

            WHEN I.TransactionCategory = 'Cash Withdrawal'
                THEN 'Cash Withdrawal Successful'

            WHEN I.TransactionCategory = 'ATM Withdrawal'
                THEN 'ATM Withdrawal Successful'

            WHEN I.TransactionCategory = 'Cheque Clearance'
                THEN 'Cheque Clearance Successful'

            WHEN I.TransactionCategory = 'Charges'
                THEN 'Bank Charge Applied'

            WHEN I.TransactionCategory = 'FD Booking'
                THEN 'Fixed Deposit Booked'

            WHEN I.TransactionCategory = 'RD Booking'
                THEN 'Recurring Deposit Booked'

            WHEN I.TransactionCategory = 'EMI Payment'
                THEN 'EMI Payment Successful'

            WHEN I.TransactionCategory IN ('UPI', 'IMPS', 'NEFT', 'RTGS')
                THEN I.TransactionCategory + ' Transfer Successful'

            ELSE 'Transaction Successful'
        END,

        -- Transaction-specific message
        CASE

            WHEN I.TransactionCategory = 'Cash Deposit'
                THEN 'Cash deposit of Rs. '
                     + CAST(I.Amount AS VARCHAR(30))
                     + ' completed successfully. Reference: '
                     + I.TransactionReferenceNumber

            WHEN I.TransactionCategory = 'ATM Deposit'
                THEN 'ATM deposit of Rs. '
                     + CAST(I.Amount AS VARCHAR(30))
                     + ' completed successfully. Reference: '
                     + I.TransactionReferenceNumber

            WHEN I.TransactionCategory = 'Cheque Deposit'
                THEN 'Cheque deposit of Rs. '
                     + CAST(I.Amount AS VARCHAR(30))
                     + ' recorded successfully. Reference: '
                     + I.TransactionReferenceNumber

            WHEN I.TransactionCategory = 'Interest Credit'
                THEN 'Interest of Rs. '
                     + CAST(I.Amount AS VARCHAR(30))
                     + ' credited successfully. Reference: '
                     + I.TransactionReferenceNumber

            WHEN I.TransactionCategory = 'Cash Withdrawal'
                THEN 'Cash withdrawal of Rs. '
                     + CAST(I.Amount AS VARCHAR(30))
                     + ' completed successfully. Reference: '
                     + I.TransactionReferenceNumber

            WHEN I.TransactionCategory = 'ATM Withdrawal'
                THEN 'ATM withdrawal of Rs. '
                     + CAST(I.Amount AS VARCHAR(30))
                     + ' completed successfully. Reference: '
                     + I.TransactionReferenceNumber

            WHEN I.TransactionCategory = 'Cheque Clearance'
                THEN 'Cheque clearance of Rs. '
                     + CAST(I.Amount AS VARCHAR(30))
                     + ' completed successfully. Reference: '
                     + I.TransactionReferenceNumber

            WHEN I.TransactionCategory = 'Charges'
                THEN 'Bank charge of Rs. '
                     + CAST(I.Amount AS VARCHAR(30))
                     + ' has been applied. Reference: '
                     + I.TransactionReferenceNumber

            WHEN I.TransactionCategory = 'FD Booking'
                THEN 'Fixed Deposit of Rs. '
                     + CAST(I.Amount AS VARCHAR(30))
                     + ' booked successfully. Reference: '
                     + I.TransactionReferenceNumber

            WHEN I.TransactionCategory = 'RD Booking'
                THEN 'Recurring Deposit of Rs. '
                     + CAST(I.Amount AS VARCHAR(30))
                     + ' booked successfully. Reference: '
                     + I.TransactionReferenceNumber

            WHEN I.TransactionCategory = 'EMI Payment'
                THEN 'EMI payment of Rs. '
                     + CAST(I.Amount AS VARCHAR(30))
                     + ' completed successfully. Reference: '
                     + I.TransactionReferenceNumber

            WHEN I.TransactionCategory IN ('UPI', 'IMPS', 'NEFT', 'RTGS')
                AND I.TransactionType = 'Debit'
                THEN I.TransactionCategory
                     + ' transfer of Rs. '
                     + CAST(I.Amount AS VARCHAR(30))
                     + ' completed successfully. Reference: '
                     + I.TransactionReferenceNumber

            WHEN I.TransactionCategory IN ('UPI', 'IMPS', 'NEFT', 'RTGS')
                AND I.TransactionType = 'Credit'
                THEN 'Rs. '
                     + CAST(I.Amount AS VARCHAR(30))
                     + ' received through '
                     + I.TransactionCategory
                     + '. Reference: '
                     + I.TransactionReferenceNumber

            ELSE
                'Transaction of Rs. '
                + CAST(I.Amount AS VARCHAR(30))
                + ' completed successfully. Reference: '
                + I.TransactionReferenceNumber

        END,

        -- Current project simulation uses SMS
        'SMS',

        SYSDATETIME(),

        -- Notification considered successfully sent
        'Sent'

    FROM inserted I

    INNER JOIN Accounts A
        ON I.AccountID = A.AccountID

    INNER JOIN Customers C
        ON A.CustomerID = C.CustomerID

    WHERE I.TransactionStatus = 'Success';

END;
GO