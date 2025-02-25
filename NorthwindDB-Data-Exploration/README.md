**Northwind Database Analysis**

Overview

This project involves analyzing the Northwind database, a sample database that represents a fictional company called "Northwind Traders." The database contains data related to customers, orders, products, suppliers, employees, and more. The goal of this project is to explore the database, perform data analysis, and derive insights using SQL queries.

**Database Schema**

The Northwind database includes the following key tables:

    Customers: Information about customers (e.g., CustomerID, CompanyName, ContactName).

    Orders: Details of orders placed by customers (e.g., OrderID, CustomerID, OrderDate).

    Order Details: Line items for each order (e.g., OrderID, ProductID, Quantity, UnitPrice).

    Products: Information about products (e.g., ProductID, ProductName, SupplierID, CategoryID).

    Suppliers: Details of suppliers (e.g., SupplierID, CompanyName, ContactName).

    Employees: Information about employees (e.g., EmployeeID, FirstName, LastName, Title).

    Categories: Product categories (e.g., CategoryID, CategoryName).

    Shippers: Shipping companies used by Northwind Traders (e.g., ShipperID, CompanyName).

**Database Diagram: **Northwind_db_diagram.png

**SQL Queries**

The SQL queries used for the analysis are stored in the Northwind_Exploration_sql.sql file. These queries include:

    Basic data exploration (e.g., counting rows, checking for missing values).

    Analysis of sales trends over time.

    Identification of top-selling products and customers.

    Calculation of employee performance metrics.

    Exploration of supplier and product relationships.

How to Use

    Download the Northwind Database:

        The Northwind database can be downloaded from Microsoft's GitHub repository.

        Alternatively, you can find SQL scripts to create and populate the database [Northwind-DB.sql file].

    Set Up the Database:

        Import the database into your preferred SQL database management system (e.g., MySQL, PostgreSQL, SQL Server).

    Run the Queries:

        Execute the SQL queries from the Northwind_Exploration_sql.sql file to reproduce the analysis.

    Explore Insights:

        Use the results of the queries to understand trends and patterns in the data.

Key Insights

    Top-Selling Products

    Most Valuable Customers

    Employee Performance

    Sales Trends Over Time

Tools Used

    SQL: For data exploration and analysis.

    Database Management System:  PostgreSQL.
