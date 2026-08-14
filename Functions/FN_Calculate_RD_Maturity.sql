/* ======================================================================
   FUNCTION
   Calculate Recurring Deposit Maturity Amount
   ====================================================================== */

CREATE OR ALTER FUNCTION dbo.Calculate_RD_Maturity
(
    @DepositAmount DECIMAL(18,2),
    @Interest      DECIMAL(5,2),
    @Tenure        INT
)
RETURNS DECIMAL(18,2)
AS
BEGIN

    DECLARE @MaturityAmount DECIMAL(18,2);
    DECLARE @MonthlyRate DECIMAL(18,10);

    -- Convert annual interest rate into monthly rate
    SET @MonthlyRate = @Interest / 1200.0;

    -- Calculate maturity value of monthly installments
    SET @MaturityAmount =ROUND(@DepositAmount*((POWER(1 + @MonthlyRate, @Tenure) - 1)/ @MonthlyRate),2);

    RETURN @MaturityAmount;

END;
GO

