/* ============================================================
   8. ACCOUNT TYPES
   ============================================================ */
CREATE TABLE AccountTypes (
    AccountTypeID       INT IDENTITY(1,1) PRIMARY KEY,
    AccountTypeName     NVARCHAR(50)    NOT NULL UNIQUE,
    MinimumBalance      DECIMAL(18,2)   NOT NULL DEFAULT 0 CHECK (MinimumBalance >= 0),
    InterestRate        DECIMAL(5,2)    NOT NULL DEFAULT 0 CHECK (InterestRate >= 0),
    WithdrawalLimit     DECIMAL(18,2)   NULL CHECK (WithdrawalLimit >= 0),
    ATMWithdrawalLimit  DECIMAL(18,2)   NULL CHECK (ATMWithdrawalLimit >= 0),
    Status              VARCHAR(10)     NOT NULL DEFAULT 'Active' CHECK (Status IN ('Active','Inactive'))
);
GO