USE master;
GO

/*
10_security.sql
Syfte:
Skapa SQL LOGIN,
Skapa database USER kopplad till login,
Skapa ROLE,
Ge SELECT endast på views,
INGEN direkt access till tabeller,
*/

------------------------------------------------------------
-- 1) Skapa LOGIN (server-nivå)
------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1 FROM sys.server_principals
    WHERE name = 'sqlteam2_app_login'
)
BEGIN
    CREATE LOGIN sqlteam2_app_login
    WITH PASSWORD = 'StrongPassword!123';
END;
GO


------------------------------------------------------------
-- 2) Byt till databasen
------------------------------------------------------------
USE SQLTeam2;
GO


------------------------------------------------------------
-- 3) Skapa USER kopplad till login
------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals
    WHERE name = 'sqlteam2_app_user'
)
BEGIN
    CREATE USER sqlteam2_app_user
    FOR LOGIN sqlteam2_app_login;
END;
GO


------------------------------------------------------------
-- 4) Skapa ROLE
------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals
    WHERE name = 'report_reader'
)
BEGIN
    CREATE ROLE report_reader;
END;
GO


------------------------------------------------------------
-- 5) Lägg user i rollen
------------------------------------------------------------
ALTER ROLE report_reader
ADD MEMBER sqlteam2_app_user;
GO


------------------------------------------------------------
-- 6) GRANT SELECT på VIEWS (endast views!)
------------------------------------------------------------

-- Public view (döljer känsliga kolumner)
GRANT SELECT ON dbo.vw_PublicProducts TO report_reader;

-- Report view (används av Console App)
GRANT SELECT ON dbo.vw_OrderSummary TO report_reader;
GO
