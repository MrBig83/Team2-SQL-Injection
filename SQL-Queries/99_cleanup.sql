/*
99_cleanup.sql
Syfte:
Rensa hela miljön så projektet kan köras om från början.

Tar bort:
- Views
- Roller
- Users
- Logins
- Tabeller
- Databasen SQLTeam2

Scriptet är säkert att köra flera gånger.
*/

------------------------------------------------------------
-- 1) Byt till databasen (om den finns)
------------------------------------------------------------
IF DB_ID('SQLTeam2') IS NOT NULL
BEGIN
    USE SQLTeam2;
END;
GO


------------------------------------------------------------
-- 2) Drop VIEWS
------------------------------------------------------------
IF OBJECT_ID('dbo.vw_PublicOrders', 'V') IS NOT NULL
    DROP VIEW dbo.vw_PublicOrders;
GO

IF OBJECT_ID('dbo.vw_OrderLineReport', 'V') IS NOT NULL
    DROP VIEW dbo.vw_OrderLineReport;
GO


------------------------------------------------------------
-- 3) Drop ROLE
------------------------------------------------------------
IF EXISTS (
    SELECT 1 FROM sys.database_principals
    WHERE name = 'report_reader'
)
BEGIN
    DROP ROLE report_reader;
END;
GO


------------------------------------------------------------
-- 4) Drop USER
------------------------------------------------------------
IF EXISTS (
    SELECT 1 FROM sys.database_principals
    WHERE name = 'sqlteam2_app_user'
)
BEGIN
    DROP USER sqlteam2_app_user;
END;
GO


------------------------------------------------------------
-- 5) Drop LOGIN (server-nivå)
------------------------------------------------------------
USE master;
GO

IF EXISTS (
    SELECT 1 FROM sys.server_principals
    WHERE name = 'sqlteam2_app_login'
)
BEGIN
    DROP LOGIN sqlteam2_app_login;
END;
GO


------------------------------------------------------------
-- 6) Drop TABLES (FK-ordning!)
------------------------------------------------------------
IF DB_ID('SQLTeam2') IS NOT NULL
BEGIN
    USE SQLTeam2;
END;
GO

IF OBJECT_ID('dbo.OrderLines', 'U') IS NOT NULL
    DROP TABLE dbo.OrderLines;
GO

IF OBJECT_ID('dbo.Inventory', 'U') IS NOT NULL
    DROP TABLE dbo.Inventory;
GO

IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL
    DROP TABLE dbo.Orders;
GO

IF OBJECT_ID('dbo.ProductDetails', 'U') IS NOT NULL
    DROP TABLE dbo.ProductDetails;
GO

IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL
    DROP TABLE dbo.Products;
GO

IF OBJECT_ID('dbo.Warehouses', 'U') IS NOT NULL
    DROP TABLE dbo.Warehouses;
GO


------------------------------------------------------------
-- 7) Drop DATABASE (valfritt men tydligt)
------------------------------------------------------------
USE master;
GO

IF DB_ID('SQLTeam2') IS NOT NULL
BEGIN
    ALTER DATABASE SQLTeam2 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SQLTeam2;
END;
GO
