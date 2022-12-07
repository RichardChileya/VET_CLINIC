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
