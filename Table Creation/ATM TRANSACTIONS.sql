/* ============================================================
   16. ATM TRANSACTIONS
   ============================================================ */
CREATE TABLE ATMTransactions (
    ATMTransactionID     INT IDENTITY(1,1) PRIMARY KEY,
    ATMID                INT             NOT NULL,
    AccountID            INT             NOT NULL,
    TransactionID        INT             NOT NULL UNIQUE,
    TransactionType      VARCHAR(15)     NOT NULL CHECK (TransactionType IN ('Withdrawal','BalanceInquiry','MiniStatement','PINChange','Deposit')),
    Amount               DECIMAL(18,2)   NOT NULL DEFAULT 0 CHECK (Amount >= 0),
    RemainingATMBalance  DECIMAL(18,2)   NOT NULL CHECK (RemainingATMBalance >= 0),
    TransactionDate      DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_ATMTransactions_ATM FOREIGN KEY (ATMID) REFERENCES ATM(ATMID),
    CONSTRAINT FK_ATMTransactions_Accounts FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    CONSTRAINT FK_ATMTransactions_Transactions FOREIGN KEY (TransactionID) REFERENCES Transactions(TransactionID)
);
GO