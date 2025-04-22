


--  Answers to business questions using the BookStoreDB
-- 1. Top 3 Categories by Average Rating and Lowest Price
-- 2. Top 5 Books by Rating
-- ============================================

--  Using the target database where the tables are stored
USE BookStoreDB;
GO

-- ===========================================================
-- Query 1: Top 3 Categories by Avg Rating and Lowest Price
-- Objective: Identify the top 3 performing categories based on:
--   → Highest average customer rating
--   → Lower average book price (used as tie-breaker)
-- This gives insights into categories offering the best value
-- ===========================================================

SELECT TOP 3
    c.CategoryName,                    -- Category name (e.g., 'Travel', 'Business')
    AVG(b.Rating) AS AvgRating,       -- Average rating of all books in the category
    AVG(b.Price) AS AvgPrice          -- Average price of books in the category
FROM Books b
JOIN Categories c ON b.CategoryID = c.CategoryID   -- Link each book to its category
GROUP BY c.CategoryName                            -- Group results by category
ORDER BY AvgRating DESC, AvgPrice ASC;             -- Sort by highest rating, then lowest price

-- ===========================================================
--  Query 2: Top 5 Books by Rating
-- Objective: Identify the 5 highest-rated books across all categories.
-- Tie-breaker is book price — cheaper books are preferred if ratings match.
-- Useful for highlighting standout individual books
-- ===========================================================

SELECT TOP 5
    BookName,                        -- Title of the book
    Rating,                          -- Rating (converted from star text)
    Price,                           -- Book price
    StockAmount                      -- Availability status (e.g., 'In stock')
FROM Books
ORDER BY Rating DESC, Price ASC;     -- Sort by highest rating, then lowest price
