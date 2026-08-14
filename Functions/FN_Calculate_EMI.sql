/* ======================================================================
   FUNCTION
   Calculates monthly EMI using the standard reducing-balance formula
   ====================================================================== */

CREATE OR ALTER FUNCTION dbo.Calculate_EMI
(
    @LoanAmount DECIMAL(18,2),
    @InterestRate DECIMAL(5,2),
    @TenureMonths INT
)
RETURNS DECIMAL(18,2)
AS
BEGIN

    DECLARE @MonthlyRate DECIMAL(18,10);
    DECLARE @EMI DECIMAL(18,2);

    SET @MonthlyRate = (@InterestRate / 100.0) / 12;

    IF @MonthlyRate = 0
    BEGIN
        SET @EMI = @LoanAmount / @TenureMonths;
    END
    ELSE
    BEGIN
        SET @EMI = @LoanAmount * @MonthlyRate 
				   * POWER(1 + @MonthlyRate, @TenureMonths)/ (POWER(1 + @MonthlyRate, @TenureMonths) - 1);
        END;

    RETURN ROUND(@EMI, 2);

END;
GO

