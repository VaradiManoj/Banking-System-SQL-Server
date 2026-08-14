/* ============================================================
   29. SERVICE REQUESTS
   ============================================================ */
CREATE TABLE ServiceRequests (
    RequestID           INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID          INT             NOT NULL,
    AccountID           INT             NULL,
    RequestType         VARCHAR(30)     NOT NULL CHECK (RequestType IN ('ChequeBookRequest','CardBlock','AddressUpdate','StatementRequest','Complaint','AccountClosure','Other')),
    RequestStatus       VARCHAR(15)     NOT NULL DEFAULT 'Open' CHECK (RequestStatus IN ('Open','InProgress','Resolved','Rejected','Closed')),
    RequestedDate       DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    CompletedDate       DATETIME2       NULL,
    AssignedEmployeeID  INT             NULL,
    Remarks             NVARCHAR(300)   NULL,
    CONSTRAINT FK_ServiceRequests_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_ServiceRequests_Accounts FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    CONSTRAINT FK_ServiceRequests_Employees FOREIGN KEY (AssignedEmployeeID) REFERENCES Employees(EmployeeID)
);
GO