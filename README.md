# 🏦 Banking System — SQL Server & T-SQL

A comprehensive banking database project built using **Microsoft SQL Server and T-SQL**, designed to simulate real-world banking operations through stored procedures, functions, triggers, transactions, validations, audit logging, notifications, and operational reporting.

## 🚀 Key Features

* 👤 Customer & Account Management
* 🏦 Branch & Employee Management
* 💰 Cash Deposit & Cash Withdrawal
* 🏧 ATM Cash Loading & ATM Transactions
* 💸 Money Transfer — UPI, IMPS & NEFT
* 💵 Fixed Deposit & Recurring Deposit
* 🏦 Loan & EMI Management
* 🛎️ Customer Service Requests
* 🔔 Automatic Transaction Notifications
* 🔐 Login & Logout Auditing
* 📋 FD & RD Audit Logging
* 📊 Daily End-of-Day Branch Summary

## 🧠 SQL Server Concepts Used

* T-SQL
* Stored Procedures
* User-Defined Functions
* Triggers
* Transactions
* `TRY...CATCH`
* `THROW`
* SQL Server Sequences
* Primary & Foreign Keys
* Unique & Check Constraints
* Joins
* Aggregate Functions
* `CASE`
* `COALESCE` / `ISNULL`
* Referential Integrity
* Business Rule Validation

## 📂 Repository Structure

```text
Banking-System-SQL-Server/
│
├── Functions/
├── Sample Data/
├── Screenshots/
├── Stored Procedures/
├── Table Creation/
├── Triggers/
│
├── Database Schema.sql
├── ER Diagram.pptx
├── SEQUENCE.sql
└── README.md
```

## ⚙️ How to Run

Run the project in **SQL Server Management Studio (SSMS)** in the following order:

1. Create the database
2. Create the tables
3. Insert the sample data
4. Create the sequence
5. Create the functions
6. Create the stored procedures
7. Create the triggers
8. Execute and test the banking operations

## 📸 Execution Screenshots

The `Screenshots` folder contains execution evidence for major banking operations.

The demonstrations show the **Before → Execute → After** flow wherever applicable.

Included examples:

* Cash Deposit
* Cash Withdrawal
* ATM Cash Loading
* Money Transfer
* Fixed Deposit
* Recurring Deposit
* EMI Collection
* Service Requests
* Login & Logout
* Transaction Notifications
* Daily End-of-Day Summary

## 📐 ER Diagram

The project includes an ER diagram showing the relationships between major banking entities such as:

**Customers, Accounts, Branches, Employees, Transactions, Loans, EMI Collections, Fixed Deposits, Recurring Deposits, ATMs, Cards, Cheques, Service Requests, Notifications and Audit Logs.**

The ER diagram is available in:

[View ER Diagram](./ER%20Diagram.pptx)

## 🛠️ Technology Stack

| Technology                   | Usage                   |
| ---------------------------- | ----------------------- |
| Microsoft SQL Server         | Database                |
| T-SQL                        | Database programming    |
| SQL Server Management Studio | Development & execution |

## 👨‍💻 Author

**Manoj Varadi**

B.Tech — Computer Science & Engineering
Aspiring | SQL Developer | Data Analytics

⭐ Project Status

Completed as a SQL Server/T-SQL banking database project.
The project is intended as a practical demonstration of relational database design, T-SQL programming, transaction processing, automation, and banking-domain business logic.
