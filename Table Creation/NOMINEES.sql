/* ============================================================
   7. NOMINEES
   ============================================================ */
CREATE TABLE Nominees (
    NomineeID         INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID        INT             NOT NULL,
    NomineeName       NVARCHAR(100)   NOT NULL,
    Relationship      NVARCHAR(30)    NOT NULL,
    DOB               DATE            NULL,
    PercentageShare   DECIMAL(5,2)    NOT NULL DEFAULT 100.00 CHECK (PercentageShare > 0 AND PercentageShare <= 100),
    MobileNumber      VARCHAR(15)     NULL,
    Address           NVARCHAR(300)   NULL,
    CreatedDate       DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    ModifiedDate      DATETIME2       NULL,
    CONSTRAINT FK_Nominees_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO