/* ============================================================
   1. CURRENCY MASTER
   ============================================================ */
CREATE TABLE CurrencyMaster (
    CurrencyCode     CHAR(3)         NOT NULL PRIMARY KEY,       -- e.g. INR, USD
    CurrencyName     NVARCHAR(50)    NOT NULL,
    CurrencySymbol   NVARCHAR(5)     NOT NULL,
    ExchangeRate     DECIMAL(18,6)   NOT NULL DEFAULT 1.0 CHECK (ExchangeRate > 0),
    Status           VARCHAR(10)     NOT NULL DEFAULT 'Active' CHECK (Status IN ('Active','Inactive'))
);
GO
 