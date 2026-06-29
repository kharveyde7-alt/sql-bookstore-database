/*
=========================================================

Project: SQL Bookstore Database

Author: Malik
Date: June 2026

Description:
This project contains SQL queries demonstrating core
database concepts using a bookstore database.

The queries showcase common SQL techniques used in
business reporting and data analysis.

Skills Demonstrated:
• INNER JOIN
• LEFT JOIN
• RIGHT JOIN
• CROSS JOIN
• UNION
• Subqueries
• GROUP BY
• HAVING
• Aggregate Functions
• Business Reporting

Concepts Covered:
• Data Retrieval
• Data Aggregation
• Relational Database Design
• Business Reporting
• Query Optimization Concepts

=========================================================
*/

-- =====================================================
-- Customers Who Ordered More Than One Unique Book
--
-- Purpose:
-- Find customers who placed an order containing more
-- than one different book.
--
-- Explanation:
-- The subquery groups each order and counts the number
-- of unique books purchased. The outer query returns
-- the names of customers whose orders contain multiple
-- unique books.
-- =====================================================

SELECT CustomerName
FROM Orders
WHERE OrderID IN (
    SELECT OrderID
    FROM OrderDetails
    GROUP BY OrderID
    HAVING COUNT(DISTINCT BookID) > 1
);

-- =====================================================
-- Total Books Purchased by Each Customer
--
-- Purpose:
-- Calculate the total quantity of books purchased by
-- each customer.
--
-- Explanation:
-- Orders are joined with OrderDetails to access the
-- quantity purchased. SUM() calculates the total
-- number of books, and ORDER BY sorts customers from
-- the highest purchaser to the lowest.
-- =====================================================

SELECT
    o.CustomerName,
    SUM(od.Quantity) AS TotalBooks
FROM Orders o
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
GROUP BY o.CustomerName
ORDER BY TotalBooks DESC;

-- =====================================================
-- Books That Have Never Been Ordered
--
-- Purpose:
-- Display books that have never been purchased.
--
-- Explanation:
-- LEFT JOIN keeps every book in the Books table.
-- Books without a matching record in OrderDetails
-- will contain NULL values and therefore have never
-- been ordered.
-- =====================================================

SELECT
    b.Title,
    CONCAT(a.FirstName, ' ', a.LastName) AS Author
FROM Books b
JOIN Authors a
    ON b.AuthorID = a.AuthorID
LEFT JOIN OrderDetails od
    ON b.BookID = od.BookID
WHERE od.BookID IS NULL;

-- =====================================================
-- Books Priced Above the Average Price
--
-- Purpose:
-- Find books that cost more than the average price
-- of all books.
--
-- Explanation:
-- The subquery calculates the average book price.
-- The outer query returns books whose price exceeds
-- that average.
-- =====================================================

SELECT
    Title,
    Price
FROM Books
WHERE Price >
(
    SELECT AVG(Price)
    FROM Books
);

-- =====================================================
-- Total Sales for Each Order
--
-- Purpose:
-- Calculate the total sales value for every order.
--
-- Explanation:
-- Orders, OrderDetails, and Books are joined together.
-- Quantity is multiplied by Price to calculate the
-- value of each item purchased. SUM() calculates the
-- total sales amount for each order.
-- =====================================================

SELECT
    o.OrderID,
    o.CustomerName,
    SUM(od.Quantity * b.Price) AS TotalSales
FROM Orders o
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
JOIN Books b
    ON od.BookID = b.BookID
GROUP BY o.OrderID, o.CustomerName;

-- =====================================================
-- Books Sold with Their Authors
--
-- Purpose:
-- Display every book that has been sold along with
-- its author.
--
-- Explanation:
-- Multiple INNER JOIN operations connect the Sales,
-- Books, BookAuthors, and Authors tables to retrieve
-- both the book title and author name.
-- =====================================================

SELECT
    b.BookName,
    a.AuthorName
FROM Sales s
INNER JOIN Books b
    ON s.BookID = b.BookID
INNER JOIN BookAuthors ba
    ON b.BookID = ba.BookID
INNER JOIN Authors a
    ON ba.AuthorID = a.AuthorID;

-- =====================================================
-- All Books and Their Authors
--
-- Purpose:
-- Display every book and its corresponding author.
--
-- Explanation:
-- LEFT JOIN ensures all books are included, even if
-- a book has never been sold.
-- =====================================================

SELECT
    b.BookName,
    a.AuthorName
FROM Books b
LEFT JOIN BookAuthors ba
    ON b.BookID = ba.BookID
LEFT JOIN Authors a
    ON ba.AuthorID = a.AuthorID;

-- =====================================================
-- All Authors and Their Books
--
-- Purpose:
-- Display every author along with any books they have
-- written.
--
-- Explanation:
-- RIGHT JOIN ensures every author appears in the
-- results, including authors who currently have no
-- books linked to them.
-- =====================================================

SELECT
    b.BookName,
    a.AuthorName
FROM Books b
RIGHT JOIN BookAuthors ba
    ON b.BookID = ba.BookID
RIGHT JOIN Authors a
    ON ba.AuthorID = a.AuthorID;

-- =====================================================
-- Every Customer and Every Book Combination
--
-- Purpose:
-- Generate every possible combination of customers
-- and books.
--
-- Explanation:
-- CROSS JOIN produces the Cartesian product between
-- the Customers and Books tables.
-- =====================================================

SELECT
    c.CustomerName,
    b.BookName
FROM Customers c
CROSS JOIN Books b;

-- =====================================================
-- Combined Customer and Author List
--
-- Purpose:
-- Combine customer names and author names into a
-- single list.
--
-- Explanation:
-- UNION merges the results from two SELECT statements
-- while removing duplicate values.
-- =====================================================

SELECT CustomerName AS Name
FROM Customers

UNION

SELECT AuthorName
FROM Authors;

-- =====================================================
-- Customers Who Purchased George Orwell Books
--
-- Purpose:
-- Identify customers who purchased books written by
-- George Orwell.
--
-- Explanation:
-- Multiple INNER JOIN operations connect customers,
-- sales, books, and authors. The WHERE clause filters
-- results to books written by George Orwell.
-- =====================================================

SELECT DISTINCT
    c.CustomerName
FROM Customers c
INNER JOIN Sales s
    ON c.CustomerID = s.CustomerID
INNER JOIN BookAuthors ba
    ON s.BookID = ba.BookID
INNER JOIN Authors a
    ON ba.AuthorID = a.AuthorID
WHERE a.AuthorName = 'George Orwell';

-- =====================================================
-- Books That Have Never Been Sold
--
-- Purpose:
-- Display books that have never been purchased.
--
-- Explanation:
-- The subquery retrieves all BookIDs found in the
-- Sales table. The outer query excludes those IDs,
-- leaving only books that have never been sold.
-- =====================================================

SELECT
    BookName
FROM Books
WHERE BookID NOT IN (
    SELECT BookID
    FROM Sales
);
