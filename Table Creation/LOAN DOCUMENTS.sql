/* ============================================================
   18. LOAN DOCUMENTS
   ============================================================ */
CREATE TABLE LoanDocuments (
    DocumentID           INT IDENTITY(1,1) PRIMARY KEY,
    LoanID               INT             NOT NULL,
    DocumentType         VARCHAR(30)     NOT NULL CHECK (DocumentType IN ('PAN','Aadhaar','SalarySlip','BankStatement','PropertyPaper','ITReturn','Other')),
    DocumentNumber       VARCHAR(30)     NULL,
    Verified             BIT             NOT NULL DEFAULT 0,
    VerifiedByEmployeeID INT             NULL,
    VerificationDate     DATE            NULL,
    Remarks              NVARCHAR(200)   NULL,
    CONSTRAINT FK_LoanDocuments_Loans FOREIGN KEY (LoanID) REFERENCES Loans(LoanID),
    CONSTRAINT FK_LoanDocuments_Employees FOREIGN KEY (VerifiedByEmployeeID) REFERENCES Employees(EmployeeID)
);
GO
 