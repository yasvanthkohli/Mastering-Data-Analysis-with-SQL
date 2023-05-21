/* Create the owners table using the available features of the CREATE TABLE
 statement */
 
CREATE TABLE owners (
    ownerid varchar,
    name varchar,
    surname varchar,
    streetaddress varchar,
    city varchar,
    state varchar(2),
    statefull varchar,
    zipcode varchar
);

COPY owners
FROM 'C:\Users\admin\Desktop\Sql Project\Owners.csv'
DELIMITER ','
CSV HEADER;
