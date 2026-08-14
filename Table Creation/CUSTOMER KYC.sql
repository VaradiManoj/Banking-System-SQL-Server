/* ============================================================
   5. CUSTOMER KYC
   ============================================================ */
CREATE TABLE CustomerKYC (
    KYCID                 INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID            INT         NOT NULL UNIQUE,   -- one KYC record per customer
    PANVerified           BIT         NOT NULL DEFAULT 0,
    AadhaarVerified       BIT         NOT NULL DEFAULT 0,
    PassportVerified      BIT         NOT NULL DEFAULT 0,
    PhotoVerified         BIT         NOT NULL DEFAULT 0,
    AddressVerified       BIT         NOT NULL DEFAULT 0,
    VideoKYCCompleted     BIT         NOT NULL DEFAULT 0,
    CKYCNumber            VARCHAR(20) NULL UNIQUE,
    KYCStatus             VARCHAR(15) NOT NULL DEFAULT 'Pending' CHECK (KYCStatus IN ('Pending','InProgress','Verified','Rejected','Expired')),
    VerifiedByEmployeeID  INT         NULL,
    VerificationDate      DATE        NULL,
    ExpiryDate            DATE        NULL,
    Remarks               NVARCHAR(300) NULL,
    CreatedDate           DATETIME2   NOT NULL DEFAULT SYSDATETIME(),
    ModifiedDate          DATETIME2   NULL,
    CONSTRAINT FK_CustomerKYC_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_CustomerKYC_Employees FOREIGN KEY (VerifiedByEmployeeID) REFERENCES Employees(EmployeeID)
);
GO



select * from CustomerKyc