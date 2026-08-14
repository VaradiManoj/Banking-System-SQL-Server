/* ============================================================
   14. ATM
   ============================================================ */
CREATE TABLE ATM (
    ATMID              INT IDENTITY(1,1) PRIMARY KEY,
    BranchID           INT             NOT NULL,
    ATMCode            VARCHAR(20)     NOT NULL UNIQUE,
    ATMType            VARCHAR(15)     NOT NULL DEFAULT 'OnSite' CHECK (ATMType IN ('OnSite','OffSite','Mobile')),
    Location           NVARCHAR(200)   NOT NULL,
    CashBalance        DECIMAL(18,2)   NOT NULL DEFAULT 0 CHECK (CashBalance >= 0),
    CashCapacity       DECIMAL(18,2)   NOT NULL CHECK (CashCapacity > 0),
    LastCashLoadDate   DATETIME2       NULL,
    Status             VARCHAR(15)     NOT NULL DEFAULT 'Active' CHECK (Status IN ('Active','OutOfService','UnderMaintenance')),
    CONSTRAINT FK_ATM_Branches FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);
GO