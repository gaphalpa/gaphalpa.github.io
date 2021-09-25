DROP TABLE IF EXISTS dbo.divvy_trip_data
SELECT
	*,
	DATEDIFF(MINUTE,started_at,ended_at) AS trip_length, -- Creates 'trip_length' column that returns the duration of the trip in minutes
	DATENAME(dw,started_at) AS day_of_week, -- Creates 'day_of_week' column that returns the day when the trip occurred
	Geography::Point(start_lat,start_lng,4326).STDistance(Geography::Point(end_lat,end_lng,4326)) AS trip_distance -- Creates 'trip_distance' column that returns the distance traveled by rider
INTO
	divvy_trip_data -- Compiled and cleaned table for analysis
FROM
(
	-- All trip data csv files are compiled using UNION and CAST according to their appropriate data types
	SELECT
		CAST(ride_id AS VARCHAR(16)) AS ride_id, 
		CAST(rideable_type AS CHAR(13)) AS rideable_type,
		CAST(started_at AS DATETIME) AS started_at,
		CAST(ended_at AS DATETIME) AS ended_at,
		CAST(start_station_name AS VARCHAR(53)) AS start_station_name,
		CAST(start_station_id AS VARCHAR(36)) AS start_station_id,
		CAST(end_station_name AS VARCHAR(53)) AS end_station_name,
		CAST(end_station_id AS VARCHAR(36)) AS end_station_id,
		CAST(start_lat AS FLOAT) AS start_lat,
		CAST(start_lng AS FLOAT) AS start_lng,
		CAST(end_lat AS FLOAT) AS end_lat,
		CAST(end_lng AS FLOAT) AS end_lng,
		CAST(member_casual AS CHAR(6)) AS member_casual
	FROM dbo.tripdata202009
	UNION -- Excludes any duplicates
	SELECT
		CAST(ride_id AS VARCHAR(16)) AS ride_id,
		CAST(rideable_type AS CHAR(13)) AS rideable_type,
		CAST(started_at AS DATETIME) AS started_at,
		CAST(ended_at AS DATETIME) AS ended_at,
		CAST(start_station_name AS VARCHAR(53)) AS start_station_name,
		CAST(start_station_id AS VARCHAR(36)) AS start_station_id,
		CAST(end_station_name AS VARCHAR(53)) AS end_station_name,
		CAST(end_station_id AS VARCHAR(36)) AS end_station_id,
		CAST(start_lat AS FLOAT) AS start_lat,
		CAST(start_lng AS FLOAT) AS start_lng,
		CAST(end_lat AS FLOAT) AS end_lat,
		CAST(end_lng AS FLOAT) AS end_lng,
		CAST(member_casual AS CHAR(6)) AS member_casual
	FROM dbo.tripdata202010
	UNION
	SELECT
		CAST(ride_id AS VARCHAR(16)) AS ride_id,
		CAST(rideable_type AS CHAR(13)) AS rideable_type,
		CAST(started_at AS DATETIME) AS started_at,
		CAST(ended_at AS DATETIME) AS ended_at,
		CAST(start_station_name AS VARCHAR(53)) AS start_station_name,
		CAST(start_station_id AS VARCHAR(36)) AS start_station_id,
		CAST(end_station_name AS VARCHAR(53)) AS end_station_name,
		CAST(end_station_id AS VARCHAR(36)) AS end_station_id,
		CAST(start_lat AS FLOAT) AS start_lat,
		CAST(start_lng AS FLOAT) AS start_lng,
		CAST(end_lat AS FLOAT) AS end_lat,
		CAST(end_lng AS FLOAT) AS end_lng,
		CAST(member_casual AS CHAR(6)) AS member_casual
	FROM dbo.tripdata202011
	UNION
	SELECT
		CAST(ride_id AS VARCHAR(16)) AS ride_id,
		CAST(rideable_type AS CHAR(13)) AS rideable_type,
		CAST(started_at AS DATETIME) AS started_at,
		CAST(ended_at AS DATETIME) AS ended_at,
		CAST(start_station_name AS VARCHAR(53)) AS start_station_name,
		CAST(start_station_id AS VARCHAR(36)) AS start_station_id,
		CAST(end_station_name AS VARCHAR(53)) AS end_station_name,
		CAST(end_station_id AS VARCHAR(36)) AS end_station_id,
		CAST(start_lat AS FLOAT) AS start_lat,
		CAST(start_lng AS FLOAT) AS start_lng,
		CAST(end_lat AS FLOAT) AS end_lat,
		CAST(end_lng AS FLOAT) AS end_lng,
		CAST(member_casual AS CHAR(6)) AS member_casual
	FROM dbo.tripdata202012
	UNION
	SELECT
		CAST(ride_id AS VARCHAR(16)) AS ride_id,
		CAST(rideable_type AS CHAR(13)) AS rideable_type,
		CAST(started_at AS DATETIME) AS started_at,
		CAST(ended_at AS DATETIME) AS ended_at,
		CAST(start_station_name AS VARCHAR(53)) AS start_station_name,
		CAST(start_station_id AS VARCHAR(36)) AS start_station_id,
		CAST(end_station_name AS VARCHAR(53)) AS end_station_name,
		CAST(end_station_id AS VARCHAR(36)) AS end_station_id,
		CAST(start_lat AS FLOAT) AS start_lat,
		CAST(start_lng AS FLOAT) AS start_lng,
		CAST(end_lat AS FLOAT) AS end_lat,
		CAST(end_lng AS FLOAT) AS end_lng,
		CAST(member_casual AS CHAR(6)) AS member_casual
	FROM dbo.tripdata202101
	UNION
	SELECT
		CAST(ride_id AS VARCHAR(16)) AS ride_id,
		CAST(rideable_type AS CHAR(13)) AS rideable_type,
		CAST(started_at AS DATETIME) AS started_at,
		CAST(ended_at AS DATETIME) AS ended_at,
		CAST(start_station_name AS VARCHAR(53)) AS start_station_name,
		CAST(start_station_id AS VARCHAR(36)) AS start_station_id,
		CAST(end_station_name AS VARCHAR(53)) AS end_station_name,
		CAST(end_station_id AS VARCHAR(36)) AS end_station_id,
		CAST(start_lat AS FLOAT) AS start_lat,
		CAST(start_lng AS FLOAT) AS start_lng,
		CAST(end_lat AS FLOAT) AS end_lat,
		CAST(end_lng AS FLOAT) AS end_lng,
		CAST(member_casual AS CHAR(6)) AS member_casual
	FROM dbo.tripdata202102
	UNION
	SELECT
		CAST(ride_id AS VARCHAR(16)) AS ride_id,
		CAST(rideable_type AS CHAR(13)) AS rideable_type,
		CAST(started_at AS DATETIME) AS started_at,
		CAST(ended_at AS DATETIME) AS ended_at,
		CAST(start_station_name AS VARCHAR(53)) AS start_station_name,
		CAST(start_station_id AS VARCHAR(36)) AS start_station_id,
		CAST(end_station_name AS VARCHAR(53)) AS end_station_name,
		CAST(end_station_id AS VARCHAR(36)) AS end_station_id,
		CAST(start_lat AS FLOAT) AS start_lat,
		CAST(start_lng AS FLOAT) AS start_lng,
		CAST(end_lat AS FLOAT) AS end_lat,
		CAST(end_lng AS FLOAT) AS end_lng,
		CAST(member_casual AS CHAR(6)) AS member_casual
	FROM dbo.tripdata202103
	UNION
	SELECT
		CAST(ride_id AS VARCHAR(16)) AS ride_id,
		CAST(rideable_type AS CHAR(13)) AS rideable_type,
		CAST(started_at AS DATETIME) AS started_at,
		CAST(ended_at AS DATETIME) AS ended_at,
		CAST(start_station_name AS VARCHAR(53)) AS start_station_name,
		CAST(start_station_id AS VARCHAR(36)) AS start_station_id,
		CAST(end_station_name AS VARCHAR(53)) AS end_station_name,
		CAST(end_station_id AS VARCHAR(36)) AS end_station_id,
		CAST(start_lat AS FLOAT) AS start_lat,
		CAST(start_lng AS FLOAT) AS start_lng,
		CAST(end_lat AS FLOAT) AS end_lat,
		CAST(end_lng AS FLOAT) AS end_lng,
		CAST(member_casual AS CHAR(6)) AS member_casual
	FROM dbo.tripdata202104
	UNION
	SELECT
		CAST(ride_id AS VARCHAR(16)) AS ride_id,
		CAST(rideable_type AS CHAR(13)) AS rideable_type,
		CAST(started_at AS DATETIME) AS started_at,
		CAST(ended_at AS DATETIME) AS ended_at,
		CAST(start_station_name AS VARCHAR(53)) AS start_station_name,
		CAST(start_station_id AS VARCHAR(36)) AS start_station_id,
		CAST(end_station_name AS VARCHAR(53)) AS end_station_name,
		CAST(end_station_id AS VARCHAR(36)) AS end_station_id,
		CAST(start_lat AS FLOAT) AS start_lat,
		CAST(start_lng AS FLOAT) AS start_lng,
		CAST(end_lat AS FLOAT) AS end_lat,
		CAST(end_lng AS FLOAT) AS end_lng,
		CAST(member_casual AS CHAR(6)) AS member_casual
	FROM dbo.tripdata202105
	UNION
	SELECT
		CAST(ride_id AS VARCHAR(16)) AS ride_id,
		CAST(rideable_type AS CHAR(13)) AS rideable_type,
		CAST(started_at AS DATETIME) AS started_at,
		CAST(ended_at AS DATETIME) AS ended_at,
		CAST(start_station_name AS VARCHAR(53)) AS start_station_name,
		CAST(start_station_id AS VARCHAR(36)) AS start_station_id,
		CAST(end_station_name AS VARCHAR(53)) AS end_station_name,
		CAST(end_station_id AS VARCHAR(36)) AS end_station_id,
		CAST(start_lat AS FLOAT) AS start_lat,
		CAST(start_lng AS FLOAT) AS start_lng,
		CAST(end_lat AS FLOAT) AS end_lat,
		CAST(end_lng AS FLOAT) AS end_lng,
		CAST(member_casual AS CHAR(6)) AS member_casual
	FROM dbo.tripdata202106
	UNION
	SELECT
		CAST(ride_id AS VARCHAR(16)) AS ride_id,
		CAST(rideable_type AS CHAR(13)) AS rideable_type,
		CAST(started_at AS DATETIME) AS started_at,
		CAST(ended_at AS DATETIME) AS ended_at,
		CAST(start_station_name AS VARCHAR(53)) AS start_station_name,
		CAST(start_station_id AS VARCHAR(36)) AS start_station_id,
		CAST(end_station_name AS VARCHAR(53)) AS end_station_name,
		CAST(end_station_id AS VARCHAR(36)) AS end_station_id,
		CAST(start_lat AS FLOAT) AS start_lat,
		CAST(start_lng AS FLOAT) AS start_lng,
		CAST(end_lat AS FLOAT) AS end_lat,
		CAST(end_lng AS FLOAT) AS end_lng,
		CAST(member_casual AS CHAR(6)) AS member_casual
	FROM dbo.tripdata202107
	UNION
	SELECT
		CAST(ride_id AS VARCHAR(16)) AS ride_id,
		CAST(rideable_type AS CHAR(13)) AS rideable_type,
		CAST(started_at AS DATETIME) AS started_at,
		CAST(ended_at AS DATETIME) AS ended_at,
		CAST(start_station_name AS VARCHAR(53)) AS start_station_name,
		CAST(start_station_id AS VARCHAR(36)) AS start_station_id,
		CAST(end_station_name AS VARCHAR(53)) AS end_station_name,
		CAST(end_station_id AS VARCHAR(36)) AS end_station_id,
		CAST(start_lat AS FLOAT) AS start_lat,
		CAST(start_lng AS FLOAT) AS start_lng,
		CAST(end_lat AS FLOAT) AS end_lat,
		CAST(end_lng AS FLOAT) AS end_lng,
		CAST(member_casual AS CHAR(6)) AS member_casual
	FROM dbo.tripdata202108
) as tripdata_all
WHERE
	start_station_name IS NOT NULL -- This excludes trips that do not have data on starting location and are thus incomplete trips
	AND end_station_name IS NOT NULL -- This excludes trips that do not have data on ending location and are thus incomplete trips
	AND start_station_name <> end_station_name -- This excludes trips that have the same starting and ending location, which means that they are not comlpleted trips
	AND DATEDIFF(MINUTE,started_at,ended_at) > 0 -- This excludes trips that have a starting time that is later than the ending time, meaning they are dirty data
	AND DATEDIFF(MINUTE,started_at,ended_at) < 60 * 24 -- This excludes trips that lasted for more than 24 hours which are prohibited by the app

-- This query selects relevant columns to be used for visualization
SELECT
	member_casual AS rider_type,
	started_at AS start_time,
	ended_at AS end_time,
	start_station_name AS start_station,
	end_station_name AS end_station,
	trip_length,
	day_of_week,
	ROUND(trip_distance,0) AS trip_distance -- The ROUND function is used to improve readability in visualization
FROM divvy_trip_data