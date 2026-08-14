/* ============================================================
   27. LOGIN AUDIT
   ============================================================ */
CREATE TABLE LoginAudit (
    LoginID           INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID        INT             NOT NULL,
    LoginTime         DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    LogoutTime        DATETIME2       NULL,
    IPAddress         VARCHAR(45)     NULL,
    DeviceName        NVARCHAR(100)   NULL,
    Browser           NVARCHAR(50)    NULL,
    OperatingSystem   NVARCHAR(50)    NULL,
    LoginStatus       VARCHAR(10)     NOT NULL DEFAULT 'Success' CHECK (LoginStatus IN ('Success','Failed','Locked')),
    CONSTRAINT FK_LoginAudit_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT CHK_LoginAudit_Times CHECK (LogoutTime IS NULL OR LogoutTime >= LoginTime)
);
GO