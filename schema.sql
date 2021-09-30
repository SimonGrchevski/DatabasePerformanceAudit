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

ALTER TABLE owners ADD COLUMN email VARCHAR(120);
-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (animals_id, vet_id, date_of_visit) SELECT * FROM (SELECT id FROM animals) animal_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
insert into owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';

-- create index to improve the SELECT * FROM visits where vet_id = 2
create index visits_id on visits(vet_id desc);

-- increase the parallel workers.
set max_parallel_workers_per_gather to 10;
alter table animals  set (parallel_workers = 9 );
create index on the primary key
create index owners_i on owners(id);

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
