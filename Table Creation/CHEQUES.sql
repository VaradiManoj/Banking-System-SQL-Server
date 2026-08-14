/* ============================================================
   12. CHEQUES
   ============================================================ */
CREATE TABLE Cheques (
    ChequeID       INT IDENTITY(1,1) PRIMARY KEY,
    ChequeBookID   INT             NOT NULL,
    ChequeNumber   VARCHAR(15)     NOT NULL UNIQUE,
    IssueDate      DATE            NOT NULL,
    PayeeName      NVARCHAR(100)   NOT NULL,
    Amount         DECIMAL(18,2)   NOT NULL CHECK (Amount > 0),
    ChequeStatus   VARCHAR(15)     NOT NULL DEFAULT 'Issued' CHECK (ChequeStatus IN ('Issued','Presented','Cleared','Bounced','Cancelled','StopPayment')),
    ClearingDate   DATE            NULL,
    BounceReason   NVARCHAR(200)   NULL,
    CreatedDate    DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Cheques_ChequeBooks FOREIGN KEY (ChequeBookID) REFERENCES ChequeBooks(ChequeBookID)
);
GO