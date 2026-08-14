/* ============================================================
   2. EMPLOYEES
   ============================================================ */
CREATE TABLE Employees (
    EmployeeID          INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeCode         VARCHAR(20)    NOT NULL UNIQUE,
    BranchID             INT            NOT NULL,
    FirstName            NVARCHAR(50)   NOT NULL,
    LastName             NVARCHAR(50)   NOT NULL,
    Gender               VARCHAR(10)    NULL CHECK (Gender IN ('Male','Female','Other')),
    DOB                  DATE           NOT NULL,
    Designation           NVARCHAR(50)  NOT NULL,
    Department           NVARCHAR(50)   NULL,
    Email                NVARCHAR(100)  NOT NULL UNIQUE,
    MobileNumber         VARCHAR(15)    NOT NULL UNIQUE,
    HireDate             DATE           NOT NULL,
    Salary               DECIMAL(18,2)  NOT NULL CHECK (Salary >= 0),
    ReportingManagerID   INT            NULL,
    Status               VARCHAR(10)    NOT NULL DEFAULT 'Active' CHECK (Status IN ('Active','Inactive','Terminated')),
    CreatedDate          DATETIME2      NOT NULL DEFAULT SYSDATETIME(),
    ModifiedDate         DATETIME2      NULL,
    CONSTRAINT FK_Employees_Branches FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
    CONSTRAINT FK_Employees_Manager FOREIGN KEY (ReportingManagerID) REFERENCES Employees(EmployeeID)
);
GO

-- Now that Employees exists, complete the Branches <-> Employees relationship
ALTER TABLE Branches
ADD CONSTRAINT FK_Branches_Manager FOREIGN KEY (ManagerEmployeeID) REFERENCES Employees(EmployeeID);
GO





ALTER TABLE AuditLog
ADD EmployeeID INT NULL;