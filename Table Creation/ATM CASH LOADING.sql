/* ============================================================
   16. ATM CASH LOADING
   ============================================================ */
CREATE TABLE ATMCashLoading (
    CashLoadID          INT IDENTITY(1,1) PRIMARY KEY,
    ATMID               INT             NOT NULL,
    LoadedAmount        DECIMAL(18,2)   NOT NULL CHECK (LoadedAmount > 0),
    LoadedByEmployeeID  INT             NOT NULL,
    LoadDate            DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    Remarks             NVARCHAR(200)   NULL,
    CONSTRAINT FK_ATMCashLoading_ATM FOREIGN KEY (ATMID) REFERENCES ATM(ATMID),
    CONSTRAINT FK_ATMCashLoading_Employees FOREIGN KEY (LoadedByEmployeeID) REFERENCES Employees(EmployeeID)
);
GO