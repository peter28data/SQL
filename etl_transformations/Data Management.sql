-----------------------------------------------------------------------
-- CTE & Joins

WITH s AS (
  SELECT
  start_station,
  COUNT(start_date) AS starts
  FROM trip
  GROUP BY start_station)
SELECT
  t.end_station AS station,
  COUNT(t.end_date) AS ends,
  s.starts
FROM trip AS t
INNER JOIN s
  ON t.end_station = s.start_station
GROUP BY station, starts
LIMIT 7;

-- Explanation: Utlize a CTE to store the name of the bike station and the total amount of rides that were started from each bike station. 

-- Then, Utilize an INNER JOIN to find the transactions that appear from the CTE and the original "trip" table.

---------------------------------

-- "bike_stations" contains newly built bike locations. 
-- "bike_trips" contains bike logs from new locations and previously existing ones
-- Identify which bike trips only began in newly built bike stations.

SELECT
trip_id,
station_id,
latitude,
longitude
FROM bike_trips AS t
INNER JOIN bike_stations AS s   
ON t.stating_station = s.station_id;

-- Summary: A left join will return NULL for columns where there is no match with the right side, therefore, an inner join is optimal to return only matched records. 

--------------------------------------------------------------------

-- Join table but keep all the records no mater whether they a match
SELECT
  trip_id,
  duration,
  bike_id
  FROM bike_trips as t
  FULL JOIN bike as b
  on t.bike_id = b.bike_id


--------------------------------------------------------------------------------------------
-- Regular Expression (Regex) String Pattern Matching Tradeoffs 

-- Returns Rows where the movie Title contains 'k' or 'm' only in lowercase

WHERE title SIMILAR TO '%(k|m)%';    

-- The SIMILAR TO Operator has the advantage of the Parentheses and the pipe symbol (k|m) over the LIKE Operator.
-- LIKE can be used for lowercase specific character
------------------------------------------------------------------------

-- Utilize to flag unusual movie titles that contain something OTHER THAN word characters
WHERE title NOT SIMILAR TO '\w*';


-- Utilizing Underscores
-- 4 Underscores will return the movie titles which only includes four letters for abbreviated columns

WHERE title LIKE '____';   

--------------------------------------------------------------------

-- return the rows with the second to fourth highest price 
ORDER BY price DESC
OFFSET 1
LIMIT 3;



-- for each vendor_name: ->combine the vendor_city and vendor_state
SELECT
vendor_name,
  
CONCAT(vendor_city,', ', vendor_state) AS location
FROM vendors
LIMIT 3;
-------------------------------------------------------------------------

-- Identify how many "speaker" products contain a higher than average price

SELECT
COUNT(*) AS above_avg
FROM speaker
WHERE price > (SELECT AVG(price) FROM speaker);  

-------------------------------------------------------------------------

-- Calcute the Price Range between each month's highest and lowest price
SELECT
EXTRACT(month FROM date::DATE) AS month,
MAX(price) - MIN(price) AS difference


---------------------------------------------------------------

-- return number of duplicates records

  SELECT
name,
city,
state,
COUNT(*) AS duplicates
FROM vendors
GROUP BY name, city, state    --by grouping by these and selecting the count it shows dups


-- Return vendors from austin city
SELECT
vendor_name, 
vendor_city,
vendor_state
FROM vendors
WHERE vendor_city = 'AUSTIN';


-- Return the number of rows in the 'launch' column where the value is NOT a date OR the value is missing
SELECT 
COUNT(*)
FROM speaker
WHERE launch = 'Null' OR launch IS NULL;    --Not a date is labeled 'Null'


-- Validate the date and return the rows that the 'installation_date' is not a date in 2013
SELECT *
FROM station
WHERE installation_date NOT BETWEEN '2013-01-01' 
  
AND '2013-12-31';


-- Validate the date there should not be any negative values
SELECT *
FROM trips
WHERE duration < 0;


-- Join the table with another but keep all the records from one table no matter whether they have a match in the other
SELECT trip_id,
duration,
t.bike_id
FROM bike_trips as t
LEFT JOIN bike as b
ON t.bike_id = b.bike_id;


-- Join the tables but keep only the matched records
SELECT trip_id,
duration,
t.bike_id
FROM bike_trips as t
INNER JOIN bike as b
ON t.bike_id = b.bike_id;


-- Join the table with itself to return the pairs of the speaker model with the same launch date
SELECT
s1.model, 
s2.model,
s1.price,
s2.price
FROM speaker s1
INNER JOIN speaker s2
ON s1.productid <> s2.productid 
AND s1.launch = s2.launch;


-- Return the day from the column and convert the day to numeric data type
SELECT
trip_id,
EXTRACT(DAY FROM start_time) :: NUMERIC AS start_day
FROM bike_trips;


-- Return the first five rows that the title DOES NOT contain 'the' no matter the case of the string
SELECT *
FROM movie_budget
  
WHERE title NOT ILIKE '%the%'
LIMIT 5;


-- Validate the data by returning the rows that the 'bike_available' column is out of range (each station has at least one bike and at most 10)
SELECT *
FROM status
WHERE bikes_available < 1 
OR bikes_available > 10;


-----------------------------------------------------------------------------


-- combine 2 columns with a comma and space into the new column
SELECT vendor_name,
CONCAT(vendor_city,', ',vendor_state) AS location
FROM vendors
LIMIT 3;


-- split the title into 2 parts
SELECT year,
SPLIT_YEAR(title,':',1) AS name,

SPLIT_YEAR(title,':',1) AS series
FROM movie_budget;


---------------------------------------------------------------------------

-- The movie with the longest title
SELECT year, title, budget,
LENGTH(title) AS title_len
FROM movie_budget
ORDER BY title_len DESC      -- This will ensure the longest title is returned
LIMIT 1;

---------------------------------------------------------------------------

-- Validate the date by Returning the rows that the installation_date is not a date in 2013
SELECT * 
FROM station
WHERE installation_date NOT BETWEEN '2013-01-01' AND '2013-12-31';


-------------------------------------
SELECT
  start_station,
  subscription_type,
  COUNT(start_date) AS trips,
  (SELECT COUNT(start_date) FROM trip AS t1 WHERE t.start_station = t1.start_station) AS station_total
FROM trip AS t1
GROUP BY start_station, subscription_type
ORDER BY start_station
LIMIT 3;
  
-- Explanation: We are using a subquery in the SELECT Clause to return the number of stations that are newly build and added to the "trip" table.

--------------------------------------


-- Return the Rows that only appears in the movie_2000, But Not movie_2010
SELECT *
FROM movie_2000
EXCEPT
  
SELECT *
FROM movie_2010
ORDER BY year;

-- Explanation: The advantage of using EXCEPT is that it removes duplicates by default and returns rows in the first query but not in the second query whereas LEFT JOIN combines rows.  

-----------------------------

-- Created on 7.31.2025
