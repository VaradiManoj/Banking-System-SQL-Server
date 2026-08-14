/* ============================================================
   3. CUSTOMERS
   ============================================================ */
CREATE TABLE Customers (
    CustomerID           INT IDENTITY(1,1) PRIMARY KEY,
    CustomerNumber       VARCHAR(20)     NOT NULL UNIQUE,
    FirstName            NVARCHAR(50)    NOT NULL,
    MiddleName           NVARCHAR(50)    NULL,
    LastName             NVARCHAR(50)    NOT NULL,
    Gender               VARCHAR(10)     NULL CHECK (Gender IN ('Male','Female','Other')),
    DOB                  DATE            NOT NULL,
    MaritalStatus        VARCHAR(15)     NULL CHECK (MaritalStatus IN ('Single','Married','Divorced','Widowed')),
    Occupation           NVARCHAR(50)    NULL,
    AnnualIncome         DECIMAL(18,2)   NULL CHECK (AnnualIncome >= 0),
    Email                NVARCHAR(100)   NOT NULL UNIQUE,
    MobileNumber         VARCHAR(15)     NOT NULL UNIQUE,
    AlternateMobile      VARCHAR(15)     NULL,
    PANNumber            VARCHAR(10)     NULL UNIQUE,
    AadhaarNumber        VARCHAR(12)     NULL UNIQUE,
    PassportNumber       VARCHAR(15)     NULL UNIQUE,
    DrivingLicenseNumber VARCHAR(20)     NULL UNIQUE,
    Nationality           NVARCHAR(50)   NOT NULL DEFAULT 'Indian',
    CustomerType         VARCHAR(15)     NOT NULL DEFAULT 'Individual' CHECK (CustomerType IN ('Individual','Corporate','Joint')),
    RiskCategory         VARCHAR(10)     NOT NULL DEFAULT 'Low' CHECK (RiskCategory IN ('Low','Medium','High')),
    CustomerStatus       VARCHAR(10)     NOT NULL DEFAULT 'Active' CHECK (CustomerStatus IN ('Active','Inactive','Blacklisted','Deceased')),
    CreatedDate          DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    ModifiedDate         DATETIME2       NULL
);
GO
 