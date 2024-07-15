DROP DATABASE chip_data;

CREATE DATABASE chip_data;
USE chip_data;

CREATE TABLE chips (
  id integer PRIMARY KEY AUTO_INCREMENT,
  chip_number VARCHAR(32) NOT NULL,
  family VARCHAR(32) NOT NULL,
  pin_count integer NOT NULL,
  package varchar(16) not null,
  datasheet varchar(256) NULL,
  description TEXT NOT NULL
);

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

CREATE VIEW chip_aliases AS
SELECT id, chip_number, family, package, pin_count, description, (select sum(quantity) from inventory i where i.chip_id = c.id) on_hand
FROM chips c
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
