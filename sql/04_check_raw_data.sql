-- Check raw data quality

USE philadelphia_crime;

-- Check missing values
SELECT
    SUM(dc_key IS NULL OR TRIM(dc_key) = '') AS missing_dc_key,
    SUM(dispatch_date IS NULL OR TRIM(dispatch_date) = '') AS missing_date,
    SUM(dispatch_time IS NULL OR TRIM(dispatch_time) = '') AS missing_time,
    SUM(hour IS NULL OR TRIM(hour) = '') AS missing_hour,
    SUM(text_general_code IS NULL OR TRIM(text_general_code) = '') AS missing_crime_type,
    SUM(ucr_general IS NULL OR TRIM(ucr_general) = '') AS missing_ucr,
    SUM(dc_dist IS NULL OR TRIM(dc_dist) = '') AS missing_district,
    SUM(psa IS NULL OR TRIM(psa) = '') AS missing_psa,
    SUM(location_block IS NULL OR TRIM(location_block) = '') AS missing_location,
    SUM(point_x IS NULL OR TRIM(point_x) = '') AS missing_point_x,
    SUM(point_y IS NULL OR TRIM(point_y) = '') AS missing_point_y
FROM crime_incidents_raw;


-- Check missing hour values by year
SELECT
    YEAR(
        COALESCE(
            STR_TO_DATE(TRIM(dispatch_date), '%Y-%m-%d'),
            STR_TO_DATE(TRIM(dispatch_date), '%m/%d/%Y')
        )
    ) AS year,
    COUNT(*) AS missing_hour
FROM crime_incidents_raw
WHERE hour IS NULL
   OR TRIM(hour) = ''
GROUP BY year
ORDER BY year;


-- Check duplicate incident IDs
SELECT
    dc_key,
    COUNT(*) AS occurrences
FROM crime_incidents_raw
GROUP BY dc_key
HAVING COUNT(*) > 1
ORDER BY occurrences DESC
LIMIT 10;


-- Count duplicated incident IDs
SELECT
    COUNT(*) AS duplicated_dc_keys
FROM (
    SELECT dc_key
    FROM crime_incidents_raw
    GROUP BY dc_key
    HAVING COUNT(*) > 1
) AS duplicates;


-- Count exact duplicate rows
SELECT
    SUM(occurrences - 1) AS extra_duplicate_rows
FROM (
    SELECT
        dc_key,
        dispatch_date,
        dispatch_time,
        hour,
        text_general_code,
        ucr_general,
        dc_dist,
        psa,
        location_block,
        point_x,
        point_y,
        COUNT(*) AS occurrences
    FROM crime_incidents_raw
    GROUP BY
        dc_key,
        dispatch_date,
        dispatch_time,
        hour,
        text_general_code,
        ucr_general,
        dc_dist,
        psa,
        location_block,
        point_x,
        point_y
    HAVING COUNT(*) > 1
) AS duplicates;


-- Check district values
SELECT
    dc_dist,
    COUNT(*) AS reported_incidents
FROM crime_incidents_raw
GROUP BY dc_dist
ORDER BY CAST(dc_dist AS UNSIGNED);