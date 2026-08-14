/* ============================================================
   4. EMPLOYEES  (30 rows across 20 branches)
   ============================================================ */
INSERT INTO Employees (EmployeeCode, BranchID, FirstName, LastName, Gender, DOB, Designation, Department, Email, MobileNumber, HireDate, Salary, ReportingManagerID, Status) VALUES
('EMP0001', 1, N'Anjali', N'Sharma', 'Female', '1977-02-06', N'Branch Manager', N'Management', 'anjali.sharma1@bharatsagarbank.in', '9657744287', '2014-11-27', 103959.65, NULL, 'Active'),
('EMP0002', 1, N'Ravi', N'Deshmukh', 'Male', '1981-03-26', N'Credit Analyst', N'Credit', 'ravi.deshmukh2@bharatsagarbank.in', '9713332041', '2013-06-27', 42426.02, 1, 'Active'),
('EMP0003', 2, N'Sneha', N'Mukherjee', 'Female', '1981-07-29', N'Branch Manager', N'Management', 'sneha.mukherjee3@bharatsagarbank.in', '9310679883', '2023-11-15', 143127.1, NULL, 'Active'),
('EMP0004', 3, N'Aishwarya', N'Naidu', 'Female', '1983-03-08', N'Branch Manager', N'Management', 'aishwarya.naidu4@bharatsagarbank.in', '9229661713', '2013-08-25', 112210.86, NULL, 'Active'),
('EMP0005', 3, N'Gopal', N'Shah', 'Male', '1980-02-20', N'Assistant Branch Manager', N'Management', 'gopal.shah5@bharatsagarbank.in', '9409572486', '2010-09-20', 81938.07, 4, 'Active'),
('EMP0006', 4, N'Ashok', N'Nair', 'Male', '1980-07-13', N'Branch Manager', N'Management', 'ashok.nair6@bharatsagarbank.in', '9745391478', '2022-08-04', 122338.64, NULL, 'Active'),
('EMP0007', 4, N'Harish', N'Iyer', 'Male', '1988-05-17', N'Operations Executive', N'Operations', 'harish.iyer7@bharatsagarbank.in', '9542596187', '2011-06-05', 53779.41, 6, 'Active'),
('EMP0008', 4, N'Kavita', N'Patel', 'Female', '1978-07-19', N'Operations Executive', N'Operations', 'kavita.patel8@bharatsagarbank.in', '9779751685', '2020-03-05', 28217.44, 6, 'Active'),
('EMP0009', 5, N'Karan', N'Mehta', 'Male', '1992-02-07', N'Branch Manager', N'Management', 'karan.mehta9@bharatsagarbank.in', '9750309883', '2013-08-16', 122362.74, NULL, 'Active'),
('EMP0010', 5, N'Manoj', N'Malhotra', 'Male', '1976-12-02', N'Relationship Manager', N'Retail Banking', 'manoj.malhotra10@bharatsagarbank.in', '9951691569', '2020-11-25', 82673.56, 9, 'Active'),
('EMP0011', 6, N'Ravi', N'Patel', 'Male', '1983-12-13', N'Branch Manager', N'Management', 'ravi.patel11@bharatsagarbank.in', '9512352206', '2018-05-18', 116286.01, NULL, 'Active'),
('EMP0012', 7, N'Vikram', N'Malhotra', 'Male', '1975-09-15', N'Branch Manager', N'Management', 'vikram.malhotra12@bharatsagarbank.in', '9262195478', '2017-05-30', 94251.44, NULL, 'Active'),
('EMP0013', 8, N'Arjun', N'Rao', 'Male', '1989-10-12', N'Branch Manager', N'Management', 'arjun.rao13@bharatsagarbank.in', '9480660781', '2019-09-02', 111257.85, NULL, 'Active'),
('EMP0014', 8, N'Sandeep', N'Mukherjee', 'Male', '1978-02-22', N'Compliance Officer', N'Compliance', 'sandeep.mukherjee14@bharatsagarbank.in', '9480880650', '2019-06-19', 40293.7, 13, 'Active'),
('EMP0015', 8, N'Yash', N'Krishnan', 'Male', '1978-09-24', N'Teller', N'Operations', 'yash.krishnan15@bharatsagarbank.in', '9240392744', '2019-02-12', 60537.96, 13, 'Active'),
('EMP0016', 9, N'Divya', N'Menon', 'Female', '1981-08-27', N'Branch Manager', N'Management', 'divya.menon16@bharatsagarbank.in', '9557055819', '2014-11-19', 148122.56, NULL, 'Active'),
('EMP0017', 9, N'Kunal', N'Iyer', 'Male', '1988-05-06', N'Relationship Manager', N'Retail Banking', 'kunal.iyer17@bharatsagarbank.in', '9218256455', '2011-07-11', 73239.24, 16, 'Active'),
('EMP0018', 10, N'Neha', N'Chauhan', 'Female', '1991-01-24', N'Branch Manager', N'Management', 'neha.chauhan18@bharatsagarbank.in', '9362370499', '2017-01-17', 104321.16, NULL, 'Active'),
('EMP0019', 11, N'Deepak', N'Menon', 'Male', '1986-05-07', N'Branch Manager', N'Management', 'deepak.menon19@bharatsagarbank.in', '9302245398', '2015-12-13', 97947.39, NULL, 'Active'),
('EMP0020', 12, N'Gopal', N'Naidu', 'Male', '1987-06-10', N'Branch Manager', N'Management', 'gopal.naidu20@bharatsagarbank.in', '9182871223', '2016-09-18', 145905.36, NULL, 'Active'),
('EMP0021', 13, N'Radhika', N'Chatterjee', 'Female', '1980-08-19', N'Branch Manager', N'Management', 'radhika.chatterjee21@bharatsagarbank.in', '9420762754', '2011-02-21', 95537.91, NULL, 'Active'),
('EMP0022', 14, N'Arjun', N'Reddy', 'Male', '1994-10-22', N'Branch Manager', N'Management', 'arjun.reddy22@bharatsagarbank.in', '9851138788', '2013-05-06', 122735.42, NULL, 'Active'),
('EMP0023', 15, N'Gopal', N'Gupta', 'Male', '1989-12-16', N'Branch Manager', N'Management', 'gopal.gupta23@bharatsagarbank.in', '9589792171', '2012-04-22', 111220.72, NULL, 'Active'),
('EMP0024', 16, N'Priya', N'Iyer', 'Female', '1991-07-09', N'Branch Manager', N'Management', 'priya.iyer24@bharatsagarbank.in', '9467217304', '2017-06-14', 136943.19, NULL, 'Active'),
('EMP0025', 17, N'Abhishek', N'Kapoor', 'Male', '1985-04-28', N'Branch Manager', N'Management', 'abhishek.kapoor25@bharatsagarbank.in', '9720138926', '2017-11-04', 108311.45, NULL, 'Active'),
('EMP0026', 18, N'Preeti', N'Naidu', 'Female', '1987-01-10', N'Branch Manager', N'Management', 'preeti.naidu26@bharatsagarbank.in', '9191921473', '2017-06-05', 146354.23, NULL, 'Active'),
('EMP0027', 18, N'Pradeep', N'Malhotra', 'Male', '1980-09-17', N'Teller', N'Operations', 'pradeep.malhotra27@bharatsagarbank.in', '9095776306', '2010-12-30', 75488.61, 26, 'Active'),
('EMP0028', 19, N'Rekha', N'Shah', 'Female', '1989-11-17', N'Branch Manager', N'Management', 'rekha.shah28@bharatsagarbank.in', '9334421496', '2012-10-17', 133185.26, NULL, 'Active'),
('EMP0029', 19, N'Sachin', N'Singh', 'Male', '1984-02-09', N'Customer Service Executive', N'Operations', 'sachin.singh29@bharatsagarbank.in', '9327634657', '2022-04-16', 83859.59, 28, 'Active'),
('EMP0030', 20, N'Gopal', N'Reddy', 'Male', '1981-05-13', N'Branch Manager', N'Management', 'gopal.reddy30@bharatsagarbank.in', '9609238109', '2021-07-24', 129831.23, NULL, 'Active');
GO
 
