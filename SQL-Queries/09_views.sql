USE SQLTeam2;
GO

------------------------------------------------------------
-- 09_views.sql
-- Innehåller:
-- 1 public view
-- 1 report view
------------------------------------------------------------

-- Public view (döljer känsliga kolumner)
CREATE OR ALTER VIEW dbo.vw_PublicProducts
AS
SELECT
    ProductId,
    SKU,
    [Name],
    CreatedAt
FROM dbo.Products;
GO


-- Report view (används av Console App)
CREATE OR ALTER VIEW dbo.vw_OrderSummary
AS
SELECT
    o.CustomerName,
    COUNT(DISTINCT o.OrderId) AS OrdersCount,
    SUM(ol.Quantity * ol.UnitPriceAtOrder) AS TotalSpend
FROM dbo.Orders o
JOIN dbo.OrderLines ol ON ol.OrderId = o.OrderId
GROUP BY o.CustomerName;
GO