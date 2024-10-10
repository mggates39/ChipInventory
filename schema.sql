DROP DATABASE chip_data;

CREATE DATABASE chip_data;
USE chip_data;

CREATE TABLE components (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    component_type_id INTEGER NOT NULL,
    component_sub_type_id INTEGER NOT NULL,
    package_type_id INTEGER NOT NULL,
    name VARCHAR(32) NOT NULL,
    description TEXT NOT NULL,
	pin_count INTEGER NOT NULL
);

CREATE TABLE chips (
  component_id INTEGER PRIMARY KEY NOT NULL,
  family VARCHAR(32) NOT NULL,
  datasheet VARCHAR(256) NULL
);

CREATE TABLE crystals (
	component_id INTEGER PRIMARY KEY NOT NULL,
    frequency  VARCHAR(32) NOT NULL,
  datasheet VARCHAR(256) NULL
);

CREATE TABLE pins (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  component_id INTEGER NOT NULL,
  pin_number INTEGER NOT NULL,
  pin_description TEXT NOT NULL,
  pin_symbol VARCHAR(64) NOT NULL
);

CREATE TABLE notes (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  component_id INTEGER NOT NULL,
  note TEXT NOT NULL
);

CREATE TABLE specs (
  id integer PRIMARY KEY AUTO_INCREMENT,
  component_id INTEGER NOT NULL,
  parameter VARCHAR(128) NOT NULL,
  unit VARCHAR(32) NOT NULL,
  value TEXT NOT NULL
);

CREATE TABLE aliases (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  component_id INTEGER NOT NULL,
  alias_chip_number VARCHAR(32) NOT NULL
);

CREATE TABLE inventory (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    component_id INTEGER NOT NULL,
    mfg_code_id INTEGER NOT NULL,
    full_number VARCHAR(64) NOT NULL,
    quantity INTEGER NOT NULL
);

CREATE TABLE inventory_dates (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  inventory_id INTEGER NOT NULL,
  date_code VARCHAR(16) NOT NULL,
  quantity INTEGER NOT NULL
);

CREATE TABLE manufacturer (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(128) NOT NULL
);

CREATE TABLE mfg_codes (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	manufacturer_id integer NOT NULL,
	mfg_code VARCHAR(16) NOT NULL
);

CREATE TABLE component_types (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    description VARCHAR(32) NOT NULL,
    symbol VARCHAR(4) NOT NULL,
    table_name VARCHAR(32) NOT NULL
);

CREATE TABLE component_sub_types (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    component_type_id INTEGER NOT NULL,
    name VARCHAR(16) NOT NULL,
    description VARCHAR(64) NOT NULL
);
    

CREATE TABLE mounting_types (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(32) NOT NULL,
    is_through_hole  BOOLEAN,
    is_surface_mount BOOLEAN,
    is_chassis_mount BOOLEAN
);

CREATE TABLE package_types (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(32) NOT NULL,
    description VARCHAR(32) NOT NULL,
    mounting_type_id INTEGER NOT NULL
);

CREATE TABLE component_packages (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    component_type_id INTEGER NOT NULL,
    package_type_id INTEGER NOT NULL
);

-- Create Incexes and FK relationships once the tables are call reated.
ALTER TABLE  chips ADD FOREIGN KEY chip_comp_idfk (component_id) REFERENCES components(id);
ALTER TABLE  crystals ADD FOREIGN KEY crystal_comp_idfk (component_id) REFERENCES components(id);

CREATE INDEX type_mounting_type_idx ON package_types(mounting_type_id);
ALTER TABLE  package_types ADD FOREIGN KEY mounting_type_idfk (mounting_type_id) REFERENCES mounting_types(id);

CREATE INDEX type_component_type_idx ON component_packages(component_type_id);
ALTER TABLE  component_packages ADD FOREIGN KEY componet_type_idfk (component_type_id) REFERENCES component_types(id);

CREATE INDEX type_package_type_idx ON component_packages(package_type_id);
ALTER TABLE  component_packages ADD FOREIGN KEY package_type_idfk (package_type_id) REFERENCES package_types(id);

CREATE INDEX component_type_idx ON components(component_type_id);
ALTER TABLE components ADD FOREIGN KEY components_type_idfk (component_type_id) REFERENCES component_types(id);

CREATE INDEX component_sub_type_idx ON components(component_sub_type_id);
ALTER TABLE components ADD FOREIGN KEY components_sub_type_idfk (component_sub_type_id) REFERENCES component_sub_types(id);

CREATE INDEX component_type_idx ON component_sub_types(component_type_id);
ALTER TABLE component_sub_types ADD FOREIGN KEY components_type_idfk (component_type_id) REFERENCES component_types(id);

CREATE INDEX component_package_idx ON components(package_type_id);
ALTER TABLE components ADD FOREIGN KEY components_package_idfk (package_type_id) REFERENCES package_types(id);

CREATE INDEX mfg_idx ON mfg_codes(manufacturer_id);
ALTER TABLE  mfg_codes ADD FOREIGN KEY mfg_codes_mfg_idfk (manufacturer_id) REFERENCES manufacturer(id);

CREATE INDEX chip_idx ON pins (component_id);
ALTER TABLE  pins add FOREIGN KEY pins_chip_idfk (component_id) REFERENCES components(id);

CREATE INDEX chip_idx ON notes (component_id);
ALTER TABLE  notes ADD FOREIGN KEY notes_chip_idfk (component_id) REFERENCES components(id);

CREATE INDEX chip_idx ON specs (component_id);
ALTER TABLE  specs ADD FOREIGN KEY specs_chip_idfk (component_id) REFERENCES components(id);

CREATE INDEX chip_idx ON aliases (component_id);
ALTER table  aliases ADD FOREIGN KEY aliases_chip_idfk (component_id) REFERENCES components(id);

CREATE INDEX chip_idx ON inventory (component_id);
ALTER TABLE  inventory ADD FOREIGN KEY inventory_chip_idfk (component_id) REFERENCES components(id);

CREATE INDEX mfg_code_idx ON inventory (mfg_code_id);
ALTER table  inventory ADD FOREIGN KEY mfg_code_idfk (mfg_code_id) REFERENCES mfg_codes(id);

CREATE INDEX inv_idx ON inventory_dates(inventory_id);
ALTER TABLE  inventory_dates ADD FOREIGN KEY inv_idfk (inventory_id) REFERENCES inventory(id);


-- Create any Views
-- DROP VIEW chip_aliases ;
CREATE VIEW chip_aliases AS
SELECT cmp.id, cmp.component_type_id, cmp.name as chip_number, ct.description as component, cst.name as component_type, ct.table_name, pt.name as package, cmp.pin_count, cmp.description, (select sum(quantity) from inventory i where i.component_id = cmp.id) on_hand
FROM components cmp
JOIN package_types pt on pt.id = cmp.package_type_id
JOIN component_types ct on ct.id = cmp.component_type_id
LEFT JOIN component_sub_types cst on cst.id = cmp.component_sub_type_id
UNION ALL
SELECT cmp.id as id, cmp.component_type_id, alias_chip_number as chip_number, ct.description as  component, cst.name as component_type, ct.table_name, pt.name as package, cmp.pin_count, concat("See <a href='/chips/", a.component_id,"'>", cmp.name, "</a>") as description, '' on_hand
FROM aliases a
JOIN components cmp ON cmp.id = a.component_id
JOIN package_types pt on pt.id = cmp.package_type_id
JOIN component_types ct on ct.id = cmp.component_type_id
LEFT JOIN component_sub_types cst on cst.id = cmp.component_sub_type_id;

