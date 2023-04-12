-- Remove conflicting tables
DROP TABLE IF EXISTS administrator CASCADE;
DROP TABLE IF EXISTS alien CASCADE;
DROP TABLE IF EXISTS builder CASCADE;
DROP TABLE IF EXISTS citizen CASCADE;
DROP TABLE IF EXISTS deployment CASCADE;
DROP TABLE IF EXISTS lifeform CASCADE;
DROP TABLE IF EXISTS mission CASCADE;
DROP TABLE IF EXISTS sector CASCADE;
DROP TABLE IF EXISTS targeted_alien CASCADE;
DROP TABLE IF EXISTS tower CASCADE;
DROP TABLE IF EXISTS unit CASCADE;
-- End of removing

CREATE TABLE administrator (
    biometric_id SERIAL NOT NULL,
    citizen_id INTEGER NOT NULL,
    lifeform_id INTEGER NOT NULL,
    authorisation_level INTEGER NOT NULL
);
ALTER TABLE administrator ADD CONSTRAINT pk_administrator PRIMARY KEY (biometric_id, citizen_id, lifeform_id);
ALTER TABLE administrator ADD CONSTRAINT u_fk_administrator_citizen UNIQUE (citizen_id, lifeform_id);

CREATE TABLE alien (
    alien_id SERIAL NOT NULL,
    lifeform_id INTEGER NOT NULL,
    sector_id INTEGER NOT NULL,
    threat_level INTEGER NOT NULL,
    lifeform_type VARCHAR(56) NOT NULL,
    eradicated BOOLEAN
);
ALTER TABLE alien ADD CONSTRAINT pk_alien PRIMARY KEY (alien_id, lifeform_id);
ALTER TABLE alien ADD CONSTRAINT u_fk_alien_lifeform UNIQUE (lifeform_id);

CREATE TABLE builder (
    builder_id SERIAL NOT NULL,
    sector_id INTEGER NOT NULL,
    size INTEGER NOT NULL,
    purpose VARCHAR(56) NOT NULL
);
ALTER TABLE builder ADD CONSTRAINT pk_builder PRIMARY KEY (builder_id);

CREATE TABLE citizen (
    citizen_id SERIAL NOT NULL,
    lifeform_id INTEGER NOT NULL,
    first_name VARCHAR(40),
    surname VARCHAR(40),
    date_of_birth VARCHAR(56),
    date_of_passing VARCHAR(56)
);
ALTER TABLE citizen ADD CONSTRAINT pk_citizen PRIMARY KEY (citizen_id, lifeform_id);
ALTER TABLE citizen ADD CONSTRAINT u_fk_citizen_lifeform UNIQUE (lifeform_id);

CREATE TABLE deployment (
    deployment_id SERIAL NOT NULL,
    mission_id INTEGER NOT NULL,
    serial_number INTEGER NOT NULL
);
ALTER TABLE deployment ADD CONSTRAINT pk_deployment PRIMARY KEY (deployment_id);

CREATE TABLE lifeform (
    lifeform_id SERIAL NOT NULL
);
ALTER TABLE lifeform ADD CONSTRAINT pk_lifeform PRIMARY KEY (lifeform_id);

CREATE TABLE mission (
    mission_id SERIAL NOT NULL,
    sector_id INTEGER NOT NULL,
    codename VARCHAR(56)
);
ALTER TABLE mission ADD CONSTRAINT pk_mission PRIMARY KEY (mission_id);

CREATE TABLE sector (
    sector_id SERIAL NOT NULL,
    coordinate_x DOUBLE PRECISION NOT NULL,
    coordinate_y DOUBLE PRECISION NOT NULL,
    coordinate_z DOUBLE PRECISION NOT NULL,
    coordinate_w DOUBLE PRECISION,
    purpose VARCHAR(56) NOT NULL,
    power_consumption DOUBLE PRECISION NOT NULL
);
ALTER TABLE sector ADD CONSTRAINT pk_sector PRIMARY KEY (sector_id);

