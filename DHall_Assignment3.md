# Assignment 3 - Normalizing Data in a Real Estate Database
## Objective:
Design and normalize a simplistic database for a real estate platform that stores property details, including spatial data. The assignment will take you through creating an initial table structure and progressively normalizing it to the Third Normal Form (3NF) and Fourth Normal Form (4NF). Additionally, you will use PostgreSQL with the PostGIS extension for handling spatial data.

### Part 1: Initial Setup
Creating new database **RealEstateDB**
```
CREATE DATABASE "RealEstateDB"; 
```
Double quotations to preserve case sensitivity.

*SQL Shell: Connect database and enable the PostGIS extension for spatial data*
*Connect to RealEstateDB*
~~~
\c RealEstateDB
~~~
*Enables PostGIS*
~~~
 CREATE EXTENSION IF NOT EXISTS postgis;
~~~

### Part 2: Creating the Initial Table
 **PropertyDetails** : table being created violates normalized principles*
~~~
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
~~~
The table is in 1NF because:
1. Each column holds atomic indivisible values
2. Rows are uniquely identifiable by PropertyID (primarykey)

The table is also in 2NF because
1. The table is in 1NF 
2. There are no partial dependencies because there are no composite primary keys

### Part 3: Normalize to 3NF
To normalize to 3NF: 
1. Remove transitive dependencies, so all attributes are DIRECTLY dependent on primary key
2. **PropertyDetails** Table altered and **CityDemographics** table created

* As of now, city, state, country and citypop are all transitively dependent
EX: If the citypop is known, the city, state and country is also known *
~~~
 CREATE TABLE CityDemographics (
    City VARCHAR(100) PRIMARY KEY,
    State VARCHAR(50),
    Country VARCHAR(50),
    CityPopulation INT
);
~~~

Dropping columns added to the **CityDemographics** table
~~~
ALTER TABLE PropertyDetails DROP COLUMN CityPopulation, DROP COLUMN State, DROP COLUMN Country;
~~~

### Part 4: Normalize to 4NF
To normalize into 4NF:
1. Need to address multi-valued dependencies by creating seperate tables for Zoning and Utility. 
As of now, there are multi-valued dependencies in **PropertyDetails** table. Where for each PropertyID, there are unique values from the ZoningType and Utility attributes.

~~~
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
~~~

Then remove columns from **PropertyDetails**
~~~
ALTER TABLE PropertyDetails DROP COLUMN ZoningType, DROP COLUMN Utility;
~~~

### Part 5: Spatial Data Manipulation
Using PostGIS extension, we are going to query spatial data

1. Insert a property with GeoLocation
~~~
INSERT INTO PropertyDetails (Address, City, GeoLocation)
VALUES ('123 Main St', 'Springfield', ST_GeomFromText('POINT(-89.6501483 39.7817213)', 4326));
~~~
- Inserting it into the propertydetails table with the address, city and geolocation
- values indicates the values to be inserted - *ST_GeomFromText* inserts the point data with the transformation

2. Query Properties within a Radius

~~~
SELECT Address, City
FROM PropertyDetails
WHERE ST_DWithin(
    GeoLocation,
    ST_GeomFromText('POINT(-89.6501483 39.7817213)', 4326),
    10000 -- 10km radius
);
~~~


*ST_DWithin* selects within a radius of 10000 to 10 km of that certain geometry

