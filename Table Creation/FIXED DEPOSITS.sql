/* ============================================================
   20. FIXED DEPOSITS
   ============================================================ */
CREATE TABLE FixedDeposits (
    FDID             INT IDENTITY(1,1) PRIMARY KEY,
    AccountID        INT             NOT NULL,
    FDNumber         VARCHAR(20)     NOT NULL UNIQUE,
    DepositAmount    DECIMAL(18,2)   NOT NULL CHECK (DepositAmount > 0),
    InterestRate     DECIMAL(5,2)    NOT NULL CHECK (InterestRate >= 0),
    TenureMonths     INT             NOT NULL CHECK (TenureMonths > 0),
    StartDate        DATE            NOT NULL DEFAULT CAST(SYSDATETIME() AS DATE),
    MaturityDate     DATE            NOT NULL,
    MaturityAmount   DECIMAL(18,2)   NOT NULL CHECK (MaturityAmount >= 0),
    NomineeID        INT             NULL,
    Status           VARCHAR(15)     NOT NULL DEFAULT 'Active' CHECK (Status IN ('Active','Matured','PrematureClosed','Renewed')),
    CONSTRAINT FK_FixedDeposits_Accounts FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    CONSTRAINT FK_FixedDeposits_Nominees FOREIGN KEY (NomineeID) REFERENCES Nominees(NomineeID),
    CONSTRAINT CHK_FixedDeposits_Maturity CHECK (MaturityDate > StartDate)
);
GO