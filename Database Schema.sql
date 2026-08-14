/* ======================================================================
   BANKING SYSTEM DATABASE - T-SQL SCHEMA (SQL Server)
   ======================================================================
   Notes:
   - IDENTITY(1,1) used for all surrogate PKs.
   - "UNIQUE NOT NULL" used wherever a table needed a second natural
     key alongside the surrogate PK (as requested).
   - CHECK constraints enforce enum-like status columns and
     non-negative amounts.
   - Created in dependency order. Branches <-> Employees is circular
     (Branch has a Manager who is an Employee; Employee belongs to a
     Branch) so the Branches -> Employees FK is added at the end via
     ALTER TABLE.
   ====================================================================== */
 
CREATE DATABASE BankingSystem;
GO
USE BankingSystem;
GO