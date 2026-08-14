/* ============================================================
   25. CUSTOMER LOCKERS
   ============================================================ */
CREATE TABLE CustomerLockers (
    CustomerLockerID  INT IDENTITY(1,1) PRIMARY KEY,
    LockerID          INT             NOT NULL,
    CustomerID        INT             NOT NULL,
    AllocatedDate     DATE            NOT NULL DEFAULT CAST(SYSDATETIME() AS DATE),
    ExpiryDate        DATE            NULL,
    Status            VARCHAR(15)     NOT NULL DEFAULT 'Active' CHECK (Status IN ('Active','Surrendered','Expired')),
    CONSTRAINT FK_CustomerLockers_Lockers FOREIGN KEY (LockerID) REFERENCES Lockers(LockerID),
    CONSTRAINT FK_CustomerLockers_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO