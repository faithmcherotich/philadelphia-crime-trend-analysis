-- Philadelphia Crime Trend Analysis
-- Analysis: 2021-2025

USE philadelphia_crime;


-- Q1. How has reported crime changed from 2021-2025?

-- Annual reported incidents
SELECT
    YEAR(dispatch_date) AS year,
    COUNT(*) AS reported_incidents
FROM crime_incidents_clean
GROUP BY YEAR(dispatch_date)
ORDER BY year;


-- Monthly reported incidents
SELECT
    DATE_FORMAT(dispatch_date, '%Y-%m') AS month,
    COUNT(*) AS reported_incidents
FROM crime_incidents_clean
GROUP BY month
ORDER BY month;


-- Compare 2021 and 2025
SELECT
    SUM(YEAR(dispatch_date) = 2021) AS incidents_2021,
    SUM(YEAR(dispatch_date) = 2025) AS incidents_2025,
    ROUND(
        (
            SUM(YEAR(dispatch_date) = 2025) -
            SUM(YEAR(dispatch_date) = 2021)
        )
        / SUM(YEAR(dispatch_date) = 2021) * 100,
        1
    ) AS percent_change
FROM crime_incidents_clean;



-- Q2. Which crime categories were reported most often?

-- Top 10 most reported crime categories
SELECT
    text_general_code AS crime_category,
    COUNT(*) AS reported_incidents
FROM crime_incidents_clean
GROUP BY text_general_code
ORDER BY reported_incidents DESC
LIMIT 10;



-- Q3. Which crime categories increased or decreased the most?

-- Compare category totals in 2021 and 2025
-- Include categories with at least 500 incidents in 2021
SELECT
    text_general_code AS crime_category,
    SUM(YEAR(dispatch_date) = 2021) AS incidents_2021,
    SUM(YEAR(dispatch_date) = 2025) AS incidents_2025,
    ROUND(
        (
            SUM(YEAR(dispatch_date) = 2025) -
            SUM(YEAR(dispatch_date) = 2021)
        )
        / SUM(YEAR(dispatch_date) = 2021) * 100,
        1
    ) AS percent_change
FROM crime_incidents_clean
GROUP BY text_general_code
HAVING incidents_2021 >= 500
ORDER BY percent_change DESC;



-- Q4. Are there seasonal patterns in reported crime?

-- Monthly reported incidents across all five years
SELECT
    MONTH(dispatch_date) AS month_number,
    MONTHNAME(dispatch_date) AS month,
    COUNT(*) AS reported_incidents
FROM crime_incidents_clean
GROUP BY
    MONTH(dispatch_date),
    MONTHNAME(dispatch_date)
ORDER BY month_number;


-- Compare monthly patterns by year
SELECT
    YEAR(dispatch_date) AS year,
    MONTH(dispatch_date) AS month_number,
    MONTHNAME(dispatch_date) AS month,
    COUNT(*) AS reported_incidents
FROM crime_incidents_clean
GROUP BY
    YEAR(dispatch_date),
    MONTH(dispatch_date),
    MONTHNAME(dispatch_date)
ORDER BY
    year,
    month_number;



-- Q5. Which police districts reported the most incidents?

-- Top 10 districts across 2021-2025
SELECT
    dc_dist AS district,
    COUNT(*) AS reported_incidents
FROM crime_incidents_clean
WHERE dc_dist IS NOT NULL
GROUP BY dc_dist
ORDER BY reported_incidents DESC
LIMIT 10;


-- Reported incidents by district and year
SELECT
    YEAR(dispatch_date) AS year,
    dc_dist AS district,
    COUNT(*) AS reported_incidents
FROM crime_incidents_clean
WHERE dc_dist IS NOT NULL
GROUP BY
    YEAR(dispatch_date),
    dc_dist
ORDER BY
    year,
    reported_incidents DESC;