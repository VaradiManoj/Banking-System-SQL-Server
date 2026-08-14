/* ============================================================
   28. NOTIFICATIONS
   ============================================================ */
CREATE TABLE Notifications (
    NotificationID    INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID        INT             NOT NULL,
    NotificationType  VARCHAR(20)     NOT NULL CHECK (NotificationType IN ('Transaction','Promotional','Security','LoanUpdate','General')),
    Subject           NVARCHAR(150)   NOT NULL,
    Message           NVARCHAR(MAX)   NOT NULL,
    DeliveryChannel   VARCHAR(10)     NOT NULL CHECK (DeliveryChannel IN ('SMS','Email','Push','InApp')),
    SentDate          DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    DeliveryStatus    VARCHAR(10)     NOT NULL DEFAULT 'Pending' CHECK (DeliveryStatus IN ('Pending','Sent','Failed')),
    CONSTRAINT FK_Notifications_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO