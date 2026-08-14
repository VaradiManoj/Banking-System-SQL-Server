/* ======================================================================
   CREATE SERVICE REQUEST
   Creates a new customer service request
   ====================================================================== */

CREATE OR ALTER PROCEDURE Create_ServiceRequest
(
    @CustomerID         INT,
    @AccountID          INT = NULL,
    @RequestType        VARCHAR(30),
    @Remarks            NVARCHAR(300) = NULL
)
AS
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        -- 1. Validate customer

        IF NOT EXISTS
        (
            SELECT 1
            FROM Customers
            WHERE CustomerID = @CustomerID
              AND CustomerStatus = 'Active'
        )
        BEGIN
            THROW 50201,
                  'Customer does not exist or is not active.',
                  1;
        END;

        -- 2. Validate request type

        IF @RequestType NOT IN
        (
            'ChequeBookRequest',
            'CardBlock',
            'AddressUpdate',
            'StatementRequest',
            'Complaint',
            'AccountClosure',
            'Other'
        )
        BEGIN
            THROW 50202,'Invalid service request type.',1;
        END;

        -- 3. Validate account if supplied

        IF @AccountID IS NOT NULL
        BEGIN

            IF NOT EXISTS
            (
                SELECT 1
                FROM Accounts
                WHERE AccountID = @AccountID
                  AND CustomerID = @CustomerID
            )
            BEGIN
                THROW 50203,'Account does not belong to this customer.',1;
            END;

        END;

        -- 4. Create service request

        INSERT INTO ServiceRequests
        (
            CustomerID,
            AccountID,
            RequestType,
            RequestStatus,
            RequestedDate,
            Remarks
        )
        VALUES
        (
            @CustomerID,
            @AccountID,
            @RequestType,
            'Open',
            SYSDATETIME(),
            @Remarks
        );

        DECLARE @RequestID INT;
        SET @RequestID = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SELECT
            @RequestID AS RequestID,
            @CustomerID AS CustomerID,
            @RequestType AS RequestType,
            'Service request created successfully.' AS Message;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;

END;
GO


/* ======================================================================
   UPDATE SERVICE REQUEST STATUS
   Updates the status and details of an existing service request
   ====================================================================== */

CREATE OR ALTER PROCEDURE Update_ServiceRequest
(
    @RequestID         INT,
    @RequestStatus     VARCHAR(15),
    @AssignedEmployeeID INT = NULL,
    @Remarks           NVARCHAR(300) = NULL
)
AS
BEGIN

    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM ServiceRequests
        WHERE RequestID = @RequestID
    )
    BEGIN
        THROW 50204,'Service request does not exist.',1;
    END;

    IF @RequestStatus NOT IN
    (
        'Open',
        'InProgress',
        'Resolved',
        'Rejected',
        'Closed'
    )
    BEGIN
        THROW 50205,'Invalid service request status.',1;
    END;

    UPDATE ServiceRequests
    SET
        RequestStatus = @RequestStatus,
        AssignedEmployeeID =COALESCE(@AssignedEmployeeID,AssignedEmployeeID),
        Remarks =COALESCE(@Remarks,Remarks),
        CompletedDate =
            CASE
                WHEN @RequestStatus IN ('Resolved', 'Closed') THEN SYSDATETIME()
                ELSE CompletedDate
            END
    WHERE RequestID = @RequestID;

    SELECT
        @RequestID AS RequestID,
        @RequestStatus AS RequestStatus,
        'Service request updated successfully.' AS Message;

END;
GO

