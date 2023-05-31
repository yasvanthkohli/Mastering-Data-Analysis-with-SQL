                   -- Data Filtering and Aggregation--

USE Supermarket_sales;



SELECT * FROM Sales 
WHERE branch = 'A'; -- Filtering by Branch

SELECT * FROM Sales
WHERE city = 'Yangon'; -- Filtering by City

SELECT * FROM Sales
WHERE city = 'Mandalay';  

SELECT * FROM Sales
WHERE customer_type = 'Member' AND gender = 'Female';   -- Filtering by Customer Type and Gender

SELECT * FROM Sales
WHERE product_line = 'Electronic accessories' AND quantity >= 10;  -- Filtering by Product Line and Quantity

SELECT * FROM Sales
WHERE date >= '02-06-2019' AND date <= '03-09-2019';  -- Filtering by Date Range

SELECT * FROM Sales
WHERE total >= 500 AND total <= 1000;  -- Filtering by Total Sales Range

SELECT * FROM Sales
WHERE payment = 'Credit Card' AND customer_type = 'Member';  -- Filtering by Payment Method and Customer Type

SELECT * FROM Sales
WHERE gross_margin_percentage >= 3.0;  -- Filtering by Gross Margin Percentage

SELECT * FROM Sales
WHERE rating >= 4 AND product_line = 'Fashion accessories';   -- Filtering by Rating and Product Line

SELECT * FROM Sales
WHERE TIME(time) >= '12:00' AND TIME(time) <= '18:00';  -- Filtering by Time of Day


-- Filtering by Multiple Conditions with Logical Operators --
SELECT * FROM Sales
WHERE (branch = 'A' OR branch = 'B') AND (customer_type = 'Member' OR customer_type = 'Normal') AND rating >= 4;

SELECT * FROM Sales
WHERE branch = 'A'
  AND customer_type = 'Normal'
  AND product_line =  category = 'Home and lifestyle';               
   

-- Filtering with Pattern Matching --
SELECT * FROM Sales
WHERE product_line LIKE '%Food%'
  AND (city LIKE 'Y%' OR city LIKE 'N%');  -- city starts with either 'Y' or 'N'

 
 -- Filtering with Date Functions --
 
 /* Filtering the sales data for records where the date falls within the first three months of the year 2019 */
SELECT * FROM Sales
WHERE EXTRACT(YEAR FROM date) = 2019
  AND EXTRACT(MONTH FROM date) IN (1, 2, 3);

/* Filtering the sales data for records within a specific date range  and where the total sales amount is higher 
than the maximum total sales amount within the same date range. */
SELECT * FROM Sales
WHERE date >= '01-01-2019'AND date <= '03-31-2019'
  AND total < (
    SELECT Max(total)
    FROM Sales
    WHERE date >= '01-01-2019'
      AND date <= '03-31-2019'
  );
  
  
  /* Filtering the sales data for branches that have total sales amounts higher than the average total sales amount across all branches within a specific date range */
SELECT * FROM Sales
WHERE branch IN (
  SELECT branch
  FROM (
    SELECT branch, SUM(total) AS branch_total
    FROM Sales
    WHERE date >= '01-01-2019' AND date <= '03-31-2019'
    GROUP BY branch
  ) AS branch_totals        -- total sales amount for each branch(branch-wise total sales amounts) 
  WHERE branch_total > (
    SELECT AVG(branch_total)
    FROM (
      SELECT branch, SUM(total) AS branch_total
      FROM Sales
      WHERE date >= '01-01-2019' AND date <= '03-31-2019'
      GROUP BY branch
    ) AS avg_branch_totals
  )
);



--  Filtering with Conditional Expressions --

/*  Filtering sales as 'High Sales', 'Medium Sales', or 'Low Sales' based on the quantity and total values, and retrieving records where the category is 'High Sales' */
SELECT * FROM Sales
WHERE CASE
  WHEN quantity > 10 AND total > 1000 THEN 'High Sales'
  WHEN quantity <= 10 AND total > 500 THEN 'Medium Sales'
  ELSE 'Low Sales'
  END = 'High Sales';


SELECT * FROM Sales
WHERE CASE
  WHEN branch = 'A' AND product_line = 'Electronics' THEN total * 1.1
  WHEN branch = 'B' THEN total * 1.2
  ELSE total
  END > 5000;


-- Filtering with Window Functions --

/* Filtering using window function to rank sales records within each branch based 
on the total sales amount to display top 5 records from each branch  */
SELECT * FROM (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY branch ORDER BY total DESC) AS row_num
  FROM Sales
) AS ranked
WHERE row_num <= 5;


-- Filtering with Subquery and Aggregate Function  --

/* Filtering the sales data for records where the total sales amount is higher than the average total sales amount in 'Yangon' */
SELECT * FROM Sales
WHERE total > (
  SELECT AVG(total)
  FROM Sales
  WHERE city = 'Yangon'
);



-- Insights related to the sales data --

/* What is the total sales amount for each branch */
SELECT branch, SUM(total) AS total_sales
FROM Sales
GROUP BY branch;

/* How many sales transactions were made on each date */
SELECT date, COUNT(*) AS transaction_count
FROM Sales
GROUP BY date;

/* What is the average unit price of each product line */
SELECT product_line, AVG(unit_price) AS average_unit_price
FROM Sales
GROUP BY product_line;

/* What is the total tax and total gross income for each payment type */
SELECT payment, SUM(tax) AS total_tax, SUM(gross_income) AS total_gross_income
FROM Sales
GROUP BY payment;

/* What is the total quantity sold for each product line in each Month */
SELECT MONTH(date) AS MONTH, product_line, SUM(quantity) AS total_quantity
FROM Sales
GROUP BY MONTH(date), product_line;


/* What is the average rating for each product line in each city */
SELECT city, product_line, AVG(rating) AS average_rating
FROM Sales
GROUP BY city, product_line;

/* Which payment method has the highest total sales amount */
SELECT payment, SUM(total) AS total_sales
FROM Sales
GROUP BY payment
ORDER BY total_sales DESC
LIMIT 1;

/* What is the average gross margin percentage for each branch and product line combination */
SELECT branch, product_line, AVG(gross_margin_percentage) AS average_margin
FROM Sales
GROUP BY branch, product_line;

/* What is the average gross income for each branch and payment method combination */
SELECT branch, payment, AVG(gross_income) AS average_income
FROM Sales
GROUP BY branch, payment;

 /* Which payment method has the highest average rating */
SELECT payment, AVG(rating) AS average_rating
FROM Sales
GROUP BY payment
ORDER BY average_rating DESC
LIMIT 1;

/* What is the total revenue generated by each customer type in each city, considering only transactions with a rating of 5 or above */
SELECT city, customer_type, SUM(total) AS total_revenue
FROM Sales
WHERE rating >= 5
GROUP BY city, customer_type;


/* What is the average unit price of each product line, considering only transactions where the gross margin percentage is above a certain threshold */
SELECT product_line, AVG(unit_price) AS average_unit_price
FROM Sales
WHERE gross_margin_percentage > 4
GROUP BY product_line;