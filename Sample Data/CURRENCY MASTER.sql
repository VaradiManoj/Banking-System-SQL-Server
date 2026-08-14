/* ============================================================
   1. CURRENCY MASTER  (12 currencies, INR as base = 1.000000)
   ============================================================ */
INSERT INTO CurrencyMaster (CurrencyCode, CurrencyName, CurrencySymbol, ExchangeRate, Status) VALUES
('INR', 'Indian Rupee',        N'₹',   1.000000,  'Active'),
('USD', 'US Dollar',           N'$',   83.240000, 'Active'),
('EUR', 'Euro',                N'€',   90.180000, 'Active'),
('GBP', 'British Pound Sterling', N'£', 105.620000, 'Active'),
('JPY', 'Japanese Yen',        N'¥',   0.562000,  'Active'),
('AUD', 'Australian Dollar',   N'A$',  54.870000, 'Active'),
('CAD', 'Canadian Dollar',     N'C$',  61.140000, 'Active'),
('SGD', 'Singapore Dollar',    N'S$',  61.980000, 'Active'),
('AED', 'UAE Dirham',          N'د.إ', 22.660000, 'Active'),
('CHF', 'Swiss Franc',         N'CHF', 95.310000, 'Active'),
('CNY', 'Chinese Yuan Renminbi', N'¥', 11.520000, 'Active'),
('HKD', 'Hong Kong Dollar',    N'HK$', 10.640000, 'Inactive');  -- kept for legacy NRI accounts, not offered on new products
GO