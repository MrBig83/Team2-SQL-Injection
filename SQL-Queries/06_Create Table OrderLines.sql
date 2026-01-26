CREATE TABLE dbo.OrderLines
(
    OrderId          INT NOT NULL,
    LineNr           INT NOT NULL,
    ProductId        INT NOT NULL,
    Quantity         INT NOT NULL
        CONSTRAINT CK_OrderLines_Quantity CHECK (Quantity > 0),
    UnitPriceAtOrder DECIMAL(10,2) NOT NULL
        CONSTRAINT CK_OrderLines_UnitPriceAtOrder CHECK (UnitPriceAtOrder >= 0),
    CreatedAt        DATETIME2(0) NOT NULL
        CONSTRAINT DF_OrderLines_CreatedAt DEFAULT SYSUTCDATETIME(),

    CONSTRAINT PK_OrderLines PRIMARY KEY (OrderId, LineNr),
    CONSTRAINT FK_OrderLines_Orders FOREIGN KEY (OrderId)
        REFERENCES dbo.Orders (OrderId)
        ON DELETE CASCADE,
    CONSTRAINT FK_OrderLines_Products FOREIGN KEY (ProductId)
        REFERENCES dbo.Products (ProductId)
);