CREATE TABLE targeted_alien (
    target_id SERIAL NOT NULL,
    mission_id INTEGER NOT NULL,
    alien_id INTEGER NOT NULL,
    lifeform_id INTEGER NOT NULL
);
ALTER TABLE targeted_alien ADD CONSTRAINT pk_targeted_alien PRIMARY KEY (target_id);

CREATE TABLE tower (
    tower_id SERIAL NOT NULL,
    sector_id INTEGER NOT NULL,
    biometric_id INTEGER,
    citizen_id INTEGER,
    lifeform_id INTEGER,
    name VARCHAR(56) NOT NULL
);
ALTER TABLE tower ADD CONSTRAINT pk_tower PRIMARY KEY (tower_id);
ALTER TABLE tower ADD CONSTRAINT c_fk_tower_administrator CHECK ((biometric_id IS NOT NULL AND citizen_id IS NOT NULL AND lifeform_id IS NOT NULL) OR (biometric_id IS NULL AND citizen_id IS NULL AND lifeform_id IS NULL));

CREATE TABLE unit (
    serial_number SERIAL NOT NULL,
    unit_serial_number INTEGER,
    tower_id INTEGER NOT NULL,
    sentience INTEGER NOT NULL,
    power_level INTEGER NOT NULL
);
ALTER TABLE unit ADD CONSTRAINT pk_unit PRIMARY KEY (serial_number);

ALTER TABLE administrator ADD CONSTRAINT fk_administrator_citizen FOREIGN KEY (citizen_id, lifeform_id) REFERENCES citizen (citizen_id, lifeform_id) ON DELETE CASCADE;

ALTER TABLE alien ADD CONSTRAINT fk_alien_lifeform FOREIGN KEY (lifeform_id) REFERENCES lifeform (lifeform_id) ON DELETE CASCADE;
ALTER TABLE alien ADD CONSTRAINT fk_alien_sector FOREIGN KEY (sector_id) REFERENCES sector (sector_id) ON DELETE CASCADE;

ALTER TABLE builder ADD CONSTRAINT fk_builder_sector FOREIGN KEY (sector_id) REFERENCES sector (sector_id) ON DELETE CASCADE;

ALTER TABLE citizen ADD CONSTRAINT fk_citizen_lifeform FOREIGN KEY (lifeform_id) REFERENCES lifeform (lifeform_id) ON DELETE CASCADE;

ALTER TABLE deployment ADD CONSTRAINT fk_deployment_mission FOREIGN KEY (mission_id) REFERENCES mission (mission_id) ON DELETE CASCADE;
ALTER TABLE deployment ADD CONSTRAINT fk_deployment_unit FOREIGN KEY (serial_number) REFERENCES unit (serial_number) ON DELETE CASCADE;

ALTER TABLE mission ADD CONSTRAINT fk_mission_sector FOREIGN KEY (sector_id) REFERENCES sector (sector_id) ON DELETE CASCADE;

ALTER TABLE targeted_alien ADD CONSTRAINT fk_targeted_alien_mission FOREIGN KEY (mission_id) REFERENCES mission (mission_id) ON DELETE CASCADE;
ALTER TABLE targeted_alien ADD CONSTRAINT fk_targeted_alien_alien FOREIGN KEY (alien_id, lifeform_id) REFERENCES alien (alien_id, lifeform_id) ON DELETE CASCADE;

ALTER TABLE tower ADD CONSTRAINT fk_tower_sector FOREIGN KEY (sector_id) REFERENCES sector (sector_id) ON DELETE CASCADE;
ALTER TABLE tower ADD CONSTRAINT fk_tower_administrator FOREIGN KEY (biometric_id, citizen_id, lifeform_id) REFERENCES administrator (biometric_id, citizen_id, lifeform_id) ON DELETE CASCADE;

ALTER TABLE unit ADD CONSTRAINT fk_unit_unit FOREIGN KEY (unit_serial_number) REFERENCES unit (serial_number) ON DELETE CASCADE;
ALTER TABLE unit ADD CONSTRAINT fk_unit_tower FOREIGN KEY (tower_id) REFERENCES tower (tower_id) ON DELETE CASCADE;