-- Backfill branch managers now that Employees exist
UPDATE Branches SET ManagerEmployeeID = 1 WHERE BranchID = 1;
UPDATE Branches SET ManagerEmployeeID = 3 WHERE BranchID = 2;
UPDATE Branches SET ManagerEmployeeID = 4 WHERE BranchID = 3;
UPDATE Branches SET ManagerEmployeeID = 6 WHERE BranchID = 4;
UPDATE Branches SET ManagerEmployeeID = 9 WHERE BranchID = 5;
UPDATE Branches SET ManagerEmployeeID = 11 WHERE BranchID = 6;
UPDATE Branches SET ManagerEmployeeID = 12 WHERE BranchID = 7;
UPDATE Branches SET ManagerEmployeeID = 13 WHERE BranchID = 8;
UPDATE Branches SET ManagerEmployeeID = 16 WHERE BranchID = 9;
UPDATE Branches SET ManagerEmployeeID = 18 WHERE BranchID = 10;
UPDATE Branches SET ManagerEmployeeID = 19 WHERE BranchID = 11;
UPDATE Branches SET ManagerEmployeeID = 20 WHERE BranchID = 12;
UPDATE Branches SET ManagerEmployeeID = 21 WHERE BranchID = 13;
UPDATE Branches SET ManagerEmployeeID = 22 WHERE BranchID = 14;
UPDATE Branches SET ManagerEmployeeID = 23 WHERE BranchID = 15;
UPDATE Branches SET ManagerEmployeeID = 24 WHERE BranchID = 16;
UPDATE Branches SET ManagerEmployeeID = 25 WHERE BranchID = 17;
UPDATE Branches SET ManagerEmployeeID = 26 WHERE BranchID = 18;
UPDATE Branches SET ManagerEmployeeID = 28 WHERE BranchID = 19;
UPDATE Branches SET ManagerEmployeeID = 30 WHERE BranchID = 20;
GO