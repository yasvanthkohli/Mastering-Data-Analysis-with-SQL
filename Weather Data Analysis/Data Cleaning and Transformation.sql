                -- 	Data Cleaning and Transformation    --
				
		
  CREATE TABLE weather_data (
  name VARCHAR(255),
  datetime TIMESTAMP,
  temp FLOAT,
  feelslike FLOAT,
  dew FLOAT,
  humidity FLOAT,
  precip FLOAT,
  precipprob FLOAT,
  preciptype VARCHAR(255),
  snow FLOAT,
  snowdepth FLOAT,
  windgust FLOAT,
  windspeed FLOAT,
  winddir FLOAT,
  sealevelpressure FLOAT,
  cloudcover FLOAT,
  visibility FLOAT,
  solarradiation FLOAT,
  solarenergy FLOAT,
  uvindex FLOAT,
  severerisk FLOAT,
  conditions VARCHAR(255),
  icon VARCHAR(255),
  stations VARCHAR(255)
);

COPY weather_data
FROM 'C:\Users\admin\Desktop\Sql Project\Weatherdata\Weather_data.csv'
DELIMITER ','
CSV HEADER;

-- Removing Columns
ALTER TABLE weather_data
DROP COLUMN snow,
DROP COLUMN snowdepth;

-- Removing duplicates
DELETE FROM weather_data
WHERE datetime IN (
    SELECT datetime
    FROM weather_data
    GROUP BY datetime
    HAVING COUNT(*) > 1
);

-- Extract specific parts (year, month, day, etc.) from a date or timestamp.
SELECT EXTRACT(YEAR FROM datetime) AS year
FROM weather_data;


/* Handling missing values */

-- Fill missing precipitation type values with 'No Precipitation'
UPDATE weather_data
SET preciptype = 'No Precipitation'
WHERE preciptype IS NULL;


-- Update precipitation values to 0 where it is NULL
UPDATE weather_data
SET precip = 0
WHERE precip IS NULL;


-- Replace negative precipitation values with 0
UPDATE weather_data
SET precip = 0
WHERE precip < 0;


-- Replace missing precipitation probability values with 0
UPDATE weather_data
SET precipprob = 0
WHERE precipprob IS NULL;


-- Calculate the average temperature
UPDATE weather_data
SET temp = (
  SELECT AVG(temp)
  FROM weather_data
  WHERE temp IS NOT NULL
)
WHERE temp IS NULL;


-- Calculate the average dew value
UPDATE weather_data
SET dew = (
  SELECT AVG(dew)
  FROM weather_data
  WHERE dew IS NOT NULL
)
WHERE dew IS NULL;

-- Calculate the average UV index
UPDATE weather_data
SET uvindex = (
    SELECT AVG(uvindex)
    FROM weather_data
    WHERE uvindex IS NOT NULL
)
WHERE uvindex IS NULL;


-- Calculate the average precipitation probability
UPDATE weather_data
SET precipprob = (
    SELECT AVG(precipprob)
    FROM weather_data
    WHERE precipprob IS NOT NULL
)
WHERE precipprob IS NULL;


-- Calculate the median visibility
UPDATE weather_data
SET visibility = (
  SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY visibility)
  FROM weather_data
  WHERE visibility IS NOT NULL
)
WHERE visibility IS NULL;

-- Calculate the median cloud cover
UPDATE weather_data
SET cloudcover = (
    SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY cloudcover)
    FROM weather_data
    WHERE cloudcover IS NOT NULL
)
WHERE cloudcover IS NULL;


-- Interpolate missing humidity values using linear interpolation
UPDATE weather_data
SET humidity = (
    SELECT ((prev_humidity + next_humidity) / 2)
    FROM (
        SELECT LAG(humidity) OVER (ORDER BY datetime) AS prev_humidity,
               LEAD(humidity) OVER (ORDER BY datetime) AS next_humidity
        FROM weather_data
    ) AS subquery
    WHERE humidity IS NULL
)
WHERE humidity IS NULL;





