-- 1:1 mot Products (PK=FK)
CREATE TABLE dbo.ProductDetails (
    ProductId        INT NOT NULL
        CONSTRAINT PK_ProductDetails PRIMARY KEY
        CONSTRAINT FK_ProductDetails_Products FOREIGN KEY REFERENCES dbo.Products(ProductId),
    WeightKg         DECIMAL(8,3) NULL
        CONSTRAINT CK_ProductDetails_WeightKg CHECK (WeightKg IS NULL OR WeightKg >= 0),
    DimensionsCm     NVARCHAR(100) NULL,
    CreatedAt        DATETIME2(0) NOT NULL
        CONSTRAINT DF_ProductDetails_CreatedAt DEFAULT SYSUTCDATETIME()
);