-- Create the cleaned crime incidents table

USE philadelphia_crime;

DROP TABLE IF EXISTS crime_incidents_clean;

CREATE TABLE crime_incidents_clean (
    dc_key VARCHAR(20),
    dispatch_date DATE,
    dispatch_time TIME,
    hour TINYINT,
    text_general_code VARCHAR(150),
    ucr_general VARCHAR(30),
    dc_dist VARCHAR(10),
    psa VARCHAR(10),
    location_block VARCHAR(255),
    point_x DOUBLE,
    point_y DOUBLE
);

-- Clean and load the raw data
INSERT INTO crime_incidents_clean
SELECT DISTINCT

    -- Remove decimals from incident ID
    SUBSTRING_INDEX(dc_key, '.', 1),

    -- Standardize date format
    IF(
        dispatch_date LIKE '%/%',
        STR_TO_DATE(dispatch_date, '%m/%d/%Y'),
        STR_TO_DATE(dispatch_date, '%Y-%m-%d')
    ),

    -- Convert blank values to NULL
    NULLIF(dispatch_time, ''),
    NULLIF(hour, ''),

    text_general_code,
    ucr_general,
    dc_dist,
    NULLIF(psa, ''),
    NULLIF(location_block, ''),
    NULLIF(point_x, ''),
    NULLIF(point_y, '')

FROM crime_incidents_raw;


-- Preview cleaned data
SELECT *
FROM crime_incidents_clean
LIMIT 10;


-- Check total cleaned rows
SELECT COUNT(*) AS clean_rows
FROM crime_incidents_clean;


-- Check records by year
SELECT
    YEAR(dispatch_date) AS year,
    COUNT(*) AS reported_incidents
FROM crime_incidents_clean
GROUP BY YEAR(dispatch_date)
ORDER BY year;


-- Check remaining missing values
SELECT
    SUM(hour IS NULL) AS missing_hour,
    SUM(psa IS NULL) AS missing_psa,
    SUM(location_block IS NULL) AS missing_location,
    SUM(point_x IS NULL) AS missing_point_x,
    SUM(point_y IS NULL) AS missing_point_y
FROM crime_incidents_clean;