/* ============================================================
   26. AUDIT LOG
   ============================================================ */
CREATE TABLE AuditLog (
    AuditID        INT IDENTITY(1,1) PRIMARY KEY,
    TableName      NVARCHAR(50)    NOT NULL,
    RecordID       INT             NOT NULL,
    OperationType  VARCHAR(10)     NOT NULL CHECK (OperationType IN ('INSERT','UPDATE','DELETE')),
    OldValue       NVARCHAR(MAX)   NULL,
    NewValue       NVARCHAR(MAX)   NULL,
    ChangedBy      NVARCHAR(50)    NOT NULL,      -- login/employee code or 'SYSTEM'
    ChangedDate    DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    IPAddress      VARCHAR(45)     NULL
);
GO



ALTER TABLE AuditLog
ADD CONSTRAINT FK_AuditLog_Employee
FOREIGN KEY (EmployeeID)
REFERENCES Employees(EmployeeID);