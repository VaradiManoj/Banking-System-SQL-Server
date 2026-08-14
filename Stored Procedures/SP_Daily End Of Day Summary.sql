/* ======================================================================
   GENERATE DAILY END-OF-DAY SUMMARY
   Summarizes branch-level financial activity for a business date
   ====================================================================== */

CREATE OR ALTER PROCEDURE Generate_DailyEndOfDaySummary
(
    @BranchID      INT,
    @BusinessDate  DATE = NULL,
    @GeneratedBy   INT
)
AS
BEGIN

    SET NOCOUNT ON;
	SET @BusinessDate = ISNULL(@BusinessDate, CAST(SYSDATETIME() AS DATE));

    BEGIN TRY

        BEGIN TRANSACTION;

        -- 1. Validate branch

        IF NOT EXISTS
        (
            SELECT 1
            FROM Branches
            WHERE BranchID = @BranchID
        )
        BEGIN
            THROW 50301,'Branch does not exist.',1;
        END;

        -- 2. Prevent duplicate summary

        IF EXISTS
        (
            SELECT 1
            FROM DailyEndOfDaySummary
            WHERE BranchID = @BranchID
              AND BusinessDate = @BusinessDate
        )
        BEGIN
            THROW 50302,'Daily end-of-day summary already exists for this branch and date.',1;
        END;

        -- 3. Calculate transaction totals

        DECLARE
            @TotalCredits      DECIMAL(18,2),
            @TotalDebits       DECIMAL(18,2),
            @TotalTransactions INT;

        SELECT
            @TotalCredits =ISNULL(SUM(
						CASE WHEN T.TransactionType = 'Credit'
							 THEN T.Amount
							 ELSE 0
						END),0),
            @TotalDebits =ISNULL(SUM(
						CASE
                            WHEN T.TransactionType = 'Debit'
                            THEN T.Amount
                            ELSE 0
                        END),0),
            @TotalTransactions =COUNT(*)
									 FROM Transactions T
									 INNER JOIN Accounts A
									 ON T.AccountID = A.AccountID
								WHERE A.BranchID = @BranchID
								AND CAST(T.TransactionDate AS DATE) = @BusinessDate
								AND T.TransactionStatus = 'Success';

        -- 4. Calculate branch closing balance

        DECLARE @ClosingBalance DECIMAL(18,2);

        SELECT @ClosingBalance =ISNULL(SUM(CurrentBalance),0)
        FROM Accounts
        WHERE BranchID = @BranchID
          AND AccountStatus = 'Active';


        -- 5. Calculate ATM cash

        DECLARE @ATMCash DECIMAL(18,2);

        SELECT @ATMCash =ISNULL(SUM(CashBalance),0)
        FROM ATM
        WHERE BranchID = @BranchID
          AND Status = 'Active';


        -- 6. Insert daily summary

        INSERT INTO DailyEndOfDaySummary
        (
            BranchID,
            BusinessDate,
            TotalCredits,
            TotalDebits,
            TotalTransactions,
            CashInHand,
            ATMCash,
            ClosingBalance,
            GeneratedBy,
            GeneratedDate
        )
        VALUES
        (
            @BranchID,
            @BusinessDate,
            @TotalCredits,
            @TotalDebits,
            @TotalTransactions,
            0.00,
            @ATMCash,
            @ClosingBalance,
            @GeneratedBy,
            SYSDATETIME()
        );

        COMMIT TRANSACTION;

        SELECT
            @BranchID AS BranchID,
            @BusinessDate AS BusinessDate,
            @TotalCredits AS TotalCredits,
            @TotalDebits AS TotalDebits,
            @TotalTransactions AS TotalTransactions,
            @ATMCash AS ATMCash,
            @ClosingBalance AS ClosingBalance,
            'Daily end-of-day summary generated successfully.' AS Message;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH 

END;
GO