USE SQLTeam2;
GO

-- UPDATE example: update product price
UPDATE dbo.Products
SET UnitPrice = UnitPrice + 10
WHERE SKU = 'SKU-1001';

-- Verify update
SELECT SKU, Name, UnitPrice
FROM dbo.Products
WHERE SKU = 'SKU-1001';

-- SELECT example: WHERE filtering + ORDER BY
SELECT SKU, Name, UnitPrice
FROM dbo.Products
WHERE UnitPrice > 50
ORDER BY UnitPrice DESC;