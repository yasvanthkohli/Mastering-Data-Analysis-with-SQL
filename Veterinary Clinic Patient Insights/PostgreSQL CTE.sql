/* Retrieve the names of all pets along with their owners' names using a CTE */
WITH pet_owners AS (
  SELECT p.name AS pet_name, o.name AS owner_name
  FROM pets p
  JOIN owners o ON p.ownerid = o.ownerid
)
SELECT pet_name, owner_name
FROM pet_owners;



/* Calculate the average age of pets by kind using a CTE */
WITH pet_averages AS (
  SELECT kind, AVG(age) AS average_age
  FROM pets
  GROUP BY kind
)
SELECT kind, average_age
FROM pet_averages;



/* Retrieve the procedures performed on pets along with their descriptions using a CTE */
WITH procedure_info AS (
  SELECT ph.petid, pd.description
  FROM procedurehistory ph
  JOIN proceduredetails pd ON ph.proceduretype = pd.proceduretype AND ph.proceduresubcode = pd.proceduresubcode
)
SELECT petid, description
FROM procedure_info;



/* Find the owners who have multiple pets and count the number of pets for each owner */
WITH owner_pets AS (
  SELECT ownerid, COUNT(*) AS pet_count
  FROM pets
  GROUP BY ownerid
  HAVING COUNT(*) > 1
)
SELECT o.name, o.surname, op.pet_count
FROM owners o
JOIN owner_pets op ON o.ownerid = op.ownerid;



/* Retrieve the pets and their owners' information, including the total number of pets for each owner */
WITH pet_owners AS (
  SELECT p.petid, p.name AS pet_name, o.ownerid, o.name AS owner_name, o.surname, COUNT(*) OVER (PARTITION BY o.ownerid) AS total_pets
  FROM pets p
  JOIN owners o ON p.ownerid = o.ownerid
)
SELECT petid, pet_name, ownerid, owner_name, surname, total_pets
FROM pet_owners;



/* Find the top 5 most expensive procedures and their average price */
WITH top_procedures AS (
  SELECT proceduretype, AVG(price) AS average_price
  FROM proceduredetails
  GROUP BY proceduretype
  ORDER BY AVG(price) DESC
  LIMIT 5
)
SELECT proceduretype, average_price
FROM top_procedures;



/* Retrieve the pets and their owners information, filtering only for owners who live in a specific city */
WITH pet_owners AS (
  SELECT p.petid, p.name AS pet_name, o.ownerid, o.name AS owner_name, o.surname, o.city
  FROM pets p
  JOIN owners o ON p.ownerid = o.ownerid
)
SELECT petid, pet_name, ownerid, owner_name, surname, city
FROM pet_owners
WHERE city = 'Southfield';



/* Calculate the total price of all procedures performed on each pet */
WITH pet_procedure_total AS (
  SELECT ph.petid, SUM(pd.price) AS total_price
  FROM procedurehistory ph
  JOIN proceduredetails pd ON ph.proceduretype = pd.proceduretype AND ph.proceduresubcode = pd.proceduresubcode
  GROUP BY ph.petid
)
SELECT p.petid, p.name AS pet_name, ppt.total_price
FROM pets p
JOIN pet_procedure_total ppt ON p.petid = ppt.petid;



/* Retrieve the pets and their owners' information, including the number of procedures performed on each pet */
WITH pet_procedure_count AS (
  SELECT p.petid, p.name AS pet_name, o.ownerid, o.name AS owner_name, o.surname, COUNT(ph.petid) AS procedure_count
  FROM pets p
  JOIN owners o ON p.ownerid = o.ownerid
  LEFT JOIN procedurehistory ph ON p.petid = ph.petid
  GROUP BY p.petid, p.name, o.ownerid, o.name, o.surname
)
SELECT petid, pet_name, ownerid, owner_name, surname, procedure_count
FROM pet_procedure_count;



