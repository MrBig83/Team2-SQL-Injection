-- 1) Products
INSERT INTO dbo.Products (SKU, [Name], UnitPrice)
VALUES
('SKU-1001','USB-C Cable 1m', 99.00),
('SKU-1002','Wireless Mouse', 299.00),
('SKU-1003','Mechanical Keyboard', 1299.00),
('SKU-1004','27-inch Monitor', 2499.00),
('SKU-1005','Laptop Stand', 399.00),
('SKU-1006','HDMI Cable 2m', 129.00),
('SKU-1007','Webcam 1080p', 699.00),
('SKU-1008','USB Hub 7-port', 499.00);

-- 2) ProductDetails (1:1, PK=FK)
INSERT INTO dbo.ProductDetails (ProductId, WeightKg, DimensionsCm)
SELECT ProductId, 0.120, '10x10x2'
FROM dbo.Products
WHERE SKU = 'SKU-1002';

INSERT INTO dbo.ProductDetails (ProductId, WeightKg, DimensionsCm)
SELECT ProductId, 0.950, '45x15x5'
FROM dbo.Products
WHERE SKU = 'SKU-1003';

INSERT INTO dbo.ProductDetails (ProductId, WeightKg, DimensionsCm)
SELECT ProductId, 4.800, '62x37x7'
FROM dbo.Products
WHERE SKU = 'SKU-1004';

-- 3) Warehouses
INSERT INTO dbo.Warehouses ([Name], [Address])
VALUES
('Gothenburg Main','Göteborg, Sweden'),
('Stockholm DC','Stockholm, Sweden');

-- 4) Inventory (N:M Warehouses <-> Products)
-- Gothenburg Main
INSERT INTO dbo.Inventory (WarehouseId, ProductId, QuantityOnHand, ReorderLevel)
SELECT w.WarehouseId, p.ProductId, v.Qty, v.Reorder
FROM dbo.Warehouses w
JOIN (VALUES
('SKU-1001', 120, 30),
('SKU-1002',  60, 15),
('SKU-1003',  25,  8),
('SKU-1004',  10,  3),
('SKU-1005',  40, 10),
('SKU-1006', 150, 40)
) v(SKU, Qty, Reorder) ON 1=1
JOIN dbo.Products p ON p.SKU = v.SKU
WHERE w.[Name] = 'Gothenburg Main';

-- Stockholm DC
INSERT INTO dbo.Inventory (WarehouseId, ProductId, QuantityOnHand, ReorderLevel)
SELECT w.WarehouseId, p.ProductId, v.Qty, v.Reorder
FROM dbo.Warehouses w
JOIN (VALUES
('SKU-1002',  80, 20),
('SKU-1004',   6,  3),
('SKU-1007',  35, 10),
('SKU-1008',  50, 12),
('SKU-1001',  70, 25)
) v(SKU, Qty, Reorder) ON 1=1
JOIN dbo.Products p ON p.SKU = v.SKU
WHERE w.[Name] = 'Stockholm DC';

-- 5) Orders
INSERT INTO dbo.Orders (CustomerName, [Status])
VALUES
('Acme AB','New'),
('Nordic Retail','Picking'),
('ByteWorks','Shipped');

-- 6) OrderLines (LineNr istället för LineNo)
-- Order 1: Acme AB
INSERT INTO dbo.OrderLines (OrderId, LineNr, ProductId, Quantity, UnitPriceAtOrder)
SELECT o.OrderId, v.LineNr, p.ProductId, v.Qty, p.UnitPrice
FROM dbo.Orders o
JOIN (VALUES
(1, 'SKU-1002', 2),
(2, 'SKU-1001', 5),
(3, 'SKU-1008', 1)
) v(LineNr, SKU, Qty) ON 1=1
JOIN dbo.Products p ON p.SKU = v.SKU
WHERE o.CustomerName = 'Acme AB';

-- Order 2: Nordic Retail
INSERT INTO dbo.OrderLines (OrderId, LineNr, ProductId, Quantity, UnitPriceAtOrder)
SELECT o.OrderId, v.LineNr, p.ProductId, v.Qty, p.UnitPrice
FROM dbo.Orders o
JOIN (VALUES
(1, 'SKU-1004', 1),
(2, 'SKU-1006', 10),
(3, 'SKU-1005', 3)
) v(LineNr, SKU, Qty) ON 1=1
JOIN dbo.Products p ON p.SKU = v.SKU
WHERE o.CustomerName = 'Nordic Retail';

-- Order 3: ByteWorks
INSERT INTO dbo.OrderLines (OrderId, LineNr, ProductId, Quantity, UnitPriceAtOrder)
SELECT o.OrderId, v.LineNr, p.ProductId, v.Qty, p.UnitPrice
FROM dbo.Orders o
JOIN (VALUES
(1, 'SKU-1003', 1),
(2, 'SKU-1007', 2)
) v(LineNr, SKU, Qty) ON 1=1
JOIN dbo.Products p ON p.SKU = v.SKU
WHERE o.CustomerName = 'ByteWorks';
