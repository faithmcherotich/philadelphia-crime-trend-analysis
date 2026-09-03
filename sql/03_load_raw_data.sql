-- Load raw crime data

USE philadelphia_crime;

-- Clear the raw table before reloading the files
TRUNCATE TABLE crime_incidents_raw;

-- 2021
LOAD DATA LOCAL INFILE 'C:/Users/faith/Desktop/crime_trends_analysis/data/raw/crime_incidents_2021.csv'
INTO TABLE crime_incidents_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(dc_key, dispatch_date, dispatch_time, hour,
 text_general_code, ucr_general, dc_dist, psa,
 location_block, point_x, point_y);

-- 2022
LOAD DATA LOCAL INFILE 'C:/Users/faith/Desktop/crime_trends_analysis/data/raw/crime_incidents_2022.csv'
INTO TABLE crime_incidents_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(dc_key, dispatch_date, dispatch_time, hour,
 text_general_code, ucr_general, dc_dist, psa,
 location_block, point_x, point_y);

-- 2023
LOAD DATA LOCAL INFILE 'C:/Users/faith/Desktop/crime_trends_analysis/data/raw/crime_incidents_2023.csv'
INTO TABLE crime_incidents_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(dc_key, dispatch_date, dispatch_time, hour,
 text_general_code, ucr_general, dc_dist, psa,
 location_block, point_x, point_y);

-- 2024
LOAD DATA LOCAL INFILE 'C:/Users/faith/Desktop/crime_trends_analysis/data/raw/crime_incidents_2024.csv'
INTO TABLE crime_incidents_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(dc_key, dispatch_date, dispatch_time, hour,
 text_general_code, ucr_general, dc_dist, psa,
 location_block, point_x, point_y);

-- 2025
LOAD DATA LOCAL INFILE 'C:/Users/faith/Desktop/crime_trends_analysis/data/raw/crime_incidents_2025.csv'
INTO TABLE crime_incidents_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(dc_key, dispatch_date, dispatch_time, hour,
 text_general_code, ucr_general, dc_dist, psa,
 location_block, point_x, point_y);

-- Check number of imported records by year
SELECT
    YEAR(
        COALESCE(
            STR_TO_DATE(TRIM(dispatch_date), '%Y-%m-%d'),
            STR_TO_DATE(TRIM(dispatch_date), '%m/%d/%Y')
        )
    ) AS year,
    COUNT(*) AS reported_incidents
FROM crime_incidents_raw
GROUP BY year
ORDER BY year;