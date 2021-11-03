-- ----------------------- --
-- Divvy Trip Data Summary --
-- ----------------------- --

/* In this project, I use SQL to explore trip data from bike-sharing app Divvy. The goal of this
    project is to clean data and transform it in a way that can explain how Divvy users behave. */

-- ----------------- --
-- Cleaning the data --
-- ----------------- --

-- First, I create a temporary table of the dataset. At this point of the project, there were 4,913,083 rows
DROP TEMPORARY TABLE IF EXISTS a;
CREATE TEMPORARY TABLE a
SELECT *
FROM divvy_trip_data;

-- Next, I created a column that calculates the duration of the trip. Time is shown in minutes
ALTER TABLE a
ADD COLUMN trip_duration INT
GENERATED ALWAYS AS (TIMESTAMPDIFF(MINUTE, a.started_at, a.ended_at));

-- I then used this to filter out the trips that were less than 2 minutes or more than 1 day. This removed 138,305 rows
DELETE FROM a
WHERE trip_duration < 2 OR trip_duration > 1440;

-- I also removed rows that had no time inputs. This took out 83,509 rows
DELETE FROM a
WHERE started_at = '0000-00-00 00:00:00' OR ended_at = '0000-00-00 00:00:00';

-- I deleted rows with invalid station values. This removed 11 rows
DELETE FROM a
WHERE start_station_name = 'start_station_name';

-- I deleted all test rides by looking for station name inputs that had 'test'. 145 rows removed
DELETE FROM a
WHERE
	start_station_name LIKE '%test%'
    OR end_station_name LIKE '%test%';

-- I also removed all unnecessary parentheses in the station names. This affected 129,908 rows
UPDATE a
SET
	start_station_name = REGEXP_REPLACE(start_station_name, '\\(\\w{2,}(\\s\\w{2,})*\\)', ''),
    end_station_name = REGEXP_REPLACE(end_station_name, '\\(\\w{2,}(\\s\\w{2,})*\\)', '')
WHERE
	start_station_name LIKE '%(%)%'
	OR end_station_name LIKE '%(%)%';

-- Finally, I removed the one row that contained all the null values in the table
DELETE FROM a
WHERE started_at IS NULL;

/* The next block of code shows my attempt to fill the missing station name values using the inputted latitude and longitude points.
   I was able to identify the station names by getting the minimum and maximum coordinates and then using that to update the station names.
   Unfortunately, these queries were too much for my laptop to handle as they lasted for too long, although I confirmed that they
   worked on a smaller dataset.
    
-- Get missing start_station_name values. 425,675 rows affected
DROP TEMPORARY TABLE IF EXISTS b;
CREATE TEMPORARY TABLE b
SELECT *
FROM a
WHERE start_station_name = '';

-- Calculate minimum and maximum latitudes
DROP TEMPORARY TABLE IF EXISTS c;
CREATE TEMPORARY TABLE c
SELECT
	start_station_name AS station,
    MIN(start_lat) AS minimum_latitude,
    MAX(start_lat) AS maximum_latitude,
    MIN(start_lng) AS minimum_longitude,
    MAX(start_lng) AS maximum_longitude
FROM a
WHERE start_station_name != ''
GROUP BY start_station_name;

-- Attempt 1: Fill missing start_station_name values
UPDATE b, c
SET b.start_station_name = c.station
WHERE
	b.start_lat BETWEEN c.minimum_latitude AND c.maximum_latitude
    AND b.start_lng BETWEEN c.minimum_longitude AND c.maximum_latitude;

DELETE FROM b
WHERE start_station_name = '';

UPDATE a
INNER JOIN b
ON (a.ride_id = b.ride_id)
SET a.start_station_name = b.start_station_name;

-- Attempt 2: Fill missing start_station_name values
DELETE FROM a
WHERE start_station_name = '';

SELECT *
FROM a
UNION
SELECT *
FROM b;

-- Fill end_station_name

--  Get missing end_station_name values
DROP TEMPORARY TABLE IF EXISTS d;
CREATE TEMPORARY TABLE d
SELECT ride_id, end_station_name, end_lat, end_lng
FROM a
WHERE end_station_name = '';

-- Calculate minimum and maximum longitudes
DROP TEMPORARY TABLE IF EXISTS e;
CREATE TEMPORARY TABLE e
SELECT
	end_station_name AS station,
    MIN(end_lat) AS minimum_latitude,
    MAX(end_lat) AS maximum_latitude,
    MIN(end_lng) AS minimum_longitude,
    MAX(end_lng) AS maximum_longitude
FROM a
WHERE end_station_name != ''
GROUP BY end_station_name;

-- Fill missing end_station_name values using table e
UPDATE d, e
SET d.end_station_name = e.station
WHERE
	d.end_station_name = ''
	AND (d.end_lat BETWEEN e.minimum_latitude AND e.maximum_latitude
	OR d.end_lng BETWEEN e.minimum_longitude AND e.maximum_longitude);

-- Remove rows that were not updated
DELETE FROM d
WHERE end_station_name = '';

-- Update end_station_name values in table a
UPDATE a
INNER JOIN d
ON (a.ride_id = d.ride_id)
SET a.end_station_name = d.end_station_name; */
    