/* Data normalization */

-- Split datetime column into separate date and time columns
ALTER TABLE weather_data
ADD COLUMN date DATE,
ADD COLUMN time TIME;

UPDATE weather_data
SET date = CAST(datetime AS DATE),
    time = CAST(datetime AS TIME);

-- Remove datetime column from weather_data table
ALTER TABLE weather_data
DROP COLUMN datetime;


-- Split stations column into separate station and station_code columns
-- Split_part function is used to split the stations column into two parts based on the comma (",") delimiter 
CREATE TABLE weather_stations (
    station VARCHAR,
    station_code VARCHAR(15)
);

INSERT INTO weather_stations (station, station_code)
SELECT 
    split_part(stations, ':', 1) AS station,
    split_part(stations, ':', 2) AS station_code
FROM weather_data;

-- Remove stations column from weather_data table
ALTER TABLE weather_data
DROP COLUMN stations;



/* Removing outliers  */

-- Filter out records with temperature outside the specified range
DELETE FROM weather_data
WHERE temp < -40 OR temp > 50;





 /* Data transformation */
 
 -- Convert temperature from Fahrenheit to Celsius
UPDATE weather_data
SET temp = (temp - 32) * 5/9;


-- Convert temperature from Celsius to Fahrenheit
UPDATE weather_data
SET temp_fahrenheit = (temp * 9/5) + 32;


-- Convert visibility from miles to kilometers
UPDATE weather_data
SET visibility = visibility * 1.60934;


 -- Convert temperature to categorical variable
UPDATE weather_data
SET temperature_category = CASE
    WHEN temp < 0 THEN 'Freezing'
    WHEN temp < 10 THEN 'Cold'
    WHEN temp < 20 THEN 'Cool'
    WHEN temp < 30 THEN 'Warm'
    ELSE 'Hot'
    END;


-- Categorize humidity into different ranges:
SELECT
  CASE
    WHEN humidity < 30 THEN 'Low'
    WHEN humidity >= 30 AND humidity < 60 THEN 'Moderate'
    WHEN humidity >= 60 AND humidity < 80 THEN 'High'
    ELSE 'Very High'
  END AS humidity_category
FROM weather_data;


-- Categorize wind speed into different levels
SELECT
  CASE
    WHEN windspeed < 10 THEN 'Calm'
    WHEN windspeed >= 10 AND windspeed < 20 THEN 'Light Breeze'
    WHEN windspeed >= 20 AND windspeed < 30 THEN 'Moderate Breeze'
    WHEN windspeed >= 30 AND windspeed < 40 THEN 'Strong Breeze'
    ELSE 'High Wind'
  END AS wind_speed_level
FROM weather_data;


-- Categorize precipitation into different types
SELECT
  CASE
    WHEN precip > 0 THEN 'Rain'
    WHEN snow > 0 THEN 'Snow'
    ELSE 'No Precipitation'
  END AS precipitation_type
FROM weather_data;


-- Categorize UV index into different risk levels
SELECT
  CASE
    WHEN uvindex < 3 THEN 'Low'
    WHEN uvindex >= 3 AND uvindex < 6 THEN 'Moderate'
    WHEN uvindex >= 6 AND uvindex < 8 THEN 'High'
    WHEN uvindex >= 8 AND uvindex < 11 THEN 'Very High'
    ELSE 'Extreme'
  END AS uv_index_risk_level
FROM weather_data;


-- Categorize cloud cover into different levels
SELECT
  CASE
    WHEN cloudcover < 20 THEN 'Clear'
    WHEN cloudcover >= 20 AND cloudcover < 50 THEN 'Partly Cloudy'
    WHEN cloudcover >= 50 AND cloudcover < 80 THEN 'Mostly Cloudy'
    ELSE 'Overcast'
  END AS cloud_cover_level
FROM weather_data;
