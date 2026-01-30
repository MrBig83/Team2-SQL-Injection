USE SQLTeam2;
GO

/* 
08_queries_joins.sql
Minst 8 queries:
- 4 med JOIN
- 2 med GROUP BY + aggregat
- 1 med WHERE + ORDER BY
- 1 rapportfråga
*/

------------------------------------------------------------
-- Q1) (JOIN) Orderrader med produktnamn per order
------------------------------------------------------------
SELECT
    o.OrderId,
    o.CustomerName,
    o.[Status],
    o.CreatedAt,
    ol.LineNr,
    p.SKU,
    p.[Name] AS ProductName,
    ol.Quantity,
    ol.UnitPriceAtOrder,
    (ol.Quantity * ol.UnitPriceAtOrder) AS LineTotal
FROM dbo.Orders o
JOIN dbo.OrderLines ol ON ol.OrderId = o.OrderId
JOIN dbo.Products p ON p.ProductId = ol.ProductId
ORDER BY o.OrderId, ol.LineNr;
GO


------------------------------------------------------------
-- Q2) (GROUP BY + JOIN) Ordertotal per order (summering)
------------------------------------------------------------
SELECT
    o.OrderId,
    o.CustomerName,
    o.[Status],
    SUM(ol.Quantity * ol.UnitPriceAtOrder) AS OrderTotal
FROM dbo.Orders o
JOIN dbo.OrderLines ol ON ol.OrderId = o.OrderId
GROUP BY o.OrderId, o.CustomerName, o.[Status]
ORDER BY OrderTotal DESC;
GO


------------------------------------------------------------
-- Q3) (RAPPORT 1) Top customers: kunder med högst total ordervärde
-- (GROUP BY + JOIN + ORDER BY)
------------------------------------------------------------
SELECT
    o.CustomerName,
    COUNT(DISTINCT o.OrderId) AS OrdersCount,
    SUM(ol.Quantity * ol.UnitPriceAtOrder) AS TotalSpend
FROM dbo.Orders o
JOIN dbo.OrderLines ol ON ol.OrderId = o.OrderId
GROUP BY o.CustomerName
ORDER BY TotalSpend DESC;
GO


------------------------------------------------------------
-- Q4) (JOIN) Lager per produkt och warehouse
------------------------------------------------------------
SELECT
    w.[Name] AS WarehouseName,
    p.SKU,
    p.[Name] AS ProductName,
    i.QuantityOnHand,
    i.ReorderLevel
FROM dbo.Inventory i
JOIN dbo.Warehouses w ON w.WarehouseId = i.WarehouseId
JOIN dbo.Products p ON p.ProductId = i.ProductId
ORDER BY w.[Name], p.SKU;
GO


------------------------------------------------------------
-- Q5) (WHERE + ORDER BY + JOIN) "At risk": produkter under reorder level
-- (lagerstatus-rapport)
------------------------------------------------------------
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
GO


------------------------------------------------------------
-- Q6) (JOIN) Produkter + 1:1 ProductDetails (visa detaljer när de finns)
------------------------------------------------------------
SELECT
    p.ProductId,
    p.SKU,
    p.[Name],
    p.UnitPrice,
    pd.WeightKg,
    pd.DimensionsCm,
    p.CreatedAt
FROM dbo.Products p
LEFT JOIN dbo.ProductDetails pd ON pd.ProductId = p.ProductId
ORDER BY p.ProductId;
GO


------------------------------------------------------------
-- Q7) (GROUP BY + JOIN) Försäljning per produkt (antal & intäkt)
-- Bra som "summary per kategori" fast per produkt
------------------------------------------------------------
SELECT
    p.SKU,
    p.[Name] AS ProductName,
    SUM(ol.Quantity) AS TotalQtySold,
    SUM(ol.Quantity * ol.UnitPriceAtOrder) AS Revenue
FROM dbo.OrderLines ol
JOIN dbo.Products p ON p.ProductId = ol.ProductId
GROUP BY p.SKU, p.[Name]
ORDER BY Revenue DESC;
GO


------------------------------------------------------------
-- Q8) (JOIN + WHERE) Ordrar i ett visst statusläge (t.ex. 'Picking')
------------------------------------------------------------
SELECT
    o.OrderId,
    o.CustomerName,
    o.[Status],
    o.CreatedAt,
    SUM(ol.Quantity * ol.UnitPriceAtOrder) AS OrderTotal
FROM dbo.Orders o
JOIN dbo.OrderLines ol ON ol.OrderId = o.OrderId
WHERE o.[Status] = 'Picking'
GROUP BY o.OrderId, o.CustomerName, o.[Status], o.CreatedAt
ORDER BY o.CreatedAt DESC;
GO


------------------------------------------------------------
-- Q9) (RAPPORT 2) Latest activity feed: senaste 20 orderraderna
-- (JOIN + ORDER BY)
------------------------------------------------------------
SELECT TOP (20)
    o.OrderId,
    o.CustomerName,
    o.[Status],
    o.CreatedAt,
    ol.LineNr,
    p.SKU,
    p.[Name] AS ProductName,
    ol.Quantity,
    ol.UnitPriceAtOrder
FROM dbo.OrderLines ol
JOIN dbo.Orders o ON o.OrderId = ol.OrderId
JOIN dbo.Products p ON p.ProductId = ol.ProductId
ORDER BY o.CreatedAt DESC, o.OrderId DESC, ol.LineNr DESC;
GO


------------------------------------------------------------
-- Q10) (JOIN) "Stock coverage": vilka produkter saknar lager i någon warehouse?
-- Visar även produkter utan inventory-rader (LEFT JOIN)
------------------------------------------------------------
SELECT
    p.SKU,
    p.[Name] AS ProductName,
    w.[Name] AS WarehouseName,
    ISNULL(i.QuantityOnHand, 0) AS QuantityOnHand
FROM dbo.Products p
CROSS JOIN dbo.Warehouses w
LEFT JOIN dbo.Inventory i
    ON i.ProductId = p.ProductId
   AND i.WarehouseId = w.WarehouseId
ORDER BY p.SKU, w.[Name];
GO