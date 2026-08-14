/* ============================================================
   11. CHEQUE BOOKS
   ============================================================ */
CREATE TABLE ChequeBooks (
    ChequeBookID       INT IDENTITY(1,1) PRIMARY KEY,
    AccountID          INT             NOT NULL,
    ChequeBookNumber   VARCHAR(20)     NOT NULL UNIQUE,
    SeriesStart        VARCHAR(15)     NOT NULL,
    SeriesEnd          VARCHAR(15)     NOT NULL,
    IssueDate          DATE            NOT NULL DEFAULT CAST(SYSDATETIME() AS DATE),
    IssuedByEmployeeID INT             NOT NULL,
    Status             VARCHAR(10)     NOT NULL DEFAULT 'Active' CHECK (Status IN ('Active','Exhausted','Blocked','Cancelled')),
    CONSTRAINT FK_ChequeBooks_Accounts FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    CONSTRAINT FK_ChequeBooks_Employees FOREIGN KEY (IssuedByEmployeeID) REFERENCES Employees(EmployeeID)
);