CREATE DATABASE chip_data;
USE chip_data;

CREATE TABLE chips (
  id integer PRIMARY KEY AUTO_INCREMENT,
  chip_number VARCHAR(32) NOT NULL,
  family VARCHAR(32) NOT NULL,
  description TEXT NOT NULL,
  pin_count integer NOT NULL,
  package varchar(16) not null
);

CREATE TABLE pins (
    id integer PRIMARY KEY AUTO_INCREMENT,
    chip_id integer NOT NULL,
    pin_number integer NOT NULL,
    pin_description TEXT NOT NULL,
    pin_symbol VARCHAR(64) NOT NULL
);

CREATE TABLE inventory (
    id integer PRIMARY KEY AUTO_INCREMENT,
    chip_id integer not null,
    full_number VARCHAR(64) NOT NULL,
    quantity integer not null
);

INSERT INTO chips (chip_number, family, description, pin_count, package)
VALUES 
('74299', '7400', '8-bit bidirectional universal shift/storage register; 3-state', 20, 'DIP'),
('74174', '7400', 'Hex D-type flip-flop with reset; positive-edge trigger', 16, 'DIP');

INSERT INTO inventory ( chip_id, full_number, quantity)
VALUES
(1, 'SN74LS299N', 1),
(2, 'MC74AC174N', 1);

select chips.chip_number, pins.* from chips join pins on pins.chip_id = chips.id where pins.pin_symbol like '%\_\_%';