/* Calculate the total price of procedures performed on each pet, along with the average price per procedure */
WITH pet_procedure_summary AS (
  SELECT ph.petid, SUM(pd.price) AS total_price, COUNT(*) AS procedure_count
  FROM procedurehistory ph
  JOIN proceduredetails pd ON ph.proceduretype = pd.proceduretype AND ph.proceduresubcode = pd.proceduresubcode
  GROUP BY ph.petid
)
SELECT p.petid, p.name AS pet_name, p.ownerid, pp.total_price, pp.procedure_count, pp.total_price / pp.procedure_count AS average_price_per_procedure
FROM pets p
JOIN pet_procedure_summary pp ON p.petid = pp.petid;



/* Calculate the average price per procedure type, excluding procedures with a price less than $50 */
WITH valid_procedures AS (
  SELECT *
  FROM proceduredetails
  WHERE price >= 50
),
procedure_avg_price AS (
  SELECT proceduretype, AVG(price) AS average_price
  FROM valid_procedures
  GROUP BY proceduretype
)
SELECT proceduretype, average_price
FROM procedure_avg_price;



/* Find the pets and their owners' information, along with the latest procedure performed on each pet */
WITH latest_procedure AS (
  SELECT DISTINCT ON (petid) petid, proceduredate, proceduretype, proceduresubcode
  FROM procedurehistory
  ORDER BY petid, proceduredate DESC
)
SELECT p.petid, p.name AS pet_name, o.ownerid, o.name AS owner_name, o.surname, lp.proceduredate, lp.proceduretype, lp.proceduresubcode
FROM pets p
JOIN owners o ON p.ownerid = o.ownerid
LEFT JOIN latest_procedure lp ON p.petid = lp.petid;



/* Find the owners who have pets of different kinds */
WITH owner_pet_kinds AS (
  SELECT ownerid, ARRAY_AGG(DISTINCT kind) AS pet_kinds
  FROM pets
  GROUP BY ownerid
)
SELECT o.ownerid, o.name, o.surname, o.city, o.state, opk.pet_kinds
FROM owners o
JOIN owner_pet_kinds opk ON o.ownerid = opk.ownerid
WHERE array_length(opk.pet_kinds, 1) > 1;



/* Calculate the total price of procedures performed on each pet and find the pet with the highest total price */
WITH pet_procedure_total AS (
  SELECT ph.petid, SUM(pd.price) AS total_price
  FROM procedurehistory ph
  JOIN proceduredetails pd ON ph.proceduretype = pd.proceduretype AND ph.proceduresubcode = pd.proceduresubcode
  GROUP BY ph.petid
)
SELECT p.petid, p.name AS pet_name, ppt.total_price
FROM pets p
JOIN pet_procedure_total ppt ON p.petid = ppt.petid
ORDER BY ppt.total_price DESC
LIMIT 1;



/* Find the owners who have pets of the same kind */
WITH owner_pet_kinds AS (
  SELECT ownerid, kind, COUNT(*) AS pet_count
  FROM pets
  GROUP BY ownerid, kind
)
SELECT o.ownerid, o.name, o.surname, o.city, o.state, opk.kind
FROM owners o
JOIN owner_pet_kinds opk ON o.ownerid = opk.ownerid
WHERE opk.pet_count > 1;



/* Retrieve the owners and their pets, along with the number of procedures performed on each pet and the total price of those procedures */
WITH pet_procedure_summary AS (
  SELECT ph.petid, COUNT(*) AS procedure_count, SUM(pd.price) AS total_price
  FROM procedurehistory ph
  JOIN proceduredetails pd ON ph.proceduretype = pd.proceduretype AND ph.proceduresubcode = pd.proceduresubcode
  GROUP BY ph.petid
),
owner_pet_procedures AS (
  SELECT o.ownerid, o.name AS owner_name, o.surname, p.petid, p.name AS pet_name, p.gender, p.age, p.kind, pp.procedure_count, pp.total_price
  FROM owners o
  JOIN pets p ON o.ownerid = p.ownerid
  LEFT JOIN pet_procedure_summary pp ON p.petid = pp.petid
)
SELECT ownerid, owner_name, surname, petid, pet_name, gender, age, kind, procedure_count, total_price
FROM owner_pet_procedures;
