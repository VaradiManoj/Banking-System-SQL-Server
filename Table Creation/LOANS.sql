/* ============================================================
   17. LOANS
   ============================================================ */
CREATE TABLE Loans (
    LoanID               INT IDENTITY(1,1) PRIMARY KEY,
    LoanAccountNumber    VARCHAR(20)     NOT NULL UNIQUE,
    CustomerID           INT             NOT NULL,
    AccountID            INT             NOT NULL,
    LoanType             VARCHAR(20)     NOT NULL CHECK (LoanType IN ('Personal','Home','Auto','Education','Gold','Business')),
    LoanAmount           DECIMAL(18,2)   NOT NULL CHECK (LoanAmount > 0),
    InterestRate         DECIMAL(5,2)    NOT NULL CHECK (InterestRate >= 0),
    LoanTenureMonths     INT             NOT NULL CHECK (LoanTenureMonths > 0),
    EMIAmount            DECIMAL(18,2)   NOT NULL CHECK (EMIAmount >= 0),
    LoanStatus           VARCHAR(15)     NOT NULL DEFAULT 'Applied' CHECK (LoanStatus IN ('Applied','UnderReview','Approved','Rejected','Disbursed','Closed','Defaulted')),
    ApplicationDate      DATE            NOT NULL DEFAULT CAST(SYSDATETIME() AS DATE),
    ApprovalDate         DATE            NULL,
    DisbursementDate     DATE            NULL,
    ApprovedByEmployeeID INT             NULL,
    OutstandingAmount    DECIMAL(18,2)   NOT NULL CHECK (OutstandingAmount >= 0),
    Purpose              NVARCHAR(200)   NULL,
    CONSTRAINT FK_Loans_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Loans_Accounts FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    CONSTRAINT FK_Loans_Employees FOREIGN KEY (ApprovedByEmployeeID) REFERENCES Employees(EmployeeID)
);
GO