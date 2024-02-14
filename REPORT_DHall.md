In this assignment, a relational database was designed and normalized to 
fit the first and second normal forms using PstgreSQL and PostGIS extension.

We first started with an example table that violates the 1NF; "Parks_Info". Parks_Info violates 1NF because in the Facilities column, there are values that repeat, meaning they are not unique. Picnic area, Restroom, and Playground are all values that repeat within the Facilities column. 


Normalizing Parks_Info to 1NF:
Three tables were created, Parks, and Facilities to eliminate parital dependencies between the columns of Parks_Info. Values were inserted into the table. To relate the Facilities and Parks tables, a FOREIGN KEY of ParkID was created in the Facilities that references ParkID. After this, the table Parks_Info has been normalized to 1NF because each of the values within each row are indivisible, and columns contain values of a single type. Additionally, the foreign key ParkID is used to relate the two tables. 

Normalizing Tables into 2NF:
To eliminate partial dependency between tables, Parks and Facilities. A partial dependency exists between the ParksID fields. A ParkFacilities Table is created to store unique list of types of facilities. A ParkFaciltiesID is also added to the table as a foreign key to relate the ParkFacilities table to the Facilities table. This eliminates the partial dependency between Parks and Facilities, conforming the table to 2NF.

Challenges:
The only challenges faced were in intially adding the wrong parkid values to the Facilities table. The parkid values were not checked and the table Parks was not viewed to make sure that the parkids were assigned to be the same. This issue was fixed by dropping the table in a new sql query and creating a new table and inserting the correct parkids that match those int he parks table.
