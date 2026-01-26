USE SQLTeam2;

CREATE TABLE dbo.Products (
    ProductId        INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Products PRIMARY KEY,
    SKU              NVARCHAR(50) NOT NULL
        CONSTRAINT UQ_Products_SKU UNIQUE,
    [Name]           NVARCHAR(200) NOT NULL,
    UnitPrice        DECIMAL(10,2) NOT NULL
        CONSTRAINT CK_Products_UnitPrice CHECK (UnitPrice >= 0),
    CreatedAt        DATETIME2(0) NOT NULL
        CONSTRAINT DF_Products_CreatedAt DEFAULT SYSUTCDATETIME()
);

