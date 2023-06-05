-- Create a temporary table to hold the intermediate results
CREATE TEMPORARY TABLE temp_results (
    petid varchar,
    procedure_count int,
    total_price decimal(10, 2)
);


-- Insert data into the temporary table
INSERT INTO temp_results (petid, procedure_count, total_price)
SELECT ph.petid, COUNT(*) AS procedure_count, SUM(pd.price) AS total_price
FROM procedurehistory ph
JOIN proceduredetails pd ON ph.proceduretype = pd.proceduretype AND ph.proceduresubcode = pd.proceduresubcode
GROUP BY ph.petid;


-- Retrieve data from the temporary table
SELECT * FROM temp_results;


-- Perform additional operations on the temporary table
UPDATE temp_results
SET total_price = total_price * 1.1; -- Increase the total price by 10%

-- Retrieve the updated data from the temporary table
SELECT * FROM temp_results;


-- Perform additional operations on the temporary table
ALTER TABLE temp_results ADD COLUMN average_price decimal(10, 2); -- Add a new column

UPDATE temp_results
SET average_price = total_price / procedure_count; -- Calculate the average price

-- Retrieve the updated data from the temporary table
SELECT * FROM temp_results;


-- Perform further analysis on the temporary table
SELECT petid, COUNT(*) AS num_pets, AVG(total_price) AS avg_total_price
FROM temp_results
GROUP BY petid
HAVING COUNT(*) > 1; -- Retrieve pets with more than one procedure

-- Retrieve the updated data from the temporary table
SELECT * FROM temp_results;


-- Create an index on the temporary table
CREATE INDEX idx_temp_results_petid ON temp_results (petid);

-- Perform queries on the temporary table using the index
SELECT * FROM temp_results WHERE petid = 'M2-1131';

-- Drop the index once it is no longer needed
DROP INDEX IF EXISTS idx_temp_results_petid;

-- Delete rows from the temporary table based on a condition
DELETE FROM temp_results WHERE total_price < 100;


-- Sort the temporary table based on the total_price column in descending order
SELECT petid, procedure_count, total_price
FROM temp_results
ORDER BY total_price DESC;

-- Retrieve data from the temporary table
SELECT * FROM temp_results;

--  Delete records from the temporary table based on a condition
DELETE FROM temp_results WHERE total_price = 0;

-- 5. Update the procedure_count column based on a condition
UPDATE temp_results SET procedure_count = 2 WHERE total_price > 1000;

-- Retrieve the updated data from the temporary table
SELECT * FROM temp_results
WHERE procedure_count = 2;




-- Calculate the total price for each pet in a specific range
SELECT petid, procedure_count, total_price,
    CASE
        WHEN total_price >= 1000 THEN 'High'
        WHEN total_price >= 500 THEN 'Medium'
        ELSE 'Low'
    END AS price_range
FROM temp_results
ORDER BY total_price DESC;

-- Add a new column and set its values based on a condition
ALTER TABLE temp_results ADD COLUMN is_expensive BOOLEAN;
UPDATE temp_results SET is_expensive = (total_price > 1000);


-- Group the results by the price range and calculate the average procedure count
SELECT 
    CASE
        WHEN total_price >= 1000 THEN 'High'
        WHEN total_price >= 500 THEN 'Medium'
        ELSE 'Low'
    END AS price_range,
    AVG(procedure_count) AS average_procedure_count
FROM temp_results
GROUP BY price_range;


-- Find the pet with the highest total price
SELECT *
FROM temp_results
WHERE total_price = (SELECT MAX(total_price) FROM temp_results);


-- Delete duplicate rows from the temporary table
DELETE FROM temp_results
WHERE ctid NOT IN (
    SELECT MAX(ctid)
    FROM temp_results
    GROUP BY petid, procedure_count, total_price
);

-- Save the temporary table into a file
COPY temp_results TO 'C:\Users\admin\Desktop\Sql Project\temp_results.csv' DELIMITER ',' CSV HEADER;


-- Drop the temporary table once it is no longer needed
DROP TABLE IF EXISTS temp_results;








