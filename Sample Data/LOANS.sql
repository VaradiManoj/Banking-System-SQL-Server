/*============================================================
15. LOANS  (25 rows)
   ============================================================ */
INSERT INTO Loans (LoanAccountNumber, CustomerID, AccountID, LoanType, LoanAmount, InterestRate, LoanTenureMonths, EMIAmount, LoanStatus, ApplicationDate, ApprovalDate, DisbursementDate, ApprovedByEmployeeID, OutstandingAmount, Purpose) VALUES
('LN001000001', 13, 9, 'Auto', 2553273.55, 9.2, 36, 81431.29, 'Closed', '2022-01-17', '2023-08-05', '2025-01-04', 20, 0.0, N'Purchase of new car'),
('LN018000002', 11, 6, 'Home', 2481003.22, 8.4, 48, 61035.45, 'Approved', '2025-01-19', '2025-07-11', NULL, 26, 1835950.08, N'Purchase of residential flat'),
('LN008000003', 22, 22, 'Education', 2471401.28, 9.8, 48, 62444.01, 'UnderReview', '2023-09-10', NULL, NULL, NULL, 1103121.1, N'Higher education abroad'),
('LN015000004', 21, 21, 'Gold', 1237275.94, 7.5, 36, 38486.98, 'Approved', '2022-09-16', '2024-12-10', NULL, 18, 688123.79, N'Working capital against gold jewellery'),
('LN007000005', 25, 26, 'Personal', 1839683.46, 10.5, 36, 59794.21, 'Disbursed', '2022-11-24', '2022-02-26', '2022-03-18', 29, 1541892.58, N'Wedding expenses'),
('LN013000006', 45, 50, 'Gold', 979546.61, 7.5, 24, 44079.2, 'Approved', '2024-10-31', '2022-08-24', NULL, 24, 424114.45, N'Working capital against gold jewellery'),
('LN017000007', 15, 11, 'Auto', 983171.96, 9.2, 60, 20504.6, 'Disbursed', '2022-04-08', '2022-09-22', '2024-07-27', 10, 702810.06, N'Purchase of new car'),
('LN012000008', 26, 28, 'Personal', 1640700.35, 10.5, 24, 76089.19, 'UnderReview', '2025-04-06', NULL, NULL, NULL, 1166666.7, N'Wedding expenses'),
('LN004000009', 9, 4, 'Business', 2362769.85, 11.2, 60, 51608.32, 'Disbursed', '2023-09-05', '2023-08-15', '2025-04-07', 22, 1127004.17, N'Business expansion'),
('LN010000010', 52, 60, 'Education', 1866866.6, 9.8, 24, 85974.19, 'Disbursed', '2024-11-23', '2025-04-16', '2023-02-18', 27, 1546143.08, N'Higher education abroad'),
('LN013000011', 44, 49, 'Education', 433158.63, 9.8, 48, 10944.46, 'UnderReview', '2022-06-17', NULL, NULL, NULL, 195240.51, N'Higher education abroad'),
('LN004000012', 8, 3, 'Education', 3120931.61, 9.8, 48, 78855.46, 'Disbursed', '2022-06-09', '2024-02-05', '2025-01-01', 13, 2258092.96, N'Higher education abroad'),
('LN013000013', 39, 43, 'Gold', 2748004.05, 7.5, 24, 123659.06, 'Disbursed', '2024-05-17', '2024-06-29', '2024-10-18', 24, 2570207.82, N'Working capital against gold jewellery'),
('LN010000014', 38, 42, 'Home', 590777.02, 8.4, 24, 26827.15, 'Disbursed', '2024-07-26', '2022-10-01', '2024-12-06', 28, 408243.23, N'Purchase of residential flat'),
('LN012000015', 14, 10, 'Business', 822984.63, 11.2, 48, 21350.49, 'Disbursed', '2022-11-18', '2025-02-27', '2024-02-15', 30, 760027.92, N'Business expansion'),
('LN016000016', 33, 37, 'Gold', 2997880.51, 7.5, 12, 260088.37, 'Disbursed', '2025-03-16', '2023-08-26', '2022-04-12', 17, 1451925.94, N'Working capital against gold jewellery'),
('LN016000017', 49, 56, 'Auto', 1136743.61, 9.2, 36, 36254.05, 'Disbursed', '2024-09-22', '2022-03-08', '2022-11-08', 5, 944731.56, N'Purchase of new car'),
('LN014000018', 37, 41, 'Education', 265413.56, 9.8, 36, 8539.25, 'Closed', '2023-03-18', '2023-01-19', '2024-10-17', 1, 0.0, N'Higher education abroad'),
('LN015000019', 41, 46, 'Personal', 1961626.82, 10.5, 12, 172914.66, 'Closed', '2024-05-05', '2024-09-21', '2025-04-07', 10, 0.0, N'Wedding expenses'),
('LN015000020', 46, 52, 'Gold', 1638073.05, 7.5, 24, 73712.62, 'UnderReview', '2024-08-31', NULL, NULL, NULL, 1407027.75, N'Working capital against gold jewellery'),
('LN007000021', 31, 34, 'Gold', 551552.67, 7.5, 12, 47851.28, 'Disbursed', '2024-08-01', '2024-07-19', '2024-07-27', 5, 483430.43, N'Working capital against gold jewellery'),
('LN004000022', 20, 19, 'Auto', 403670.93, 9.2, 60, 8418.78, 'Approved', '2024-04-18', '2024-03-13', NULL, 8, 361339.75, N'Purchase of new car'),
('LN016000023', 26, 27, 'Auto', 1939381.13, 9.2, 48, 48445.97, 'Approved', '2022-07-01', '2022-12-15', NULL, 23, 802209.97, N'Purchase of new car'),
('LN012000024', 48, 55, 'Business', 2806939.86, 11.2, 36, 92161.69, 'Disbursed', '2022-09-11', '2025-02-28', '2022-07-13', 7, 2597380.97, N'Business expansion'),
('LN018000025', 33, 36, 'Gold', 2061308.98, 7.5, 12, 178833.84, 'Closed', '2024-12-04', '2023-02-01', '2024-09-20', 17, 0.0, N'Working capital against gold jewellery');
GO
 