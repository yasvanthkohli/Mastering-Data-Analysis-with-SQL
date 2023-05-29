CREATE DATABASE world_happiness_report;

USE world_happiness_report;

CREATE TABLE Happiness_indices ( 
Overall_rank INT,
Region VARCHAR(20),
Score FLOAT(6),
GDP_per_capita FLOAT(6),
Social_support FLOAT(6),
Healthy_life_expectancy FLOAT(6),
Freedom_to_make_life_choices FLOAT(6),
Generosity FLOAT(6),
Perceptions_of_corruption FLOAT(6)
)

SELECT *
FROM Happiness_indices
LIMIT 10;

/* Select all columns from the Happiness_report table */
SELECT * FROM Happiness_indices;

/* Select the region and score for all records in the table */
SELECT Region, Score FROM Happiness_indices;

/* Select the region, score, and GDP per capita for records where the overall rank is less than 10 */
SELECT Region, Score, GDP_per_capita
FROM Happiness_indices
WHERE Overall_rank < 10;

/* Calculate the average score for all records in the table */
SELECT AVG(Score) AS Average_Score 
FROM Happiness_indices;

/* Count the number of records in the table */
SELECT COUNT(*) AS Record_Count 
FROM Happiness_indices;

/* Select the region and score for records where the generosity is greater than 0.2 */
SELECT Region, Score
FROM Happiness_indices
WHERE Generosity > 0.2;

/* Select the top 5 regions with the highest GDP per capita */
SELECT Region, GDP_per_capita
FROM Happiness_indices
ORDER BY GDP_per_capita DESC
LIMIT 5;

/* Update the score to 8.5 for the record where the overall rank is 1 */
UPDATE Happiness_indices
SET Score = 8.5
WHERE Overall_rank = 1;

/* Delete all records where the perceptions of corruption is greater than 0.5 */
DELETE FROM Happiness_indices
WHERE Perceptions_of_corruption > 0.5;

/* Select the region and overall rank for records where the healthy life expectancy is less than 0.60 */
SELECT Region, Overall_rank
FROM Happiness_indices
WHERE Healthy_life_expectancy < 0.60;

/* Calculate the average score grouped by region */
SELECT Region, AVG(Score) AS Average_Score
FROM Happiness_indices
GROUP BY Region;

/* Select the top 3 regions with the highest social support */
SELECT Region, Social_support
FROM Happiness_indices
ORDER BY Social_support DESC
LIMIT 3;

/* Calculate the sum of generosity for records where the score is greater than 7 */
SELECT SUM(Generosity) AS Total_Generosity
FROM Happiness_indices
WHERE Score > 7;

/* Find the region with the highest overall rank */
SELECT Region
FROM Happiness_indices
WHERE Overall_rank = (
  SELECT MAX(Overall_rank)
  FROM Happiness_indices
);

/* Calculate the average GDP per capita for records where the freedom to make life choices is greater than 0.6 */
SELECT AVG(GDP_per_capita) AS Average_GDP
FROM Happiness_indices
WHERE Freedom_to_make_life_choices > 0.6;

/* Select the regions and scores for records where the perceptions of corruption is less than 0.1 or the generosity is greater than 0.3 */
SELECT Region, Score
FROM Happiness_indices
WHERE Perceptions_of_corruption < 0.1 OR Generosity > 0.3;

/* Select the region, score, and healthy life expectancy for records where the score is between 6 and 7 */
SELECT Region, Score, Healthy_life_expectancy
FROM Happiness_indices
WHERE Score BETWEEN 6 AND 7;

/*Select the region, score, and perceptions of corruption for records where the score is above 7 and the perceptions of corruption is below 0.1 */
SELECT Region, Score, Perceptions_of_corruption
FROM Happiness_indices
WHERE Score > 7 AND Perceptions_of_corruption < 0.1;

/* Find the minimum and maximum values of the freedom to make life choices column */
SELECT MIN(Freedom_to_make_life_choices) AS Min_Freedom, MAX(Freedom_to_make_life_choices) AS Max_Freedom
FROM Happiness_indices;

/* Select the top 5 regions with the lowest perceptions of corruption */
SELECT Region, Perceptions_of_corruption
FROM Happiness_indices
ORDER BY Perceptions_of_corruption ASC
LIMIT 5;

/* Calculate the average score for each region, ordered in descending order of the average score */
SELECT Region, AVG(Score) AS Average_Score
FROM Happiness_indices
GROUP BY Region
ORDER BY Average_Score DESC;

/* Select the region and overall rank for records where the GDP per capita is above the average GDP per capita */
SELECT Region, Overall_rank
FROM Happiness_indices
WHERE GDP_per_capita > (SELECT AVG(GDP_per_capita) FROM Happiness_indices);

/* Calculate the sum of social support for records where the healthy life expectancy is above 0.7 */
SELECT SUM(Social_support) AS Total_Social_Support
FROM Happiness_indices
WHERE Healthy_life_expectancy > 0.7;

/* Find the region with the highest score and display the score value */
SELECT Region, Score
FROM Happiness_indices
WHERE Score = (SELECT MAX(Score) FROM Happiness_indices);

/* Calculate the average values for all columns in the table */
SELECT AVG(Overall_rank) AS Average_Overall_rank, AVG(Score) AS Average_Score, AVG(GDP_per_capita) AS Average_GDP_per_capita,
       AVG(Social_support) AS Average_Social_support, AVG(Healthy_life_expectancy) AS Average_Healthy_life_expectancy,
       AVG(Freedom_to_make_life_choices) AS Average_Freedom_to_make_life_choices, AVG(Generosity) AS Average_Generosity,
       AVG(Perceptions_of_corruption) AS Average_Perceptions_of_corruption
FROM Happiness_indices;

/* Find the region with the highest average healthy life expectancy */
SELECT Region, AVG(Healthy_life_expectancy) AS Average_Healthy_life_expectancy
FROM Happiness_indices
GROUP BY Region
ORDER BY Average_Healthy_life_expectancy DESC
LIMIT 1;

/* Calculate the difference between the maximum and minimum healthy life expectancy values */
SELECT MAX(Healthy_life_expectancy) - MIN(Healthy_life_expectancy) AS Difference
FROM Happiness_indices;

/* Select the records where the GDP per capita is greater than the average GDP per capita and the healthy life expectancy is above 0.70 */
SELECT *
FROM Happiness_indices
WHERE GDP_per_capita > (SELECT AVG(GDP_per_capita) FROM Happiness_indices) AND Healthy_life_expectancy > 0.7;

/* Calculate the percentage of records where the social support is above 0.5 */
SELECT (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Happiness_indices WHERE Social_support IS NOT NULL)) AS Percentage
FROM Happiness_indices
WHERE Social_support > 0.5;



