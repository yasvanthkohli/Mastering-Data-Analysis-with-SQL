The compilation of projects and challenges encompasses a diverse collection centered around SQL and data analysis. Curated to foster learning, provide practical experience, and unearth valuable insights from past data.

Built with

SQL Databases: 
- MySQL
- PostgreSQL

Tools:
- MySQL Workbench
- pgAdmin
  
Table of Contents
- Connecting to the Database
- Retrieving Data
- Filtering Data
- Sorting Data
- Aggregating Data
- Joining Tables
- Grouping and Summarizing Data
- Subqueries
- Working with Dates and Times
- Analytical Functions
- Advanced Analysis Techniques
- Exporting Data

## World Happiness Report Data Exploration
Project Description:

In this project, I will explore the World Happiness Report dataset using basic SQL querying and data exploration techniques. The World Happiness Report is an annual publication that ranks countries based on their happiness levels and factors contributing to happiness.

The dataset contains information about various countries and their happiness scores along with several socio-economic and demographic indicators. The goal of this project is to gain insights from the dataset by formulating SQL queries and performing data exploration.

Tasks:

Database Setup: Create a database to store the World Happiness Report data.

Data Import: Import the dataset into appropriate tables within the database.

Basic SQL Queries: Write SQL queries to gain insights into the factors influencing happiness levels across countries.

Data Exploration: Perform exploratory analysis by writing SQL queries to answer specific questions and gain insights from the dataset.


## Supermarket Sales Analysis

1. Introduction

   This project aims to perform an analysis of supermarket sales data using SQL. The dataset contains information about various sales transactions, including invoice details, branch information, customer demographics, product details, pricing, taxes, payment information, and customer ratings. The project will focus on data cleaning and preprocessing, as well as data filtering and aggregation techniques to derive meaningful insights from the dataset.


2. Dataset Overview
  
   The dataset consists of the following columns
- Invoice_ID: Unique identifier for each sales transaction.
- Branch: Branch code where the sale occurred.
- City: City where the sale occurred.
- Customer_type: Type of customer (e.g., Member, Normal).
- Gender: Gender of the customer.
- Product_line: Category of the product sold.
- Unit_price: Price of a single unit of the product.
- Quantity: Number of units sold.
- Tax: Tax amount applied to the sale.
- Total: Total amount of the sale including tax.
- Date: Date of the sale.
- Time: Time of the sale.
- Payment: Payment method used (e.g., Cash, Credit Card).
- cogs: Cost of goods sold.
- gross_margin_percentage: Gross margin percentage.
- gross_income: Gross income generated from the sale.
- Rating: Customer satisfaction rating for the sale.




  
3. Data Cleaning and Preprocessing

 
   Data cleaning and preprocessing are essential steps to ensure the quality and consistency of the dataset. In this project, the following data 
   cleaning and preprocessing techniques were applied.
- Handling missing values: Missing values in any of the columns were identified and appropriate actions, such as imputation or removal, were taken.
- Removing duplicates: Duplicate records, if any, were identified and removed to avoid redundant data.
- Data type conversion: The data types of certain columns were adjusted to match the nature of the data they represent, such as converting date and time columns into the appropriate data types.
- Data normalization: Certain columns were normalized to ensure consistency and standardization across the dataset, such as converting the city names to a standardized format.
- Handling outliers: Outliers in numeric columns were identified and treated using suitable techniques, such as capping or excluding them from analysis.
  




4. Data Filtering and Aggregation

   
   Data filtering and aggregation techniques are used to extract specific subsets of data and derive meaningful insights from them. In this project, the 
   following techniques were applied.
- Filtering by date: The dataset was filtered based on a specific date range to focus on sales patterns during certain periods.
- Filtering by branch or city: The dataset was filtered to analyze sales performance at specific branches or cities.
-	Aggregating sales data: Various aggregation functions, such as SUM, COUNT, AVERAGE, and MAX, were applied to calculate key metrics like total sales, average unit price, total tax, and gross income.
-	Grouping and sorting: The dataset was grouped by specific columns (e.g., product line, customer type) and sorted based on certain criteria to identify trends and patterns.

