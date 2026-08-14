/* ============================================================
   4. CUSTOMER ADDRESS
   ============================================================ */
CREATE TABLE CustomerAddress (
    AddressID          INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID         INT             NOT NULL,
    AddressType        VARCHAR(15)     NOT NULL DEFAULT 'Permanent' CHECK (AddressType IN ('Permanent','Current','Office','Mailing')),
    HouseNumber        NVARCHAR(20)    NULL,
    Street             NVARCHAR(100)   NULL,
    Area               NVARCHAR(100)   NULL,
    Landmark           NVARCHAR(100)   NULL,
    City               NVARCHAR(50)    NOT NULL,
    District           NVARCHAR(50)    NULL,
    State              NVARCHAR(50)    NOT NULL,
    PostalCode         VARCHAR(10)     NOT NULL,
    Country            NVARCHAR(50)    NOT NULL DEFAULT 'India',
    AddressProofType   VARCHAR(30)     NULL CHECK (AddressProofType IN ('Aadhaar','Passport','UtilityBill','DrivingLicense','VoterID','Other')),
    CreatedDate        DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    ModifiedDate        DATETIME2      NULL,
    CONSTRAINT FK_CustomerAddress_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO