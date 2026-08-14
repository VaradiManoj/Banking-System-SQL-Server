/* ======================================================================
   TRIGGER
   Automatically audit Recurring Deposit creation
   ====================================================================== */

CREATE OR ALTER TRIGGER trg_RecurringDeposits_Audit
ON RecurringDeposits
AFTER INSERT
AS
BEGIN

    SET NOCOUNT ON;

    INSERT INTO AuditLog
    (
        TableName,
        RecordID,
        OperationType,
        OldValue,
        NewValue,
        ChangedBy,
        ChangedDate,
        IPAddress
    )
    SELECT
        'RecurringDeposits',
        RDID,
        'INSERT',
        NULL,
        'AccountID='+ CAST(AccountID AS VARCHAR(20)) + '; MonthlyInstallment=' + CAST(MonthlyInstallment AS VARCHAR(30))+ '; InterestRate='+ CAST(InterestRate AS VARCHAR(20))
		+ '; TenureMonths=' + CAST(TenureMonths AS VARCHAR(20)) + '; MaturityAmount=' + CAST(MaturityAmount AS VARCHAR(30)) + '; Status='+ Status,
        ISNULL(SUSER_SNAME(), 'SYSTEM'),
        SYSDATETIME(),
        NULL
    FROM inserted;
END;
GO


