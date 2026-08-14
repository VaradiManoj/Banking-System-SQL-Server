/* ============================================================
   9. ACCOUNTS
   ============================================================ */
CREATE TABLE Accounts (
    AccountID          INT IDENTITY(1,1) PRIMARY KEY,
    AccountNumber      VARCHAR(20)     NOT NULL UNIQUE,
    CustomerID         INT             NOT NULL,
    BranchID           INT             NOT NULL,
    AccountTypeID      INT             NOT NULL,
    OpeningDate        DATE            NOT NULL DEFAULT CAST(SYSDATETIME() AS DATE),
    CurrentBalance     DECIMAL(18,2)   NOT NULL DEFAULT 0,
    AvailableBalance   DECIMAL(18,2)   NOT NULL DEFAULT 0,
    LienAmount         DECIMAL(18,2)   NOT NULL DEFAULT 0 CHECK (LienAmount >= 0),
    OverdraftLimit     DECIMAL(18,2)   NOT NULL DEFAULT 0 CHECK (OverdraftLimit >= 0),
    CurrencyCode       CHAR(3)         NOT NULL DEFAULT 'INR',
    AccountStatus      VARCHAR(15)     NOT NULL DEFAULT 'Active' CHECK (AccountStatus IN ('Active','Dormant','Frozen','Closed')),
    FreezeReason       NVARCHAR(200)   NULL,
    ClosedDate         DATE            NULL,
    ClosedByEmployeeID INT             NULL,
    LastTransactionDate DATETIME2      NULL,
    CreatedDate        DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    ModifiedDate       DATETIME2       NULL,
    CONSTRAINT FK_Accounts_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Accounts_Branches FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
    CONSTRAINT FK_Accounts_AccountTypes FOREIGN KEY (AccountTypeID) REFERENCES AccountTypes(AccountTypeID),
    CONSTRAINT FK_Accounts_Currency FOREIGN KEY (CurrencyCode) REFERENCES CurrencyMaster(CurrencyCode),
    CONSTRAINT FK_Accounts_ClosedBy FOREIGN KEY (ClosedByEmployeeID) REFERENCES Employees(EmployeeID),
    CONSTRAINT CHK_Accounts_Balance CHECK (CurrentBalance >= -OverdraftLimit)
);
GO