/* ============================================================
   30. DAILY END OF DAY SUMMARY
   ============================================================ */
CREATE TABLE DailyEndOfDaySummary (
    SummaryID         INT IDENTITY(1,1) PRIMARY KEY,
    BranchID          INT             NOT NULL,
    BusinessDate      DATE            NOT NULL,
    TotalCredits      DECIMAL(18,2)   NOT NULL DEFAULT 0 CHECK (TotalCredits >= 0),
    TotalDebits       DECIMAL(18,2)   NOT NULL DEFAULT 0 CHECK (TotalDebits >= 0),
    TotalTransactions INT             NOT NULL DEFAULT 0 CHECK (TotalTransactions >= 0),
    CashInHand        DECIMAL(18,2)   NOT NULL DEFAULT 0 CHECK (CashInHand >= 0),
    ATMCash           DECIMAL(18,2)   NOT NULL DEFAULT 0 CHECK (ATMCash >= 0),
    ClosingBalance    DECIMAL(18,2)   NOT NULL DEFAULT 0,
    GeneratedBy       INT             NOT NULL,
    GeneratedDate     DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_DailyEOD_Branches FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
    CONSTRAINT FK_DailyEOD_Employees FOREIGN KEY (GeneratedBy) REFERENCES Employees(EmployeeID),
    CONSTRAINT UQ_DailyEOD_BranchDate UNIQUE (BranchID, BusinessDate)
);
GO