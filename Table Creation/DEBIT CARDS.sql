/* ============================================================
   13. DEBIT CARDS
   ============================================================ */
CREATE TABLE DebitCards (
    CardID                INT IDENTITY(1,1) PRIMARY KEY,
    AccountID             INT             NOT NULL,
    CardNumber            VARCHAR(20)     NOT NULL UNIQUE,
    CardType              VARCHAR(15)     NOT NULL DEFAULT 'Debit' CHECK (CardType IN ('Debit','Prepaid','Virtual')),
    CardNetwork           VARCHAR(15)     NOT NULL CHECK (CardNetwork IN ('Visa','MasterCard','RuPay','Amex')),
    IssueDate             DATE            NOT NULL DEFAULT CAST(SYSDATETIME() AS DATE),
    ExpiryDate            DATE            NOT NULL,
    PINGenerated          BIT             NOT NULL DEFAULT 0,
    CardStatus            VARCHAR(10)     NOT NULL DEFAULT 'Active' CHECK (CardStatus IN ('Active','Inactive','Blocked','Expired')),
    DailyWithdrawalLimit  DECIMAL(18,2)   NOT NULL DEFAULT 25000 CHECK (DailyWithdrawalLimit >= 0),
    DailyPurchaseLimit    DECIMAL(18,2)   NOT NULL DEFAULT 100000 CHECK (DailyPurchaseLimit >= 0),
    CONSTRAINT FK_DebitCards_Accounts FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    CONSTRAINT CHK_DebitCards_Expiry CHECK (ExpiryDate > IssueDate)
);
GO