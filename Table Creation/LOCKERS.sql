/* ============================================================
   24. LOCKERS 
   ============================================================ */
CREATE TABLE Lockers (
    LockerID       INT IDENTITY(1,1) PRIMARY KEY,
    BranchID       INT             NOT NULL,
    LockerNumber   VARCHAR(20)     NOT NULL,
    LockerType     VARCHAR(10)     NOT NULL DEFAULT 'Medium' CHECK (LockerType IN ('Small','Medium','Large','ExtraLarge')),
    AnnualRent     DECIMAL(18,2)   NOT NULL CHECK (AnnualRent >= 0),
    Status         VARCHAR(15)     NOT NULL DEFAULT 'Available' CHECK (Status IN ('Available','Allocated','UnderMaintenance')),
    CONSTRAINT FK_Lockers_Branches FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
    CONSTRAINT UQ_Lockers_BranchLockerNumber UNIQUE (BranchID, LockerNumber)
);
GO
 