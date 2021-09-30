/* Database schema to keep the structure of entire database. */

DROP TABLE IF EXISTS animals;
CREATE TABLE animals (
    id int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name char(50),
    date_of_birth date,
    escape_attempts int,
    neutered boolean,
    weight_kg decimal
);

DROP TABLE IF EXISTS owners;
CREATE TABLE owners (
    id int GENERATED ALWAYS AS IDENTITY,
    full_name varchar(32),
    age int,
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS species;
CREATE TABLE species (
    id int GENERATED ALWAYS AS IDENTITY,
    name varchar(32),
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS vets;
CREATE TABLE vets (
    id int GENERATED ALWAYS AS IDENTITY,
    name varchar(32),
    age int,
    date_of_graduation date,
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS specializations;
CREATE TABLE specializations (
    vet_id int,
    species_id int,
    FOREIGN KEY (vet_id) REFERENCES vets(id),
    FOREIGN KEY (species_id) REFERENCES species(id)
);

DROP TABLE IF EXISTS visits;
CREATE TABLE visits (
    animals_id int,
    vet_id int,
    date_of_visit date,
    FOREIGN KEY (animals_id) REFERENCES animals(id),
    FOREIGN KEY (vet_id) REFERENCES vets(id)
);

ALTER TABLE animals
ADD species char(50);

ALTER TABLE animals
DROP species;

ALTER TABLE animals
ADD species_id int;

ALTER TABLE animals
ADD owner_id int;

ALTER TABLE animals
ADD CONSTRAINT constraint_species
FOREIGN KEY (species_id)
REFERENCES species(id)
ON DELETE CASCADE;

ALTER TABLE animals
ADD CONSTRAINT constraint_owners
FOREIGN KEY (owner_id)
REFERENCES owners(id)
ON DELETE CASCADE;
