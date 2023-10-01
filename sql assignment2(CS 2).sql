-- Create the Inventory Management System Database
CREATE DATABASE InventoryManagementSystem;
USE InventoryManagementSystem;

-- Create the Inventory Table
CREATE TABLE Inventory (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255),
    QuantityInStock INT,
    UnitPrice DECIMAL(10, 2)
);

-- Insert Sample Data into Inventory Table
INSERT INTO Inventory (ProductID, ProductName, QuantityInStock, UnitPrice)
VALUES
    (1, 'Product A', 100, 10.00),
    (2, 'Product B', 150, 15.00),
    (3, 'Product C', 80, 8.50);

-- Create the Sales Table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    SaleDate DATE,
    QuantitySold INT,
    TotalPrice DECIMAL(10, 2)
);

-- Insert Sample Data into Sales Table with Unique SaleID values
INSERT INTO Sales (SaleID, ProductID, SaleDate, QuantitySold, TotalPrice)
VALUES
    (6, 1, '2023-01-22', 18, 180.00),
    (7, 2, '2023-01-25', 8, 120.00),
    (8, 3, '2023-01-28', 6, 51.00);

-- Calculate Profit Per Sale
SELECT s.SaleID, i.ProductName, s.SaleDate, s.QuantitySold, s.TotalPrice, 
       (s.TotalPrice - (s.QuantitySold * i.UnitPrice)) AS ProfitPerSale
FROM Sales s
JOIN Inventory i ON s.ProductID = i.ProductID;

-- Calculate Total Profit
SELECT SUM(s.TotalPrice - (s.QuantitySold * i.UnitPrice)) AS TotalProfit
FROM Sales s
JOIN Inventory i ON s.ProductID = i.ProductID;

-- Filtering Data (Example: Sales after January 15, 2023)
SELECT *
FROM Sales
WHERE SaleDate > '2023-01-15';

-- Sorting Data (Example: Sort sales by SaleDate in ascending order)
SELECT *
FROM Sales
ORDER BY SaleDate ASC;
