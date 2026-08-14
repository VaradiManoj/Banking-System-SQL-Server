/* ======================================================================
    ATM CASH LOADING
   ======================================================================*/

CREATE OR ALTER PROCEDURE Load_ATM_Cash
(
    @ATMID              INT,
    @LoadedAmount       DECIMAL(18,2),
    @LoadedByEmployeeID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Validate loading amount
        IF @LoadedAmount <= 0
        BEGIN
            THROW 50001, 'Loaded amount must be greater than zero.', 1;
        END;

        -- 2. Validate employee
        IF NOT EXISTS
        (
            SELECT 1
            FROM Employees
            WHERE EmployeeID = @LoadedByEmployeeID
              AND Status = 'Active'
        )
        BEGIN
            THROW 50002, 'Employee does not exist or is not active.', 1;
        END;

        -- 3. Validate ATM
        IF NOT EXISTS
        (
            SELECT 1
            FROM ATM
            WHERE ATMID = @ATMID
              AND Status = 'Active'
        )
        BEGIN
            THROW 50003, 'ATM does not exist or is not active.', 1;
        END;

        DECLARE @CurrentCashBalance DECIMAL(18,2);
        DECLARE @CashCapacity      DECIMAL(18,2);

        -- 4. Get current ATM balance and capacity
        SELECT
            @CurrentCashBalance = CashBalance,
            @CashCapacity = CashCapacity
        FROM ATM
        WHERE ATMID = @ATMID;

        -- 5. Check ATM cash capacity
        IF @CurrentCashBalance + @LoadedAmount > @CashCapacity
        BEGIN
            THROW 50004, 'ATM cash capacity exceeded.', 1;
        END;

        -- 6. Update ATM cash balance
        UPDATE ATM
        SET
            CashBalance = CashBalance + @LoadedAmount,
            LastCashLoadDate = SYSDATETIME()
        WHERE ATMID = @ATMID;

        -- 7. Record ATM cash loading
        INSERT INTO ATMCashLoading  
        (
			ATMID,
            LoadedAmount,
            LoadedByEmployeeID,
            LoadDate,
            Remarks
        )
        VALUES
        (
            @ATMID,
            @LoadedAmount,
            @LoadedByEmployeeID,
            SYSDATETIME(),
            'Cash loaded into ATM'
        );

        -- 8. Commit everything
        COMMIT TRANSACTION;

        -- 9. Return result
        SELECT
            @ATMID AS ATMID,
            @CurrentCashBalance AS OpeningATMBalance,
            @LoadedAmount AS LoadedAmount,
            @CurrentCashBalance + @LoadedAmount AS ClosingATMBalance,
            @LoadedByEmployeeID AS LoadedByEmployeeID,
            'ATM cash loaded successfully.' AS Message;

    END TRY

    BEGIN CATCH

        -- Roll back if any error occurs
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO
