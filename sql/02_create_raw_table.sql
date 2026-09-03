-- Create the raw crime incidents table

USE philadelphia_crime;

DROP TABLE IF EXISTS crime_incidents_raw;

CREATE TABLE crime_incidents_raw (
    dc_key VARCHAR(30),
    dispatch_date VARCHAR(30),
    dispatch_time VARCHAR(30),
    hour VARCHAR(10),
    text_general_code VARCHAR(150),
    ucr_general VARCHAR(30),
    dc_dist VARCHAR(10),
    psa VARCHAR(10),
    location_block VARCHAR(255),
    point_x VARCHAR(50),
    point_y VARCHAR(50)
);