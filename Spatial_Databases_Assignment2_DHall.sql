-- D.Hall Assignment 2 Spatial Databases --

-- Assignment 2: Database Normalization using PostgreSQL with PostGIS Extension

-- Creating "dataNorm" database
CREATE DATABASE dataNorm

-- "Parks_Info" : Creating first table --
CREATE TABLE Parks_Info (
ID SERIAL PRIMARY KEY, 
ParkName VARCHAR(255),
Facilities VARCHAR(255));

-- "Parks_Info" :  Inserting Values into Table
INSERT INTO Parks_Info (ParkNAme, Facilities)
VALUES ('Central Park', 'Playground, Restroom, Picnics area'),
('Liberty Park', 'Restroom, Picnic area'),
('Riverside Park', 'Playground, Bike Path');

-- Normalizing the Data by splitting into different tables

-- "Parks" : Table creatation
CREATE TABLE Parks (
ParkID SERIAL PRIMARY KEY,
ParkName VARCHAR (255));

-- "Facilities" : Table creatation
CREATE TABLE Facilities (
FacilityID SERIAL PRIMARY KEY,
ParkID INT,
FacilityName VARCHAR(255),
FOREIGN KEY (ParkID) REFERENCES Parks(ParkID)); --FOREIGN KEY : is ParkID


-- Inserting data into the dataframes --

-- Parks: Table data insert 
INSERT INTO Parks (ParkName)
SELECT DISTINCT ParkName FROM Parks_Info; 

-- BE SURE TO CHECK THE ORDER OF OBSERVATIONS AFTER THE PARKS INSERTION
-- THEN KNOWING THE ORDER/ID OF THE PARKS IN THE PARKS TABLE, WE NEED TO ASSIGN THE APPROPIRATE 
-- ID/NUMBER TO THE FACILITIES TABLE


-- Facilities : table data inserted
INSERT INTO Facilities (ParkID, FacilityName)
VALUES
(3, 'Playground'), ---SERIAL assigns a random value to the 
(3, 'Restroom'),
(3, 'Picnics area'),
(2, 'Restroom'),
(2, 'Picnics area'),
(1, 'Playground'),
(1, 'Bike Path'); 



-- View the table --
SELECT* FROM parks;
 -- or --
 SELECT* FROM facilities 


-- The order of the tables is messed up so need to fix the facilities IDs
DROP TABLE facilities -- This is remaking the table 

-- Then we re-created the Facilities Table --


-- 2NF Making Table --
INSERT INTO Facilities (ParkID, FacilityName)
VALUES
(3, 'Playground'), ---SERIAL assigns a random value to the 
(3, 'Restroom'),
(3, 'Picnics area'),
(2, 'Restroom'),
(2, 'Picnics area'),
(1, 'Playground'),
(1, 'Bike Path'); 

-- ParkFacilities : creating table --
CREATE TABLE ParkFacilities(
FacilityID SERIAL PRIMARY KEY,
FacilityName VARCHAR(255));

-- ParkFacilities : Inserting values we have control over, FacilityName
INSERT INTO ParkFacilities (FacilityName)
VALUES ('Playground'), ('Restroom'), ('Picnic area'), ('Bike Path');

-- Need to check which id numbers are where, 
SELECT * FROM ParkFacilities;

-- We now have tables: Parks, Facilities, ParkFacilities SOOOOOO
-- we need to relate them 


-- RELATING: Need to make sure tables are related using foriegn key parkid
-- Park and ParkFacilities only have the field parkID
-- Need all three tables to have a field that relates
-- Also, see line 43, in Facilities table, ParkID is established as the 
-- Foreign key, relating the Parks table using the ParkID field

-- Relating "Facilities" to "ParkFacilities" table --
ALTER TABLE Facilities ADD COLUMN ParkFacilityID INT; 

-- Adding a the "ParkFacilityID" field to Facilities table to have a 
-- link fromt the ParkFacilities to the Facilties table --

-- Facilities : altering ParkFacilityID column to make same/link to ParkFacilities table field
ALTER TABLE Facilities
ADD CONSTRAINT fk_parkfacilityid 
FOREIGN KEY (ParkFacilityID) REFERENCES ParkFacilities(FacilityID);

-- Facilities: cleaning up redundancy
-- Facility name is redundant, relationship maintained by facilityid field
-- Add FOREIGN KEY to enforce relationship between Facilities and ParkFacilities
-- FacilityID is the foreign key in the relationship   
UPDATE Facilities
SET ParkFacilityID = (SELECT FacilityID FROM ParkFacilities WHERE FacilityName = Facilities.FacilityName);

-- Cleanup redundant columns
ALTER TABLE Facilities DROP COLUMN FacilityName;

--Done!