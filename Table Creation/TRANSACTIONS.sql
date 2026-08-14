/* ============================================================
   10. TRANSACTIONS
   ============================================================ */
CREATE TABLE Transactions (
    TransactionID              INT IDENTITY(1,1) PRIMARY KEY,
    TransactionReferenceNumber VARCHAR(30)     NOT NULL UNIQUE,
    TransferReferenceNumber    VARCHAR(30)     NULL,
    AccountID                  INT             NOT NULL,
    TransactionType            VARCHAR(10)     NOT NULL CHECK (TransactionType IN ('Credit','Debit')),
    TransactionCategory        VARCHAR(30)     NOT NULL CHECK (TransactionCategory IN ('Cash Deposit','Cash Withdrawal','NEFT','RTGS','IMPS','UPI','ATM Withdrawal','ATM Deposit','Cheque Deposit','Cheque Clearance','Interest Credit','Loan EMI','FD Booking','RD Deposit','Charges')),
    PaymentChannel              VARCHAR(20)    NOT NULL CHECK (PaymentChannel IN ('Branch','ATM','Internet Banking','Mobile Banking','POS','Auto Debit')),
    Amount                      DECIMAL(18,2)  NOT NULL CHECK (Amount > 0),
    Charges                     DECIMAL(18,2)  NOT NULL DEFAULT 0 CHECK (Charges >= 0),
    TaxAmount                  DECIMAL(18,2)   NOT NULL DEFAULT 0 CHECK (TaxAmount >= 0),
    OpeningBalance              DECIMAL(18,2)  NOT NULL,
    ClosingBalance              DECIMAL(18,2)  NOT NULL,
    CounterpartyAccountNumber   VARCHAR(20)    NULL,
    CounterpartyName            NVARCHAR(100)  NULL,
    CounterpartyBank            NVARCHAR(100)  NULL,
    TransactionStatus           VARCHAR(15)    NOT NULL DEFAULT 'Success' CHECK (TransactionStatus IN ('Success','Failed','Pending','Reversed')),
    Remarks                     NVARCHAR(300)  NULL,
    InitiatedBy                 INT            NULL,     -- EmployeeID or system
    ApprovedBy                  INT            NULL,     -- EmployeeID
    TransactionDate             DATETIME2      NOT NULL DEFAULT SYSDATETIME(),
    CreatedDate                 DATETIME2      NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Transactions_Accounts FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    CONSTRAINT FK_Transactions_InitiatedBy FOREIGN KEY (InitiatedBy) REFERENCES Employees(EmployeeID),
    CONSTRAINT FK_Transactions_ApprovedBy FOREIGN KEY (ApprovedBy) REFERENCES Employees(EmployeeID)
);
GO
 