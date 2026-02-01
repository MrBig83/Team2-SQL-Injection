USE SQLTeam2;
GO

SELECT TOP (10)
    o.CustomerName,
    COUNT(DISTINCT o.OrderId) AS OrdersCount,
    SUM(ol.Quantity) AS ItemsSold,
    SUM(ol.Quantity * ol.UnitPriceAtOrder) AS TotalSpend
FROM dbo.Orders o
JOIN dbo.OrderLines ol ON ol.OrderId = o.OrderId
GROUP BY o.CustomerName
ORDER BY TotalSpend DESC, OrdersCount DESC;


USE SQLTeam2;
GO

SELECT
    p.SKU,
    p.[Name] AS ProductName,
    SUM(ol.Quantity) AS TotalQtySold,
    SUM(ol.Quantity * ol.UnitPriceAtOrder) AS Revenue
FROM dbo.OrderLines ol
JOIN dbo.Products p ON p.ProductId = ol.ProductId
GROUP BY p.SKU, p.[Name]
ORDER BY Revenue DESC;

USE SQLTeam2;
GO

SELECT
    w.[Name] AS WarehouseName,
    p.SKU,
    p.[Name] AS ProductName,
    i.QuantityOnHand,
    i.ReorderLevel,
    (i.ReorderLevel - i.QuantityOnHand) AS Shortage
FROM dbo.Inventory i
JOIN dbo.Warehouses w ON w.WarehouseId = i.WarehouseId
JOIN dbo.Products p ON p.ProductId = i.ProductId
WHERE i.QuantityOnHand < i.ReorderLevel
ORDER BY Shortage DESC, w.[Name], p.SKU;

USE SQLTeam2;
GO

SELECT TOP (20)
    o.CreatedAt,
    o.OrderId,
    o.CustomerName,
    o.[Status],
    ol.LineNr,
    p.SKU,
    p.[Name] AS ProductName,
    ol.Quantity,
    ol.UnitPriceAtOrder,
    (ol.Quantity * ol.UnitPriceAtOrder) AS LineTotal
FROM dbo.OrderLines ol
JOIN dbo.Orders o ON o.OrderId = ol.OrderId
JOIN dbo.Products p ON p.ProductId = ol.ProductId
ORDER BY o.CreatedAt DESC, o.OrderId DESC, ol.LineNr DESC;