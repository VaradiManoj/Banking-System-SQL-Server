/* ======================================================================
   3. TRIGGER
   Automatically audit Fixed Deposit creation
   ====================================================================== */

CREATE OR ALTER TRIGGER trg_FixedDeposits_Audit
ON FixedDeposits
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
        'FixedDeposits',
        FDID,
        'INSERT',
        NULL,
        'FDNumber=' + FDNumber + '; AccountID=' + CAST(AccountID AS VARCHAR(20)) + '; Amount='+ CAST(DepositAmount AS VARCHAR(30)) + '; Status=' + Status,
        ISNULL(SUSER_SNAME(), 'SYSTEM'),
        SYSDATETIME(),
        NULL
    FROM inserted;
END;
GO


