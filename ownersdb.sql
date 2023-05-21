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

/* Create the pets table using the available features of the CREATE TABLE
 statement */
 
CREATE TABLE pets (
    petid varchar,
    name varchar,
    kind varchar,
    gender varchar,
    age int,
    ownerid varchar
);

COPY pets
FROM 'C:\Users\admin\Desktop\Sql Project\Pets.csv'
DELIMITER ',' 
CSV HEADER

/* Create the procudure details table using the available features of the CREATE TABLE
 statement */
 
CREATE TABLE proceduredetails (
    proceduretype varchar,
    proceduresubcode varchar,
    description varchar,
    price float
);

COPY proceduredetails
FROM 'C:\Users\admin\Desktop\Sql Project\ProceduresDetails.csv'
DELIMITER ',' 
CSV HEADER

/* Create the procudure history table using the available features of the CREATE TABLE
 statement */
 
CREATE TABLE procedurehistory (
    petid varchar,
    proceduredate date,
    proceduretype varchar,
    proceduresubcode varchar
);

COPY procedurehistory 
FROM 'C:\Users\admin\Desktop\Sql Project\ProceduresHistory.csv'
DELIMITER ',' 
CSV HEADER;
