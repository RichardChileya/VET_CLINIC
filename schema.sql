/* Database schema to keep the structure of entire database. */


CREATE TABLE animals (
    id INT NOT NULL GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(150),
    date_of_birth DATE,
    escape_attempts INT,
    neutered BOOLEAN,
    weight_kg DECIMAL
);

-- [X] Add a column species with a datatype of string 
ALTER TABLE animals
ADD COLUMN species VARCHAR(250);

-- [x] Create a table named owner

CREATE TABLE owners(
    id INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(150),
    age INT
);

-- [x] Create Species Table
 CREATE TABLE species(
    id INT NOT NULL GENERATED ALWAYS as IDENTITY PRIMARY KEY,
    name VARCHAR(100)
 );

 -- [x] Modify Animals Table

 ALTER TABLE animals  -- [x] make change to animals table
  ADD PRIMARY KEY(id); -- [x] make ID column primary key 

  ALTER TABLE animals -- [x] make changes to table 
  DROP COLUMN specices; -- [x] remove species column from animals table

  -- [x] add species id and owners id to animals table

  ALTER TABLE animals
    ADD COLUMN species_id INT, -- [x] add species_id
    ADD COLUMN owner_id INT;  -- [x] add owner_id;

-- [x] Add foreign key constraints to animald table 

ALTER TABLE animals
    ADD CONSTRAINT fk_species
    FOREIGN KEY (species_id)
    REFERENCES species(id);

-- [x] Add column owner_id as a foreign key

ALTER TABLE animals
    ADD CONSTRAINT fk_owner
    FOREIGN KEY (owner_id)
    REFERENCES owners(id);



