/*======================================================================
   CUSTOMER LOGIN
   Creates a new login session and records login details
  ====================================================================== */

CREATE OR ALTER PROCEDURE Customer_Login
(
    @CustomerID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        IF NOT EXISTS
        (
            SELECT 1
            FROM Customers
            WHERE CustomerID = @CustomerID
              AND CustomerStatus = 'Active'
        )
        BEGIN
            THROW 50101,'Customer does not exist or is not active.',1;
        END;

        INSERT INTO LoginAudit
        (
            CustomerID,
            LoginTime,
            IPAddress,
            DeviceName,
            Browser,
            OperatingSystem,
            LoginStatus
        )
        VALUES
        (
            @CustomerID,
            SYSDATETIME(),
            CONVERT(VARCHAR(45), CONNECTIONPROPERTY('client_net_address')),
            HOST_NAME(),
            NULL,
            NULL,
            'Success'
        );

        SELECT
            @CustomerID AS CustomerID,
            'Login successful.' AS Message;

    END TRY

    BEGIN CATCH
        THROW;
    END CATCH;

END;
GO

/* ======================================================================
   CUSTOMER LOGOUT
   Updates the active login session with LogoutTime
   ====================================================================== */

CREATE OR ALTER PROCEDURE Customer_Logout
(
    @LoginID INT
)
AS
BEGIN

    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM LoginAudit
        WHERE LoginID = @LoginID
          AND LogoutTime IS NULL
    )
    BEGIN
        THROW 50102,'Active login session does not exist.',1;
    END;

    UPDATE LoginAudit
    SET LogoutTime = SYSDATETIME()
    WHERE LoginID = @LoginID
      AND LogoutTime IS NULL;

    SELECT
        @LoginID AS LoginID,
        'Logout successful.' AS Message;
END;
GO


