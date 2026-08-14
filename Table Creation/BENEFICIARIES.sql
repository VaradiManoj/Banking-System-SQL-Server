/* ============================================================
   23. BENEFICIARIES
   ============================================================ */
CREATE TABLE Beneficiaries (
    BeneficiaryID           INT IDENTITY(1,1) PRIMARY KEY,
    AccountID                INT            NOT NULL,
    BeneficiaryName          NVARCHAR(100)  NOT NULL,
    BeneficiaryAccountNumber VARCHAR(20)    NOT NULL,
    IFSCCode                 VARCHAR(11)    NOT NULL,
    BankName                 NVARCHAR(100)  NOT NULL,
    Nickname                 NVARCHAR(50)   NULL,
    AddedDate                DATETIME2      NOT NULL DEFAULT SYSDATETIME(),
    Status                   VARCHAR(10)    NOT NULL DEFAULT 'Active' CHECK (Status IN ('Active','Inactive')),
    CONSTRAINT FK_Beneficiaries_Accounts FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    CONSTRAINT UQ_Beneficiaries_AccountBeneficiary UNIQUE (AccountID, BeneficiaryAccountNumber)
);
GO