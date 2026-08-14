/* ======================================================================
   1. FUNCTION
   Calculate Fixed Deposit Maturity Amount
   ====================================================================== */

CREATE OR ALTER FUNCTION dbo.Calculate_FD_Maturity
(
    @DepositAmount DECIMAL(18,2),
    @InterestRate  DECIMAL(5,2),
    @TenureMonths  INT
)
RETURNS DECIMAL(18,2)
AS
BEGIN

    DECLARE @MaturityAmount DECIMAL(18,2);

    SET @MaturityAmount = ROUND(@DepositAmount * ( 1 + (@InterestRate / 100.0)* (@TenureMonths / 12.0)),2);

    RETURN @MaturityAmount;

END;
GO

