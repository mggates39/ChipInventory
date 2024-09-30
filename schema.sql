DROP DATABASE chip_data;

CREATE DATABASE chip_data;
USE chip_data;

CREATE TABLE chips (
  id integer PRIMARY KEY AUTO_INCREMENT,
  chip_number VARCHAR(32) NOT NULL,
  family VARCHAR(32) NOT NULL,
  pin_count integer NOT NULL,
  package_type_id integer not null,
  datasheet varchar(256) NULL,
  description TEXT NOT NULL
);
create index chip_pkg_idx on chips(package_type_id);

CREATE TABLE pins (
  id integer PRIMARY KEY AUTO_INCREMENT,
  chip_id integer NOT NULL,
  pin_number integer NOT NULL,
  pin_description TEXT NOT NULL,
  pin_symbol VARCHAR(64) NOT NULL
);

CREATE TABLE notes (
  id integer PRIMARY KEY AUTO_INCREMENT,
  chip_id integer not null,
  note TEXT not NULL
);

CREATE TABLE specs (
  id integer PRIMARY KEY AUTO_INCREMENT,
  chip_id integer NOT NULL,
  parameter VARCHAR(128) NOT NULL,
  unit VARCHAR(32) NOT NULL,
  value TEXT NOT NULL
);

CREATE TABLE aliases (
  id integer PRIMARY KEY AUTO_INCREMENT,
  chip_id integer NOT NULL,
  alias_chip_number VARCHAR(32) NOT NULL
);

CREATE TABLE inventory (
    id integer PRIMARY KEY AUTO_INCREMENT,
    chip_id integer not null,
    mfg_code_id integer not null,
    full_number VARCHAR(64) NOT NULL,
    quantity integer not null
);

CREATE TABLE inventory_dates (
  id integer PRIMARY KEY AUTO_INCREMENT,
  inventory_id integer NOT NULL,
  date_code VARCHAR(16) NOT NULL,
  quantity integer NOT NULL
);

CREATE TABLE manufacturer (
	id integer primary key auto_increment,
	name VARCHAR(128) NOT NULL
);

CREATE TABLE mfg_codes (
	id integer primary key auto_increment,
	manufacturer_id integer NOT NULL,
	mfg_code VARCHAR(16) NOT NULL
);

CREATE TABLE component_types (
	id integer primary key auto_increment,
    description VARCHAR(32) NOT NULL,
    symbol VARCHAR(4) NOT NULL,
    table_name VARCHAR(32) NOT NULL
);

CREATE TABLE mounting_types (
	id integer primary key auto_increment,
	name varchar(32) not null,
    is_through_hole  boolean,
    is_surface_mount boolean,
    is_chassis_mount boolean
);

CREATE TABLE package_types (
	id integer primary key auto_increment,
    name varchar(32) not null,
    description varchar(32) not null,
    mounting_type_id integer not null
);
CREATE INDEX type_mounting_type_idx on package_types(mounting_type_id);
ALTER TABLE  package_types ADD FOREIGN KEY mounting_type_idfk (mounting_type_id) REFERENCES mounting_types(id);

CREATE TABLE component_packages (
	id integer primary key auto_increment,
    component_type_id integer not null,
    package_type_id integer not null
);
CREATE INDEX type_component_type_idx on component_packages(component_type_id);
ALTER TABLE  component_packages ADD FOREIGN KEY componet_type_idfk (component_type_id) REFERENCES component_types(id);
CREATE INDEX type_package_type_idx on component_packages(package_type_id);
ALTER TABLE  component_packages ADD FOREIGN KEY package_type_idfk (package_type_id) REFERENCES package_types(id);

CREATE TABLE components (
	id integer primary key auto_increment,
    component_type_id integer not null,
    component_package_id integer not null,
    name varchar(32) not null
);
CREATE INDEX component_type_idx on components(component_type_id);
ALTER TABLE components ADD FOREIGN KEY components_type_idfk (component_type_id) REFERENCES component_types(id);
CREATE INDEX component_package_idx on components(component_package_id);
ALTER TABLE components ADD FOREIGN KEY components_package_idfk (component_package_id) REFERENCES component_packages(id);

CREATE VIEW chip_aliases AS
SELECT id, chip_number, family, pt.name package, pin_count, description, (select sum(quantity) from inventory i where i.chip_id = c.id) on_hand
FROM chips c
JOIN package_types pt on pt.id = c.package_type_id
UNION ALL
SELECT chip_id as id, alias_chip_number as chip_number,  '' family, '' package, '' pin_count, concat("See <a href='/chips/", a.chip_id,"'>", x.chip_number, "</a>") as description, '' on_hand
FROM aliases a
JOIN chips x ON x.id = a.chip_id;

create index mfg_idx on mfg_codes(manufacturer_id);
alter table  mfg_codes add FOREIGN KEY mfg_codes_mfg_idfk (manufacturer_id) REFERENCES manufacturer(id);

create index chip_idx on pins (chip_id);
alter table  pins add FOREIGN KEY pins_chip_idfk (chip_id) REFERENCES chips(id);

create index chip_idx on notes (chip_id);
alter table  notes add FOREIGN KEY notes_chip_idfk (chip_id) REFERENCES chips(id);

create index chip_idx on specs (chip_id);
alter table  specs add FOREIGN KEY specs_chip_idfk (chip_id) REFERENCES chips(id);

create index chip_idx on aliases (chip_id);
alter table  aliases add FOREIGN KEY aliases_chip_idfk (chip_id) REFERENCES chips(id);

create index chip_idx on inventory (chip_id);
alter table  inventory add FOREIGN KEY inventory_chip_idfk (chip_id) REFERENCES chips(id);

create index mfg_code_idx on inventory (mfg_code_id);
alter table  inventory add FOREIGN KEY mfg_code_idfk (mfg_code_id) REFERENCES mfg_code(id);

CREATE INDEX inv_idx on inventory_dates(inventory_id);
ALTER TABLE inventory_dates ADD FOREIGN KEY inv_idfk (inventory_id) REFERENCES inventory(id);

ALTER TABLE chips ADD FOREIGN KEY pkg_type_idfk (package_type_id) REFERENCES package_types(id);
