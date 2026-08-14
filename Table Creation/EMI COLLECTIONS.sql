/* ============================================================
   19. EMI COLLECTIONS
   ============================================================ */
CREATE TABLE EMICollections (
    EMIID              INT IDENTITY(1,1) PRIMARY KEY,
    LoanID             INT             NOT NULL,
    InstallmentNumber  INT             NOT NULL CHECK (InstallmentNumber > 0),
    DueDate            DATE            NOT NULL,
    PaidDate           DATE            NULL,
    AmountDue          DECIMAL(18,2)   NOT NULL CHECK (AmountDue >= 0),
    AmountPaid         DECIMAL(18,2)   NOT NULL DEFAULT 0 CHECK (AmountPaid >= 0),
    PenaltyAmount      DECIMAL(18,2)   NOT NULL DEFAULT 0 CHECK (PenaltyAmount >= 0),
    PaymentStatus      VARCHAR(15)     NOT NULL DEFAULT 'Pending' CHECK (PaymentStatus IN ('Pending','Paid','PartiallyPaid','Overdue','Waived')),
    TransactionID      INT             NULL,
    CONSTRAINT FK_EMICollections_Loans FOREIGN KEY (LoanID) REFERENCES Loans(LoanID),
    CONSTRAINT FK_EMICollections_Transactions FOREIGN KEY (TransactionID) REFERENCES Transactions(TransactionID),
    CONSTRAINT UQ_EMICollections_LoanInstallment UNIQUE (LoanID, InstallmentNumber)
);
GO