/* ============================================================
   2. BRANCHES  (ManagerEmployeeID FK added later)
   ============================================================ */
CREATE TABLE Branches (
    BranchID          INT IDENTITY(1,1) PRIMARY KEY,
    BranchCode        VARCHAR(20)     NOT NULL UNIQUE,
    BranchName        NVARCHAR(100)   NOT NULL,
    IFSCCode          VARCHAR(11)     NOT NULL UNIQUE,
    MICRCode          VARCHAR(9)      NULL UNIQUE,
    BranchType        VARCHAR(20)     NOT NULL DEFAULT 'Retail' CHECK (BranchType IN ('Retail','Corporate','Rural','Digital')),
    AddressLine1      NVARCHAR(150)   NOT NULL,
    AddressLine2      NVARCHAR(150)   NULL,
    City              NVARCHAR(50)    NOT NULL,
    State             NVARCHAR(50)    NOT NULL,
    PostalCode        VARCHAR(10)     NOT NULL,
    Country           NVARCHAR(50)    NOT NULL DEFAULT 'India',
    PhoneNumber       VARCHAR(15)     NULL,
    Email             NVARCHAR(100)   NULL,
    OpeningDate       DATE            NOT NULL,
    ManagerEmployeeID INT             NULL,      -- FK added after Employees table exists
    Status            VARCHAR(10)     NOT NULL DEFAULT 'Active' CHECK (Status IN ('Active','Inactive','Closed')),
    CreatedDate       DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    ModifiedDate      DATETIME2       NULL
);
GO