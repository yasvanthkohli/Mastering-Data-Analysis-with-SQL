/* creating a database mydb */
CREATE DATABASE mydb;

/* using the created database */
USE mydb;

/* creating a table */
CREATE TABLE mytable
(
 id int unsigned NOT NULL auto_increment,
 username varchar(100) NOT NULL,
 email varchar(100) NOT NULL,
 PRIMARY KEY (id)
);

/* inserting a row into a table */
INSERT INTO mytable ( username, email )
VALUES ( "myuser", "myuser@example.com" );

/* Updating a row into a MySQL table */
UPDATE mytable SET username="myuser" WHERE id=8

/* Deleting a row into a table */
delete FROM mytable WHERE id=8

SELECT * FROM mytable WHERE username = "myuser";
show databases;
show tables;
SELECT * FROM mytable WHERE username = "myuser";
DESCRIBE tableName;

