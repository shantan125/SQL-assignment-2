-- Create the RawSale table
CREATE TABLE RawSale (
    Product VARCHAR(255),
    Region VARCHAR(255),
    Sales DECIMAL(10, 2)
);
-- Insert data manually into the RawSale table
INSERT INTO RawSale (Product, Region, Sales) VALUES
('Product A', 'Region 1', 10000),
('Product B', 'Region 1', 7500),
('Product A', 'Region 2', 8500),
('Product B', 'Region 2', 9200),
('Product C', 'Region 1', 6200),
('Product C', 'Region 2', 7800),
('Product A', 'Region 3', 10500),
('Product B', 'Region 3', 9800),
('Product C', 'Region 3', 7400),
('Product D', 'Region 1', 9500),
('Product D', 'Region 2', 8700),
('Product D', 'Region 3', 10200),
('Product E', 'Region 1', 8900),
('Product E', 'Region 2', 8000),
('Product E', 'Region 3', 9600),
('Product F', 'Region 1', 7200),
('Product F', 'Region 2', 6800),
('Product F', 'Region 3', 8900),
('Product G', 'Region 1', 8100),
('Product G', 'Region 2', 9200),
('Product G', 'Region 3', 8300),
('Product H', 'Region 1', 10500),
('Product H', 'Region 2', 9800),
('Product H', 'Region 3', 11700),
('Product I', 'Region 1', 6500),
('Product I', 'Region 2', 7100),
('Product I', 'Region 3', 6200);
SET SQL_SAFE_UPDATES = 0; -- Disable safe update mode

-- Create a temporary table to store rows to be deleted
CREATE TEMPORARY TABLE TempToDelete AS
SELECT r1.Product, r1.Region, r1.Sales
FROM RawSale r1
JOIN (
    SELECT Product, Region, MAX(Sales) AS MaxSales
    FROM RawSale
    GROUP BY Product, Region
) r2
ON r1.Product = r2.Product AND r1.Region = r2.Region AND r1.Sales < r2.MaxSales
LIMIT 100; -- Adjust the limit as needed

-- Delete rows from the main table based on the data in the temporary table
DELETE FROM RawSale
WHERE (Product, Region, Sales) IN (
    SELECT Product, Region, Sales
    FROM TempToDelete
);

-- Drop the temporary table
DROP TEMPORARY TABLE TempToDelete;

SET SQL_SAFE_UPDATES = 1; -- Re-enable safe update mode
CREATE TABLE SalesSummary AS
SELECT
    Product,
    Region,
    SUM(Sales) AS TotalSales
FROM RawSale
GROUP BY Product, Region;
-- Data analysis
SELECT
    Product,
    Region,
    TotalSales
FROM (
    SELECT
        Product,
        Region,
        TotalSales,
        ROW_NUMBER() OVER (PARTITION BY Region ORDER BY TotalSales DESC) AS RegionRank,
        ROW_NUMBER() OVER (PARTITION BY Product ORDER BY TotalSales DESC) AS ProductRank
    FROM SalesSummary
) ranked_data
WHERE RegionRank = 1 OR ProductRank = 1;
-- recomendations
SELECT
    Product,
    Region,
    TotalSales
FROM SalesSummary
ORDER BY TotalSales DESC
LIMIT 1;

