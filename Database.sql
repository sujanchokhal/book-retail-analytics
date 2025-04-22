-- ============================================
-- SQL Script: BookStoreDB Setup & Queries
-- Description: Creates and populates normalized tables from CSV,
-- then runs two business queries:
-- 1. Top 3 Categories by Avg Rating and Price
-- 2. Top 5 Books by Rating
---3. the most 5-star rated books?.
--4. priced above the overall average price
-- ============================================

-- Droping database if it already exists
DROP DATABASE IF EXISTS BookStoreDB;

-- Creating a new database
CREATE DATABASE BookStoreDB;
GO

-- Selecting the database to use
USE BookStoreDB;
GO

-- ============================================
-- Create Tables
-- ============================================

-- Categories table (normalized lookup table)
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),      -- Unique ID
    CategoryName VARCHAR(100),                     -- e.g. 'Travel', 'Fiction'
    URL VARCHAR(255)                               -- Source URL for reference
);

-- Drop temporary table if it exists
DROP TABLE IF EXISTS TempBooks;

--  Create TempBooks table (used for raw CSV import)
CREATE TABLE TempBooks (
    Name VARCHAR(255),         -- Book title
    Category VARCHAR(100),     -- Raw category name from CSV
    Price DECIMAL(10, 2),      -- Price as number
    StockAmount VARCHAR(100),  -- Stock text (e.g. 'In stock')
    Rating INT                 -- Numeric rating (converted from stars)
);

-- Final normalized Books table with foreign key to Categories
CREATE TABLE Books (
    BookID INT PRIMARY KEY IDENTITY(1,1),          -- Unique ID
    BookName VARCHAR(255),                         -- Title of the book
    CategoryID INT,                                -- Foreign key from Categories
    Price DECIMAL(10, 2),                          -- Book price
    StockAmount VARCHAR(100),                      -- Stock status
    Rating INT,                                     -- Numeric rating
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
GO

-- ============================================
-- Import Categories Data from CSV
-- ============================================

-- Drop staging table for categories (if it exists)
DROP TABLE IF EXISTS Categories_Staging;

-- Create staging table to match CSV columns
CREATE TABLE Categories_Staging (
    CategoryName VARCHAR(100),
    URL VARCHAR(255)
);

-- Load data into staging table
BULK INSERT Categories_Staging
FROM 'C:\Users\sujan\OneDrive\Desktop\Sujan_Results\categories.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    DATAFILETYPE = 'char'
);

--  Insert data into normalized Categories table
INSERT INTO Categories (CategoryName, URL)
SELECT CategoryName, URL
FROM Categories_Staging;

--  Clean up: remove staging table
DROP TABLE Categories_Staging;

-- ============================================
-- Import Books Data from CSV
-- ============================================

-- 🧹 Clear previous data (if rerunning)
TRUNCATE TABLE TempBooks;

-- Drop and recreate TempBooks with raw string columns
DROP TABLE IF EXISTS TempBooks;

--  Recreate TempBooks to import raw string values (before conversion)
CREATE TABLE TempBooks (
    BookName VARCHAR(255),
    CategoryName VARCHAR(100),
    Price VARCHAR(50),           -- Temporarily store as text
    StockAmount VARCHAR(100),
    Rating VARCHAR(50)           -- Temporarily store as text
);

-- Load raw book data from CSV
BULK INSERT TempBooks
FROM 'C:\Users\sujan\OneDrive\Desktop\Sujan_Results\books.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    DATAFILETYPE = 'char'
);

--  Preview imported data
SELECT TOP 10 * FROM TempBooks;

--  Insert cleaned data into final Books table
INSERT INTO Books (BookName, CategoryID, Price, StockAmount, Rating)
SELECT
    T.BookName,
    C.CategoryID,
    TRY_CAST(T.Price AS DECIMAL(10,2)),
    T.StockAmount,
    TRY_CAST(T.Rating AS INT)
FROM TempBooks T
JOIN Categories C ON T.CategoryName = C.CategoryName
WHERE TRY_CAST(T.Price AS DECIMAL(10,2)) IS NOT NULL
  AND TRY_CAST(T.Rating AS INT) IS NOT NULL;

--  Verify data in Books table
SELECT TOP 10 * FROM Books;

-- ============================================
--  Business Queries
-- ============================================

-- Query 1: Top 3 categories with highest average rating and lowest average price
SELECT TOP 3
    c.CategoryName,
    AVG(b.Rating) AS AvgRating,
    AVG(b.Price) AS AvgPrice
FROM Books b
JOIN Categories c ON b.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY AvgRating DESC, AvgPrice ASC;

--  Query 2: Top 5 books by rating (with price and stock info)
SELECT TOP 5
    BookName,
    Rating,
    Price,
    StockAmount
FROM Books
ORDER BY Rating DESC, Price ASC;

--Which categories have the most 5-star rated books?
SELECT 
    c.CategoryName,
    COUNT(*) AS FiveStarBookCount
FROM Books b
JOIN Categories c ON b.CategoryID = c.CategoryID
WHERE b.Rating = 5
GROUP BY c.CategoryName
ORDER BY FiveStarBookCount DESC;

----Which books are priced above the overall average price?
SELECT 
    BookName,
    Price,
    Rating
FROM Books
WHERE Price > (
    SELECT AVG(Price) FROM Books
)
ORDER BY Price DESC;

