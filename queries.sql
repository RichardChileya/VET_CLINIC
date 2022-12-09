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


-- Write queries (using JOIN) to answer the following questions:
-- [X] What animals belong to Melody Pond?
SELECT name AS "Animal Name", full_name AS "Owner"
  FROM animals
  INNER JOIN owners
  ON animals.owner_id = owners.id
  WHERE owners.full_name = 'Melody Pond';

-- [X] List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name AS "Animal Name", species.name AS "Species"
  FROM animals
  INNER JOIN species
  ON animals.species_id = species.id
  WHERE species.name = 'Pokemon';

-- [X] List all owners and their animals, remember to include those that don't own any animal.
SELECT owners.full_name AS "Owner", animals.name AS "Animal Name"
  FROM owners
  LEFT JOIN animals
  ON owners.id = animals.owner_id;

-- [X] How many animals are there per species?
SELECT COUNT(animals.name) AS "Animals Count", species.name AS "Species"
  FROM animals
  INNER JOIN species
  ON animals.species_id = species.id
  GROUP BY species.name;

-- [X] List all Digimon owned by Jennifer Orwell.
SELECT owners.full_name AS "Owner", animals.name As "Animal", species.name AS "Species"
  FROM owners
  INNER JOIN animals
  ON owners.id = animals.owner_id
  INNER JOIN species
  ON species.id = animals.species_id
  WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

-- [X] List all animals owned by Dean Winchester that haven't tried to escape.
SELECT owners.full_name AS "Owner", animals.name As "Animal" , animals.escape_attempts
  FROM owners
  INNER JOIN animals
  ON owners.id = animals.owner_id
  WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

-- [X] Who owns the most animals?
SELECT owners.full_name , COUNT(*)
  FROM owners
  INNER JOIN animals
  ON owners.id = animals.owner_id
  GROUP BY owners.full_name
  ORDER BY count DESC LIMIT 1;

  -- Write queries to answer the following:
-- [X] Who was the last animal seen by William Tatcher?
SELECT vets.name AS "Vet Name", animals.name AS "Animal Name", visits.date_of_visit
  FROM vets
  INNER JOIN visits
    ON vets.id = visits.vet_id
  INNER JOIN animals
    ON visits.animal_id = animals.id
  WHERE vets.name = 'William Tatcher'
  ORDER by date_of_visit DESC LIMIT 1;


  -- [X] How many different animals did Stephanie Mendez see?
SELECT vets.name AS "Vet Name", COUNT(DISTINCT animals.name)
   FROM vets
   INNER JOIN visits
     ON vets.id = visits.vet_id
   INNER JOIN animals
     ON visits.animal_id = animals.id
   WHERE vets.name = 'Stephanie Mendez'
   GROUP BY vets.name;

   -- [X] List all vets and their specialties, including vets with no specialties.
SELECT vets.name AS "Vet Name", species.name AS "Species"
  FROM vets
  FULL OUTER JOIN specializations
    ON vets.id = specializations.vet_id
  FULL OUTER JOIN species
    ON species.id = specializations.species_id;

    -- [X] List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name AS "Animal", visits.date_of_visit
  FROM animals
  JOIN visits
    ON animals.id = visits.animal_id
  WHERE visits.vet_id = (SELECT id FROM vets WHERE vets.name = 'Stephanie Mendez')
  AND
  visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

-- [X] What animal has the most visits to vets?
SELECT animals.name, COUNT(*)
  FROM animals
  JOIN visits
    ON animals.id = visits.animal_id
  GROUP BY animals.name
  ORDER BY count DESC LIMIT 1;

  -- [X] Who was Maisy Smith's first visit?
SELECT vets.name AS "Vet", animals.name AS "Animal", visits.date_of_visit
  FROM vets
  JOIN visits
    ON vets.id = visits.vet_id
  JOIN animals
    ON visits.animal_id = animals.id
  WHERE vets.name = 'Maisy Smith'
  ORDER BY date_of_visit LIMIT 1;

-- [X] Details for most recent visit: animal information, vet information, and date of visit.
SELECT
  vets.id AS "Vet id", vets.name AS "Vet", date_of_graduation,

  visits.date_of_visit,

  animals.id AS "Animal id", animals.name AS "Animal", date_of_birth, escape_attempts, neutered, weight_kg, species_id, owner_id
  FROM vets
  JOIN visits
    ON vets.id = visits.vet_id
  JOIN animals
    ON visits.animal_id = animals.id
  ORDER BY date_of_visit DESC LIMIT 1;

-- [X] How many visits were with a vet that did not specialize in that animal's species?
SELECT vets.name
  FROM vets
  JOIN visits
    ON vets.id = visits.vet_id
  LEFT JOIN specializations
    ON vets.id = specializations.vet_id
  WHERE specializations.vet_id IS NULL
  GROUP BY vets.name;

  -- [X] What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name AS "species", COUNT(animals.species_id)
  FROM vets
  JOIN visits
    ON vets.id = visits.vet_id
  JOIN animals
    ON animals.id = visits.animal_id
  JOIN species
    ON species.id = animals.species_id
  WHERE vets.name = 'Maisy Smith'
  GROUP BY species.name
  ORDER BY count DESC LIMIT 1;
  