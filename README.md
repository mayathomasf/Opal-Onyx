# Opal-Onyx
Database and GUI for my fictional jewelry store, Opal &amp; Onyx. 

Technical Documentation - Opal & Onyx


Project Overview

This project is a GUI desktop application made for Opal & Onyx, a jewelry e-commerce
database created by me.This application was made using Python, Tkinter for the user interface, and MySQLWorkbench to create the database on the backend. The application currently allows
users to: View all jewelry items for sale, Select and view items by category, Browse collections and their associated items, Add items to a shopping cart.

To use this application, a computer needs Python and MySQL to be installed and running.

Database Schema 

The OpalAndOnyx Database is designed to resemble a jewlery ecommerce website.


Tables
It contains six tables essential to modelling this:
Category - Stores the categories of jewlery categories (e.g. Necklace, Rings), Collections - Stores the names of seasonal collections (e.g. Spring 2025), Item - Stores each jewlery item, including which category and collection they belong to, CustomerAccount - Stores name, email and order history of each customer, Orders - Stores order details as linked to each customer, OrderItem - Stores individual items within each order, including order quantity and unit
price information.

Entity Relationships

Item belongs to one category and one collection - both many to one relationships.
Order belongs to one CustomerAccount - many to one relationship.
OrderItem links an Order and Item - which is a many to many relationship.

Schema Design

Primary Keys:
Every table uses an AUTO_INCREMENT primary key (e.g. CategoryID, CollectionID, ItemID).

Foreign Keys:
Item.CategoryID - Category.CategoryID,
Item.CollectionID - Collections.CollectionID,
Orders.CustomerID - CustomerAccount.CustomerID,
OrderItem.OrderID - Orders.OrderID,
OrderItem.ItemID - Item.ItemID

Data Types:
VARCHAR - Used for text (e.g. names, emails)
DECIMAL(10,2) - Used for prices
DATE - Used for collection and order dates


Future Enhancements

The next enhancement would be to make checking out from the shopping cart possible
for the user, as well as enabling them to view their order history.
This would make use of the other tables in my database, such as Orders, OrderItem and
CustomerAccount.

References

Due to my lack of GUI coding knowledge at time of project, ChatGPT was used to help me create and customize the GUI for this database, however, the SQL code is my original work.


User Guide


Application Features

Collections : View all collections and items listed under them.
Select Category: Choose Category to search.
Display Items by Category: View all items from Category of choice.
Shop All: View all items and ability to add items to shopping cart.
View Cart: View items currently in shopping cart.

How It Works
1. Startup: App is launched and user sees home page and welcome message.
2. Navigation options: Collection, Select & Display Items by Category, Shop All (& Add items to cart), View Cart
3. Data Flow: All item, collection and category data is fetched from MySQL.
4. Cart Management: Items added to the shopping cart by the user are stores in a global
array (cart [ ]).

I used Python IDLE and MySQL Workbench to run this program.
