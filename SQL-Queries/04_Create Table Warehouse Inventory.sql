-- N:M Products <-> Warehouses via Inventory
CREATE TABLE dbo.Inventory (
    WarehouseId      INT NOT NULL,
    ProductId        INT NOT NULL,
    QuantityOnHand   INT NOT NULL
        CONSTRAINT CK_Inventory_QuantityOnHand CHECK (QuantityOnHand >= 0),
    ReorderLevel     INT NOT NULL
        CONSTRAINT CK_Inventory_ReorderLevel CHECK (ReorderLevel >= 0),
    CreatedAt        DATETIME2(0) NOT NULL
        CONSTRAINT DF_Inventory_CreatedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_Inventory PRIMARY KEY (WarehouseId, ProductId),
    CONSTRAINT FK_Inventory_Warehouses FOREIGN KEY (WarehouseId)
        REFERENCES dbo.Warehouses(WarehouseId),
    CONSTRAINT FK_Inventory_Products FOREIGN KEY (ProductId)
        REFERENCES dbo.Products(ProductId)
);