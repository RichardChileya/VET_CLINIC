/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon%';

SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

SELECT * FROM animals WHERE neutered IS true AND escape_attempts < 3;

SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

SELECT * FROM animals WHERE neutered IS true;

SELECT * FROM animals WHERE name NOT LIKE 'Gabumon';

SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- [X] Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that the species columns went back to the state before the transaction
BEGIN;

  UPDATE animals
  SET species = 'unspecified'; --make changes

  SELECT species FROM animals; --verify changes

ROLLBACK;

  SELECT species from animals; --verify changes were undone
--

-- New transaction
BEGIN;
-- [X] Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
  UPDATE animals
  SET species = 'digimon'
  WHERE name LIKE '%mon%'; 

  SELECT species from animals; -- verrify that changes made 
  COMMIT; 

  SELECT species FROM animals --verify that changes persist after commit 

-- [X] Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
  UPDATE animals
  SET species = 'pokemon' -- make changes
  WHERE species is NULL;


COMMIT;

-- [X] Delete all recordes
BEGIN;
  TRUNCATE TABLE animals;
SELECT COUNT(*) FROM ANIMALS; -- verify changes made

   ROLLBACK; 
   SELECT COUNT(*) FROM ANIMALS; --verify changes 
-- Inside a transaction:
BEGIN;

-- [X] Delete all animals born after Jan 1st, 2022.
  DELETE FROM animals
  WHERE date_of_birth > '2022-01-01';

-- [X] Create a savepoint for the transaction.
  SAVEPOINT date_birth_Jan_1st_2022;

-- [X] Update all animals' weight to be their weight multiplied by -1.
  UPDATE animals
  SET weight_kg = -weight_kg; --make change 
   
   SELECT weight_kg FROM animals; --verify changes med 

-- [X] Rollback to the savepoint
  ROLLBACK TO date_birth_Jan_1st_2022; -- verify changes were undone

-- [X] Update all animals' weights that are negative to be their weight multiplied by -1.
  UPDATE animals
  SET weight_kg = -weight_kg
  WHERE weight_kg < 0;
-- [X] Commit transaction
COMMIT;

-- [X] How many animals are there?
SELECT COUNT(*) FROM animals;

-- [X] How many animals have never tried to escape?
SELECT COUNT(*) AS "Animals count that never escaped" FROM animals
WHERE escape_attempts = 0;

-- [X] What is the average weight of animals?
SELECT CAST(AVG(weight_kg) AS DECIMAL(10,2)) AS "Animals AVG Weight" FROM animals;

-- [X] Who escapes the most, neutered or not neutered animals?
SELECT neutered, MAX(escape_attempts) AS "MAX escape attempts" FROM animals
GROUP BY neutered;

-- [X] What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg) AS "MIN weight", MAX(weight_kg) AS "MAX weight" FROM animals
GROUP BY species;

-- [X] What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, CAST(AVG(escape_attempts) AS DECIMAL(10)) AS "AVG of escaping" FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;
