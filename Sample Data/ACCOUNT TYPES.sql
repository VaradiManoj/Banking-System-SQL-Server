/* ============================================================
   3. ACCOUNT TYPES  (10 realistic Indian retail-banking products)
   ============================================================ */
INSERT INTO AccountTypes
(AccountTypeName, MinimumBalance, InterestRate, WithdrawalLimit, ATMWithdrawalLimit, Status) VALUES
('Savings - Regular',                          1000.00,  3.00, 100000.00,  25000.00, 'Active'),
('Savings - Premium',                         10000.00,  3.50, 500000.00,  50000.00, 'Active'),
('Savings - Senior Citizen',                   1000.00,  4.00, 150000.00,  40000.00, 'Active'),
('Basic Savings Bank Deposit Account (BSBDA)',    0.00,  2.75,  50000.00,  10000.00, 'Active'),
('Savings - Student',                             0.00,  3.00,  25000.00,  10000.00, 'Active'),
('Salary Account',                                0.00,  3.00, 200000.00,  50000.00, 'Active'),
('Current Account - Individual',                5000.00,  0.00, 1000000.00, 100000.00, 'Active'),
('Current Account - Business',                 25000.00,  0.00, 5000000.00, 200000.00, 'Active'),
('NRI Savings - NRE',                          10000.00,  3.25, 300000.00,  50000.00, 'Active'),
('NRI Savings - NRO',                          10000.00,  3.25, 300000.00,  50000.00, 'Active');
GO