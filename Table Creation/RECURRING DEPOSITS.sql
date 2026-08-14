/* ============================================================
   21. RECURRING DEPOSITS
   ============================================================ */
CREATE TABLE RecurringDeposits (
    RDID                INT IDENTITY(1,1) PRIMARY KEY,
    AccountID           INT             NOT NULL,
    MonthlyInstallment  DECIMAL(18,2)   NOT NULL CHECK (MonthlyInstallment > 0),
    InterestRate        DECIMAL(5,2)    NOT NULL CHECK (InterestRate >= 0),
    TenureMonths        INT             NOT NULL CHECK (TenureMonths > 0),
    OpeningDate         DATE            NOT NULL DEFAULT CAST(SYSDATETIME() AS DATE),
    MaturityDate        DATE            NOT NULL,
    MaturityAmount      DECIMAL(18,2)   NOT NULL CHECK (MaturityAmount >= 0),
    Status              VARCHAR(15)     NOT NULL DEFAULT 'Active' CHECK (Status IN ('Active','Matured','PrematureClosed','Defaulted')),
    CONSTRAINT FK_RecurringDeposits_Accounts FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    CONSTRAINT CHK_RecurringDeposits_Maturity CHECK (MaturityDate > OpeningDate)
);
GO
 