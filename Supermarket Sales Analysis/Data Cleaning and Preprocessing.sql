-- Data cleaning and preprocessing on the "Sales" table --

USE Supermarket_sales;

SELECT invoice_id 
FROM Sales;

 /* Checking NULL values in each column of the "Sales" table */
 -- Using CASE statement to check each column for NULL values and sums up the counts --
SELECT
  SUM(CASE WHEN invoice_id IS NULL THEN 1 ELSE 0 END) AS invoice_id_null_count,
  SUM(CASE WHEN branch IS NULL THEN 1 ELSE 0 END) AS branch_null_count,
  SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS city_null_count,
  SUM(CASE WHEN customer_type IS NULL THEN 1 ELSE 0 END) AS customer_type_null_count,
  SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS gender_null_count,
  SUM(CASE WHEN product_line IS NULL THEN 1 ELSE 0 END) AS product_line_null_count,
  SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS unit_price_null_count,
  SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS quantity_null_count,
  SUM(CASE WHEN tax IS NULL THEN 1 ELSE 0 END) AS tax_null_count,
  SUM(CASE WHEN total IS NULL THEN 1 ELSE 0 END) AS total_null_count,
  SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS date_null_count,
  SUM(CASE WHEN time IS NULL THEN 1 ELSE 0 END) AS time_null_count,
  SUM(CASE WHEN payment IS NULL THEN 1 ELSE 0 END) AS payment_null_count,
  SUM(CASE WHEN cogs IS NULL THEN 1 ELSE 0 END) AS cogs_null_count,
  SUM(CASE WHEN gross_margin_percentage IS NULL THEN 1 ELSE 0 END) AS gross_margin_percentage_null_count,
  SUM(CASE WHEN gross_income IS NULL THEN 1 ELSE 0 END) AS gross_income_null_count,
  SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS rating_null_count
FROM Sales;


/* Checking unique invoice_id in sales table */
SELECT COUNT(DISTINCT invoice_id) AS distinct_invoice_count
FROM sales;

/* Removing duplicate records from invoice_id column */
-- Using subquery to identify the duplicate "invoice_id" values in the "sales" table --
DELETE FROM sales
WHERE invoice_id IN (
  SELECT invoice_id
  FROM (
    SELECT invoice_id
    FROM sales
    GROUP BY invoice_id
    HAVING COUNT(*) > 1
  ) AS duplicates
);

/* Removing NULL values from tax column */
DELETE FROM sales
WHERE Tax IS NULL; -- deletes all rows from the table where a specific column contains NULL values


/* Deleting rows with specific values in a column */
-- deletes rows from a table where a specific column has a particular value --
DELETE FROM sales
WHERE Rating = '4.1' AND invoice_id = '378-24-2715' ;

/* Updating inconsistent or incorrect values */
Select * FROM Sales
WHERE invoice_id = '234-65-2137';
UPDATE Sales
SET payment = 'Credit Card'
WHERE invoice_id = '234-65-2137';

/* Converting a column to uppercase or lowercase */
UPDATE sales
SET branch = LOWER(branch);
UPDATE sales
SET branch = UPPER(branch);

/* Replacing specific values in a column */
UPDATE sales
SET gross_income = REPLACE(gross_income, '8.226', '8.982');

/* Updating values based on a substring match */
UPDATE Sales
SET product_line = 'Sports accessories'
WHERE product_line LIKE 'Sports and travel';



-- Standardizing date formats --

/*Converting single-digit date and month values to a consistent format with leading zeros */
UPDATE Sales
SET date = DATE_FORMAT(STR_TO_DATE(date, '%m/%d/%Y'), '%m-%d-%Y')
WHERE LENGTH(date) < 10;

SELECT * FROM SALES;

/* Converting multiple date formats to a consistent format */
UPDATE Sales
SET date = CASE
    WHEN date LIKE '%mm/dd/yyyy%' THEN DATE_FORMAT(STR_TO_DATE(date, '%m/%d/%Y'), '%m-%d-%Y')
    WHEN date LIKE '%mm-dd-yyyy%' THEN DATE_FORMAT(STR_TO_DATE(date, '%m-%d-%Y'), '%m-%d-%Y')
    ELSE date
    END;
    
/* Selecting records based on a specific date range */
SELECT *
FROM Sales
WHERE date >= '01-16-2019' AND date <= '02-06-2019';

/* Calculating time differences or intervals */
SELECT DATEDIFF(02-06-2019,01-16-2019) AS days_difference
FROM Sales;