-- In lieu of this, I decided to just remove all rows with unknown station names. This removed 645,593 rows
DELETE FROM a
WHERE start_station_name = '' OR end_station_name = '';

-- --------------------- --
-- Transforming the data --
-- --------------------- --

-- Aside from the trip_duration column, I added a column that measures the distance between the start station and end station. Distance shown is in meters
ALTER TABLE a
ADD COLUMN trip_distance INT
GENERATED ALWAYS AS (ST_Distance_Sphere(POINT(a.start_lng, a.start_lat), POINT(a.end_lng, a.end_lat)));

-- I added a column the classifies the time of the day
ALTER TABLE a
ADD COLUMN time_period VARCHAR(9)
AS
(
CASE
	WHEN DATE_FORMAT(a.started_at, '%H:%i:%s') BETWEEN '05:00:00' AND '11:59:59' THEN 'Morning'
    WHEN DATE_FORMAT(a.started_at, '%H:%i:%s') BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
    WHEN DATE_FORMAT(a.started_at, '%H:%i:%s') BETWEEN '17:00:00' AND '19:59:59' THEN 'Evening'
    WHEN DATE_FORMAT(a.started_at, '%H:%i:%s') BETWEEN '20:00:00' AND '04:59:59' THEN 'Night'
    ELSE 'Night'
END
);

-- I also added a column of the day of the week of the trip
ALTER TABLE a
ADD COLUMN day_of_week VARCHAR(9)
GENERATED ALWAYS AS (DAYNAME(a.started_at));

-- Lastly, I add a column of the season that the trip falls on
ALTER TABLE a
ADD COLUMN season CHAR(6)
AS
(
CASE
	WHEN a.started_at BETWEEN '2020-09-01 00:00:00' AND '2020-12-20 23:59:59' THEN 'Autumn'
    WHEN a.started_at BETWEEN '2020-12-21 00:00:00' AND '2021-03-19 23:59:59' THEN 'Winter'
    WHEN a.started_at BETWEEN '2021-03-20 00:00:00' AND '2021-06-19 23:59:59' THEN 'Spring'
    WHEN a.started_at BETWEEN '2021-06-20 00:00:00' AND '2021-09-21 23:59:59' THEN 'Summer'
    ELSE ''
END
);

-- I selected the columns that I need for analysis and visualization in Tableau
CREATE TABLE divvy
SELECT
	member_casual AS user_type,
    started_at AS start_time,
    ended_at AS end_time,
    time_period,
    day_of_week,
    season,
    trip_duration,
    start_station_name AS start_station,
    start_lat AS start_latitude,
    start_lng AS start_longitude,
    end_station_name AS end_station,
    end_lat AS end_latitude,
    end_lng AS end_longitude,
    trip_distance
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/divvy.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
FROM a;
