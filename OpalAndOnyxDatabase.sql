-- Opal & Onyx E-Commerce Website - Maya Thomas-Fubler
DROP DATABASE IF EXISTS OpalAndOnyx;
CREATE DATABASE OpalAndOnyx;
USE OpalAndOnyx; 

CREATE TABLE Category (
  CategoryID INT AUTO_INCREMENT PRIMARY KEY,
  CategoryName VARCHAR(50)
);

CREATE TABLE Collections (
  CollectionID INT AUTO_INCREMENT PRIMARY KEY,
  CollectionName VARCHAR(100),
  StartDate DATE,
  EndDate DATE
);

CREATE TABLE Item (
  ItemID INT AUTO_INCREMENT PRIMARY KEY,
  ItemName VARCHAR(50),
  StockQuantity INT,
  SKU VARCHAR(50) ,
  Price DECIMAL(10,2),
  Color VARCHAR(100),
  ImageURL VARCHAR(100),
  CategoryID INT,
  CollectionID INT,
  FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
  FOREIGN KEY (CollectionID) REFERENCES Collections(CollectionID)
);

CREATE TABLE CustomerAccount (
  CustomerID INT AUTO_INCREMENT PRIMARY KEY,
  FirstName VARCHAR(100),
  LastName VARCHAR(100),
  Email VARCHAR(100)
);

CREATE TABLE Orders (
  OrderID INT AUTO_INCREMENT PRIMARY KEY,
  OrderTotal DECIMAL(10,2),
  OrderDate DATE,
  OrderStatus VARCHAR(50),
  ShippingMethod VARCHAR(50),
  PaymentMethod VARCHAR(50),
  CustomerID INT,
  FOREIGN KEY (CustomerID) REFERENCES CustomerAccount(CustomerID)
);

CREATE TABLE OrderItem (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ItemID INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ItemID) References Item(ItemID),
    Quantity INT,
    UnitPrice DECIMAL(10,2)
)

INSERT INTO Category (CategoryName) 
VALUES ('Necklaces'), 
       ('Bracelets'), 
       ('Rings');


INSERT INTO Collections (CollectionName, StartDate, EndDate) 
VALUES ('Spring 2025', '2025-03-01', '2025-05-31'), 
       ('Summer 2025', '2025-06-01', '2025-08-31');


INSERT INTO Item (ItemName, StockQuantity, SKU, Price, Color, ImageURL, CategoryID, CollectionID)
VALUES ('Midnight Necklace', 50, 'SKU12345', 75.99, 'Gunmetal/Purple', 'https://example.com/midnight_necklace.jpg', 1, 1),
       ('Twilight Raven Bracelet', 30, 'SKU12346', 49.99, 'Silver/Black', 'https://example.com/twilight_raven_earrings.jpg', 2, 1),
       ('Vampire Moon Ring', 100, 'SKU22345', 29.99, 'Silver/Red', 'https://example.com/vampire_moon_ring.jpg', 3, 2),
       ('Wonderland Necklace', 75, 'SKU32345', 59.99, 'Silver/Blue', 'https://example.com/wonderland_necklace.jpg', 1, 2);

INSERT INTO CustomerAccount (FirstName, LastName, Email) 
VALUES ('John', 'Doe', 'johndoe@example.com'), 
       ('Jane', 'Smith', 'janesmith@example.com');

INSERT INTO Orders (OrderTotal, OrderDate, OrderStatus, ShippingMethod, PaymentMethod, CustomerID) 
VALUES (259.97, '2025-04-01', 'Shipped', 'Standard', 'Credit Card', 1),
       (89.98, '2025-04-02', 'Processing', 'Express', 'PayPal', 2);

--SHOW TABLES;

--SHOW COLUMNS FROM Category;
--SHOW COLUMNS FROM Collection;
--SHOW COLUMNS FROM Item;
--SHOW COLUMNS FROM CustomerAccount;
--SHOW COLUMNS FROM Orders;

-- Milestone #2: Basic SQL Queries
--Select the item table
SELECT * FROM Item;

-- Update the name of the Customer Account with CustomerID = 1
UPDATE CustomerAccount
SET FirstName = 'Maya',
    LastName = 'Thomas-Fubler'
WHERE CustomerID = 1; 

-- Insert 'Earrings' and 'Waist Chains' categories
INSERT INTO Category(CategoryName) 
VALUES ('Earrings'), 
       ('Waist Chains'); 

-- Delete 'Waist Chains' category
DELETE FROM Category
WHERE CategoryName = 'Waist Chains';

-- Necklaces only
SELECT ItemName, Price, Color
FROM Item
WHERE CategoryID = 1;


-- Milestone #3: Advanced SQL Queries

-- View Orders with Items in Detail
SELECT Orders.OrderID, CustomerAccount.FirstName, CustomerAccount.LastName, Item.ItemName, OrderItem.Quantity, OrderItem.UnitPrice, (OrderItem.Quantity * OrderItem.UnitPrice) AS OrderTotal
FROM Orders
JOIN CustomerAccount ON Orders.CustomerID = CustomerAccount.CustomerID
JOIN OrderItem ON Orders.OrderID = OrderItem.OrderID
JOIN Item ON OrderItem.ItemID = Item.OrderItemID
ORDER BY Orders.OrderDate DESC; 

-- Items in Each Collection
SELECT Collections.CollectionName, Item.ItemName, Item.ImageURL
FROM Collections 
JOIN Item ON Collections.CollectionID = Item.CollectionID
ORDER BY CollectionName;

-- Stock Quantity of Each Category, Least to Highest
SELECT Category.CategoryName, SUM(Item.StockQuantity) AS CategoryStock
FROM Category
JOIN Item ON Category.CategoryID = Item.CategoryID
GROUP BY Category.CategoryName
ORDER BY CategoryStock ASC; 

-- Most Ordered Item
SELECT Item.ItemName, SUM(OrderItem.Quantity) AS TotalOrdered
FROM OrderItem
JOIN Item ON OrderItem.ItemID = Item.ItemID
GROUP BY Item.ItemName
ORDER BY TotalOrdered DESC
LIMIT 1;

-- Top 5 Customers - Ordered by amount sent
SELECT CustomerAccount.FirstName, CustomerAccount.LastName, SUM(OrderItem.Quantity * OrderItem.UnitPrice) As TotalSpent
FROM CustomerAccount
JOIN Orders ON CustomerAccount.CustomerID = Orders.CustomerID
JOIN OrderItem ON Orders.OrderID = OrderItem.OrderID
GROUP BY CustomerAccount.FirstName, CustomerAccount.LastName
ORDER BY TotalSpent DESC
LIMIT 5;