/* Handling date outliers or data inconsistencies */
-- Using filtering conditions to exclude data that falls outside valid date ranges --
UPDATE Sales
SET date = NULL
WHERE date < '01-01-2000' OR date > '12-31-2025';

/* Handling null or empty date values */
SELECT *
FROM Sales
WHERE date IS NULL ;

SELECT *
FROM Sales
WHERE date IS NOT NULL;

/* Counting the number of distinct values in a column */
SELECT COUNT(DISTINCT Quantity) AS distinct_count
FROM Sales
GROUP BY Quantity; 

/* Removing leading or trailing spaces in text columns */
UPDATE Sales
SET product_line = TRIM(product_line); 
UPDATE Sales
SET payment = TRIM(payment); 

/* Handling missing values by replacing them with default values */
UPDATE Sales
SET Tax = '0'
WHERE Tax IS NULL;

/* Checking for inconsistent or misspelled values using pattern matching */ 
SELECT DISTINCT product_line
FROM Sales
WHERE product_line NOT LIKE 'Home and lifestyle';

/* Removing unwanted characters or symbols from a text column */
UPDATE Sales
SET City = REPLACE(City, 'Naypyitaw', 'Nay Pyi Taw '); 

/* Handling outliers in numeric columns by capping or replacing them */
UPDATE Sales
SET quantity = CASE
  WHEN payment = 'Credit Card' THEN quantity  + 1
  WHEN payment = 'Cash' THEN quantity + 2
  ELSE quantity
  END;

/* Converting a string column to a numeric column */
ALTER TABLE Sales
MODIFY Unit_price DECIMAL(10, 2);

/* Renaming a column in a table */
ALTER TABLE Sales
CHANGE income gross_income DECIMAL(10, 2);

/* Calculating aggregate statistics */
SELECT MIN(unit_price) AS min_value,
       MAX(unit_price) AS max_value,
       AVG(unit_price) AS average_value,
       COUNT(*) AS total_records
FROM Sales;

/* Find the total sales revenue */
SELECT SUM(total) AS total_revenue
FROM Sales;

/*Count the number of sales made in each city */
SELECT city, COUNT(*) AS total_sales
FROM Sales
GROUP BY city;

/* Calculate the average unit price for each product line */
SELECT product_line, AVG(unit_price) AS average_unit_price
FROM Sales
GROUP BY product_line;

/* Identify the top 5 branches with the highest gross income */
SELECT branch, gross_income
FROM Sales
ORDER BY gross_income DESC
LIMIT 5;

/* Calculate the total tax amount for each customer type */
SELECT customer_type, SUM(tax) AS total_tax
FROM Sales
GROUP BY customer_type;


-- Aggregated Subquery --

/* Find the total sales for customers who have made purchases above the average total */
SELECT customer_type, SUM(total) AS total_sales
FROM Sales
WHERE total > (SELECT AVG(total) FROM Sales)
GROUP BY customer_type;

/* Calculate the percentage contribution of each product line to the total sales */
SELECT product_line, (SUM(total) / (SELECT SUM(total) FROM Sales)) * 100 AS sales_percentage
FROM Sales
GROUP BY product_line;

/* Determine the branch with the highest number of sales, along with the count of sales for that branch */
SELECT branch, COUNT(*) AS total_sales
FROM Sales
WHERE branch = (SELECT branch FROM Sales GROUP BY branch ORDER BY COUNT(*) DESC LIMIT 1)
GROUP BY branch;



-- Aggregates with CASE --

/* Calculate the average rating for each product line, categorizing them as "Good," "Average," or "Poor" based on their average rating value */
SELECT product_line,
       AVG(rating) AS average_rating,
       CASE
           WHEN AVG(rating) >= 4.5 THEN 'Good'
           WHEN AVG(rating) >= 3.0 THEN 'Average'
           ELSE 'Poor'
       END AS rating_category
FROM Sales
GROUP BY product_line;

/* Determine the total tax amount for each payment method, categorizing them as "High" or "Low" based on the total tax amount */
SELECT payment,
       SUM(tax) AS total_tax,
       CASE
           WHEN SUM(tax) > 1000 THEN 'High'
           ELSE 'Low'
       END AS tax_category
FROM Sales
GROUP BY payment;

/* Calculate the total gross income for each branch, categorizing them as "High," "Medium," or "Low" based on the total gross income */
SELECT branch,
       SUM(gross_income) AS total_income,
       CASE
           WHEN SUM(gross_income) > 50000 THEN 'High'
           WHEN SUM(gross_income) > 25000 THEN 'Medium'
           ELSE 'Low'
       END AS income_category
FROM Sales
GROUP BY branch;


    
   





















