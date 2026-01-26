CREATE TABLE dbo.Warehouses (
    WarehouseId      INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Warehouses PRIMARY KEY,
    [Name]           NVARCHAR(100) NOT NULL,
    [Address]        NVARCHAR(200) NULL,
    CreatedAt        DATETIME2(0) NOT NULL
        CONSTRAINT DF_Warehouses_CreatedAt DEFAULT SYSUTCDATETIME()
);