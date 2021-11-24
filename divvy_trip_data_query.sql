-- ----------------------- --
-- Divvy Trip Data Summary --
-- ----------------------- --

/* In this project, I use SQL to explore trip data from bike-sharing app Divvy. The goal of this
    project is to clean data and transform it in a way that can explain how Divvy users behave. */

-- ----------------- --
-- Cleaning the data --
-- ----------------- --

-- Create temporary table of the original data; 4,913,083 rows
DROP TEMPORARY TABLE IF EXISTS a;
CREATE TEMPORARY TABLE a
SELECT *
FROM divvy_trip_data;

-- Add column that calculates duration of trip in minutes
ALTER TABLE a
ADD COLUMN trip_duration INT
GENERATED ALWAYS AS (TIMESTAMPDIFF(MINUTE, a.started_at, a.ended_at));

-- Remove rows where trip duration was less than 1 minute or 24 hours or more; 82,543 rows removed
DELETE FROM a
WHERE trip_duration < 1 OR trip_duration > 1439;

-- Remove rows with invalid time inputs; 96,845 rows removed
DELETE FROM a
WHERE started_at = '0000-00-00 00:00:00' OR ended_at = '0000-00-00 00:00:00';

-- Remove rows that were company test rides; 160 rows removed
DELETE FROM a
WHERE
    start_station_name LIKE '%test%'
    OR end_station_name LIKE '%test%';

-- Remove other company-related trips. 8 rows removed
DELETE FROM a
WHERE
    start_station_name LIKE '%divvy%'
    OR end_station_name LIKE '%divvy%';

-- Modify station names with unnecessary strings in parentheses; 128,083 rows affected
UPDATE a
SET
    start_station_name = REGEXP_REPLACE(start_station_name, '\\(\\w{2,}(\\s\\w{2,})*\\)', ''),
    end_station_name = REGEXP_REPLACE(end_station_name, '\\(\\w{2,}(\\s\\w{2,})*\\)', '')
WHERE
    start_station_name LIKE '%(%)%'
    OR end_station_name LIKE '%(%)%';
    
-- Modify station names containing "DuSable "; 80,246 rows affected
UPDATE a
SET
    start_station_name = REPLACE(start_station_name, 'DuSable ', ''),
    end_station_name = REPLACE(end_station_name, 'DuSable ', '')
WHERE
    start_station_name LIKE 'DuSable Lake%'
    OR end_station_name LIKE 'DuSable Lake%';

-- Remove nulls values; 1 row removed
DELETE FROM a
WHERE started_at IS NULL;
    
-- Remove rows with no station inputs; 644,185 rows removed
DELETE FROM a
WHERE
    start_station_name = ''
    OR end_station_name = '';

-- --------------------- --
-- Transforming the data --
-- --------------------- --

-- Add column that classifies time of day
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

-- Add column that gets day of week
ALTER TABLE a
ADD COLUMN day_of_week VARCHAR(9)
GENERATED ALWAYS AS (DAYNAME(a.started_at));

-- Add column that gets season
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

-- Create cleaned and transformed table & average out latitude and longitude values; 4,089,343 rows
DROP TABLE IF EXISTS divvy;
CREATE TABLE divvy
SELECT
    'user_type',
    'start_time',
    'end_time',
    'time_period',
    'day_of_week',
    'season',
    'trip_duration',
    'start_station',
    'start_latitude',
    'start_longitude',
    'end_station',
    'end_latitude',
    'end_longitude'
UNION ALL
SELECT
    member_casual user_type,
    started_at start_time,
    ended_at end_time,
    time_period,
    day_of_week,
    season,
    trip_duration,
    start_station_name start_station,
    AVG(start_lat) OVER (PARTITION BY start_station_name) start_latitude,
    AVG(start_lng) OVER (PARTITION BY start_station_name) start_longitude,
    end_station_name end_station,
    AVG(end_lat) OVER (PARTITION BY end_station_name) end_latitude,
    AVG(end_lng) OVER (PARTITION BY end_station_name) end_longitude
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/divvy.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM a;
