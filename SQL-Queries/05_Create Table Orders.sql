CREATE TABLE dbo.Orders (
    OrderId          INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Orders PRIMARY KEY,
    CustomerName     NVARCHAR(200) NOT NULL,
    [Status]         NVARCHAR(20) NOT NULL
        CONSTRAINT CK_Orders_Status CHECK ([Status] IN ('New','Picking','Shipped','Cancelled')),
    CreatedAt        DATETIME2(0) NOT NULL
        CONSTRAINT DF_Orders_CreatedAt DEFAULT SYSUTCDATETIME()
);