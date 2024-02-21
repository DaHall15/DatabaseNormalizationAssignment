-- Creating database REalEstateDB
CREATE DATABASE "RealEstateDB"; 

-- Connecting database and enabling PostGIS extension for spatial data
-- THis is using SQL Shell
\c RealEstateDB;

CREATE EXTENSION IF NOT EXISTS postgis;

-- Creating initial table of PropertyDetails
CREATE TABLE PropertyDetails (
    PropertyID SERIAL PRIMARY KEY,
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(50),
    Country VARCHAR(50),
    ZoningType VARCHAR(100),
    Utility VARCHAR(100),
    GeoLocation GEOMETRY(Point, 4326), -- Spatial data type
    CityPopulation INT
);

-- Creating CityDEmographics table to convert initial table to 3NF
CREATE TABLE CityDemographics (
    City VARCHAR(100) PRIMARY KEY,
    State VARCHAR(50),
    Country VARCHAR(50),
    CityPopulation INT
);

-- Dropping columns that were copied to CityDemographics Table
ALTER TABLE PropertyDetails DROP COLUMN CityPopulation, DROP COLUMN State, DROP COLUMN Country;

-- Creating PropertyZoning and Property Utilities table to normalize to 4NF, adressing multi-valued dependencies
CREATE TABLE PropertyZoning (
    PropertyZoningID SERIAL PRIMARY KEY,
    PropertyID INT REFERENCES PropertyDetails(PropertyID),
    ZoningType VARCHAR(100)
);

CREATE TABLE PropertyUtilities (
    PropertyUtilityID SERIAL PRIMARY KEY,
    PropertyID INT REFERENCES PropertyDetails(PropertyID),
    Utility VARCHAR(100)
);

-- Removing columns from PropertyDetails that were added to PropertyZoning and PropertyUtilities
ALTER TABLE PropertyDetails DROP COLUMN ZoningType, DROP COLUMN Utility;

-- Inserting Spatial Data into Property Details Table
INSERT INTO PropertyDetails (Address, City, GeoLocation)
VALUES ('123 Main St', 'Springfield', ST_GeomFromText('POINT(-89.6501483 39.7817213)', 4326));

-- Querying spatial data based on the distance within using ST_DWithin
SELECT Address, City
FROM PropertyDetails
WHERE ST_DWithin(
    GeoLocation,
    ST_GeomFromText('POINT(-89.6501483 39.7817213)', 4326),
    10000 -- 10km radius
);