DROP DATABASE chip_data;

CREATE DATABASE chip_data;
USE chip_data;

CREATE TABLE `mounting_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `is_through_hole` tinyint(1) DEFAULT NULL,
  `is_surface_mount` tinyint(1) DEFAULT NULL,
  `is_chassis_mount` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `package_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `description` varchar(32) NOT NULL,
  `mounting_type_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `type_mounting_type_idx` (`mounting_type_id`),
  CONSTRAINT `package_types_ibfk_1` FOREIGN KEY (`mounting_type_id`) REFERENCES `mounting_types` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `component_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(16) NOT NULL,
  `description` varchar(32) NOT NULL,
  `symbol` varchar(4) NOT NULL,
  `table_name` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `component_sub_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `component_type_id` int NOT NULL,
  `name` varchar(16) NOT NULL,
  `description` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `component_type_idx` (`component_type_id`),
  CONSTRAINT `component_sub_types_ibfk_1` FOREIGN KEY (`component_type_id`) REFERENCES `component_types` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `component_packages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `component_type_id` int NOT NULL,
  `package_type_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `type_component_type_idx` (`component_type_id`),
  KEY `type_package_type_idx` (`package_type_id`),
  CONSTRAINT `component_packages_ibfk_1` FOREIGN KEY (`component_type_id`) REFERENCES `component_types` (`id`),
  CONSTRAINT `component_packages_ibfk_2` FOREIGN KEY (`package_type_id`) REFERENCES `package_types` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `lists` (
	`id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(16) NOT NULL,
    `description` varchar(64) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `list_entries` (
	`id` int NOT NULL AUTO_INCREMENT,
    `list_id` int NOT NULL,
    `sequence` int NOT NULL,
    `name` varchar(16) NOT NULL,
    `description` varchar(32) NOT NULL,
    `modifier_value` int NULL,
    PRIMARY KEY (`id`),
  KEY `list_idx` (`list_id`),
  CONSTRAINT `list_ibfk_1` FOREIGN KEY (`list_id`) REFERENCES `lists` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `components` (
  `id` int NOT NULL AUTO_INCREMENT,
  `component_type_id` int NOT NULL,
  `component_sub_type_id` int DEFAULT NULL,
  `package_type_id` int NOT NULL,
  `name` varchar(32) NOT NULL,
  `description` text NOT NULL,
  `pin_count` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `component_type_idx` (`component_type_id`),
  KEY `component_package_idx` (`package_type_id`),
  KEY `component_sub_type_idx` (`component_sub_type_id`),
  CONSTRAINT `component_type_idfk` FOREIGN KEY (`component_type_id`) REFERENCES `component_types` (`id`),
  CONSTRAINT `component_pkg_type_idfk` FOREIGN KEY (`package_type_id`) REFERENCES `package_types` (`id`),
  CONSTRAINT `component_subtype_idfk` FOREIGN KEY (`component_sub_type_id`) REFERENCES `component_sub_types` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `pins` (
  `id` int NOT NULL AUTO_INCREMENT,
  `component_id` int NOT NULL,
  `pin_number` int NOT NULL,
  `pin_description` text NOT NULL,
  `pin_symbol` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `component_idx` (`component_id`),
  CONSTRAINT `pins_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `notes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `component_id` int NOT NULL,
  `note` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `component_idx` (`component_id`),
  CONSTRAINT `notes_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `specs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `component_id` int NOT NULL,
  `parameter` varchar(128) NOT NULL,
  `unit` varchar(32) NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `component_idx` (`component_id`),
  CONSTRAINT `specs_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `aliases` (
  `id` int NOT NULL AUTO_INCREMENT,
  `component_id` int NOT NULL,
  `alias_chip_number` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `component_idx` (`component_id`),
  CONSTRAINT `aliases_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `capacitors` (
  `component_id` int NOT NULL,
  `capacitance` int unsigned NOT NULL,
  `unit_id` int NOT NULL,
  `working_voltage` float(7,3) NOT NULL,
  `tolerance` float(6.4) NOT NULL,
  `number_capacitors` int NULL,
  `datasheet` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`component_id`),
  KEY `cap_unit_list_idx` (`unit_id`),
  CONSTRAINT `cap_compnt_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`),
  CONSTRAINT `cap_unit_list_ibfk_1` FOREIGN KEY (`unit_id`) REFERENCES `list_entries` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `chips` (
  `component_id` int NOT NULL,
  `family` varchar(32) NOT NULL,
  `datasheet` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`component_id`),
  CONSTRAINT `component_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `connectors` (
  `component_id` int NOT NULL,
  `datasheet` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`component_id`),
  CONSTRAINT `connectors_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `crystals` (
  `component_id` int NOT NULL,
  `frequency` float(8,4) NOT NULL,
  `unit_id` int NOT NULL,
  `datasheet` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`component_id`),
  CONSTRAINT `crystals_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `diodes` (
  `component_id` int NOT NULL,
  `forward_voltage` float(7,3) NULL,
  `forward_unit_id` int NULL,
  `reverse_voltage` float(7,3) NULL,
  `reverse_unit_id` int NULL,
  `light_color_id` int NULL,
  `lens_color_id` int NULL,
  `datasheet` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`component_id`),
  CONSTRAINT `diodes_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `fuses` (
  `component_id` int NOT NULL,
  `rating` float(7,3) NULL,
  `rating_unit_id` int NULL,
  `voltage` float(7,3) NULL,
  `voltage_unit_id` int NULL,
  `datasheet` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`component_id`),
  KEY `fuse_rating_units_idx` (`rating_unit_id`),
  KEY `fuse_voltage_units_idx` (`voltage_unit_id`),
  CONSTRAINT `fuses_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`),
  CONSTRAINT `fuse_rating_units_ibfk` FOREIGN KEY (`rating_unit_id`) REFERENCES `list_entries` (`id`),
  CONSTRAINT `fuse_voltage_units_ibfk` FOREIGN KEY (`voltage_unit_id`) REFERENCES `list_entries` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `inductors` (
  `component_id` int NOT NULL,
  `datasheet` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`component_id`),
  CONSTRAINT `inductors_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `resistors` (
  `component_id` int NOT NULL,
  `resistance` float(7,3) NOT NULL,
  `unit_id` int NOT NULL,
  `tolerance` float(6.4) NOT NULL,
  `power` float(7,3) NOT NULL,
  `number_resistors` int NULL,
  `datasheet` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`component_id`),
  KEY `res_unit_list_idx` (`unit_id`),
  CONSTRAINT `resistor_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`),
  CONSTRAINT `res_unit_list_ibfk` FOREIGN KEY (`unit_id`) REFERENCES `list_entries` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `sockets` (
  `component_id` int NOT NULL,
  `datasheet` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`component_id`),
  CONSTRAINT `sockets_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `switches` (
  `component_id` int NOT NULL,
  `datasheet` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`component_id`),
  CONSTRAINT `switches_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `transformers` (
  `component_id` int NOT NULL,
  `datasheet` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`component_id`),
  CONSTRAINT `transformers_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `transistors` (
  `component_id` int NOT NULL,
  `usage_id` int NOT NULL,
  `power_rating` float(7,3) NOT NULL,
  `power_unit_id` int NOT NULL,
  `threshold` float(7,3) NOT NULL,
  `threshold_unit_id` int NOT NULL,
  `datasheet` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`component_id`),
  CONSTRAINT `transistors_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `wires` (
  `component_id` int NOT NULL,
  `datasheet` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`component_id`),
  CONSTRAINT `wires_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `manufacturer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `mfg_codes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `manufacturer_id` int NOT NULL,
  `mfg_code` varchar(16) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mfg_idx` (`manufacturer_id`),
  CONSTRAINT `mfg_codes_ibfk_1` FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturer` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `location_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(16) NOT NULL,
  `description` varchar(32) NOT NULL,
  `tag` varchar(16) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `locations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `parent_location_id` int null,
  `location_type_id` int NOT NULL,
  `name` varchar(32) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_location_idx` (`parent_location_id`),
  KEY `location_type_idx` (`location_type_id`),
  CONSTRAINT `location_type_idfk` FOREIGN KEY (`location_type_id`) REFERENCES `location_types` (`id`),
  CONSTRAINT `parent_location_idfk` FOREIGN KEY (`parent_location_id`) REFERENCES `locations` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `inventory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `component_id` int NOT NULL,
  `mfg_code_id` int NOT NULL,
  `full_number` varchar(64) NOT NULL,
  `location_id` int NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `component_idx` (`component_id`),
  KEY `mfg_code_idx` (`mfg_code_id`),
  KEY `location_idx` (`location_id`),
  CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`),
  CONSTRAINT `inventory_ibfk_2` FOREIGN KEY (`mfg_code_id`) REFERENCES `mfg_codes` (`id`),
  CONSTRAINT `inventory_ibfk_3` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `inventory_dates` (
  `id` int NOT NULL AUTO_INCREMENT,
  `inventory_id` int NOT NULL,
  `date_code` varchar(16) NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `inv_idx` (`inventory_id`),
  CONSTRAINT `inventory_dates_ibfk_1` FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `projects` (
	`id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(32) NOT NULL,
    `description` varchar(64) NOT NULL,
    `status_id` int NOT NULL,
    `quantity_to_build` int not null default 1,
    PRIMARY KEY (`id`),
    KEY `project_status_idx` (`status_id`),
    CONSTRAINT `project_status_ibfk` FOREIGN KEY (`status_id`) REFERENCES `list_entries`(`id`)
) ENGINE=InnoDB;

CREATE TABLE `project_items` (
	`id` int NOT NULL AUTO_INCREMENT,
    `project_id` INT NOT NULL,
    `number` int NOT NULL,
    `part_number` varchar(32) NULL,
    `component_id` int NULL,
    `qty_needed` int NOT NULL,
    `inventory_id` int NULL,
    `qty_available` int NULL,
    `qty_to_order` int NULL,
    PRIMARY KEY(`id`),
    KEY `project_idx` (`project_id`),
    KEY `prjct_itm_comp_idx` (`component_id`),
    KEY `prjct_itm_invp_idx` (`inventory_id`),
	CONSTRAINT `project_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`),
    CONSTRAINT `prjct_itm_comp_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`),
    CONSTRAINT `prjct_itm_inv_ibfk_1` FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `project_boms` (
	`id` int NOT NULL AUTO_INCREMENT,
    `project_id` INT NOT NULL,
    `number` int NOT NULL,
    `reference` text NULL,
    `quantity` int NOT NULL,
    `part_number` varchar(128) NULL,
    `processed` tinyint(1) DEFAULT NULL,
    PRIMARY KEY(`id`),
    KEY `project_bom_idx` (`project_id`),
	CONSTRAINT `project_bom_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB;

-- Create any Views
-- DROP VIEW `component_search` ;
CREATE DEFINER = 'chip_app'@'%' SQL SECURITY INVOKER VIEW `component_search` AS 
SELECT 
    `cmp`.`id` AS `id`,
    `cmp`.`component_type_id` AS `component_type_id`,
    `cmp`.`name` AS `chip_number`,
    `ct`.`description` AS `component`,
    `cst`.`name` AS `component_type`,
    `ct`.`table_name` AS `table_name`,
    `pt`.`name` AS `package`,
    `cmp`.`pin_count` AS `pin_count`,
    `cmp`.`description` AS `description`,
    (SELECT 
            SUM(`i`.`quantity`)
        FROM
            `inventory` `i`
        WHERE
            (`i`.`component_id` = `cmp`.`id`)) AS `on_hand`
FROM
    (((`components` `cmp`
    JOIN `package_types` `pt` ON ((`pt`.`id` = `cmp`.`package_type_id`)))
    JOIN `component_types` `ct` ON ((`ct`.`id` = `cmp`.`component_type_id`)))
    LEFT JOIN `component_sub_types` `cst` ON ((`cst`.`id` = `cmp`.`component_sub_type_id`))) 
UNION ALL SELECT 
    `cmp`.`id` AS `id`,
    `cmp`.`component_type_id` AS `component_type_id`,
    `a`.`alias_chip_number` AS `chip_number`,
    `ct`.`description` AS `component`,
    `cst`.`name` AS `component_type`,
    `ct`.`table_name` AS `table_name`,
    `pt`.`name` AS `package`,
    `cmp`.`pin_count` AS `pin_count`,
    CONCAT('See <a href=\'/chips/',
            `a`.`component_id`,
            '\'>',
            `cmp`.`name`,
            '</a>') AS `description`,
    '' AS `on_hand`
FROM
    ((((`aliases` `a`
    JOIN `components` `cmp` ON ((`cmp`.`id` = `a`.`component_id`)))
    JOIN `package_types` `pt` ON ((`pt`.`id` = `cmp`.`package_type_id`)))
    JOIN `component_types` `ct` ON ((`ct`.`id` = `cmp`.`component_type_id`)))
    LEFT JOIN `component_sub_types` `cst` ON ((`cst`.`id` = `cmp`.`component_sub_type_id`)));

-- DROP VIEW `inventory_search` ;
CREATE DEFINER = 'chip_app'@'%' SQL SECURITY INVOKER VIEW `inventory_search` AS 
SELECT 
	i.id, 
    cmp.id as component_id, 
    i.full_number, 
    i.quantity, 
	cmp.name as chip_number, 
    cmp.description, 
    ct.id as component_type_id,
    ct.description as type,
    ct.table_name, 
    l.name as location, 
    mfg_code, 
    manufacturer.name as mfg_name 
FROM inventory i
JOIN components cmp ON cmp.id = i.component_id
JOIN component_types ct ON ct.id = cmp.component_type_id
JOIN mfg_codes ON mfg_codes.id = i.mfg_code_id
JOIN manufacturer ON manufacturer.id = mfg_codes.manufacturer_id
LEFT JOIN locations l ON l.id = i.location_id;

use chip_data;

Insert into mounting_types (id, name, is_through_hole, is_surface_mount, is_chassis_mount)
values	
	(1, "Through Hole", 1, 0, 0),
	(2, "Carrier Mount", 1, 1, 0),
	(3, 'Surface Mount', 0, 1, 0),
	(4, 'Chassis Mount', 0, 0, 1);
commit;

INSERT INTO  package_types (id, name, description, mounting_type_id)
VALUES
	(1,'DIP','Dual In-line Package',1),
    (2,'Axial','Axial',1),
    (3,'Radial','Radial',1),
    (4,'PLCC','Plastic Leaded Chip Carrier',2),
    (5,'Chassis','Chassis',4),
    (6,'SIP','Single In-line Package',1),
    (7,'SMD','Surface Mount Device',3),
    (8,'MELF','Metal Electrode Leadless Face',3),
    (9,'SOIC','Small Outline Integrated Circuit',3),
    (10,'SOP','Small Outline Package',3),
    (11,'SOT','Small Outline Transistor',3),
    (12,'SOD','Small Outline Diode',3),
    (13,'QFP','Quad Flat Package',3),
    (14,'QFN','Quad Flat No-Leads Package',3),
    (15,'THD','Through Hole Device',1),
    (16,'QIP','Quad in-line package',1),
    (17,'TO-XX','Transistor Outline',1),
    (18,'Clamp','Fuse Clamp',1),
    (19,'PGA','Pin Grid Array',2);
commit;

INSERT INTO component_types (id, name, description, symbol, table_name)
VALUES
	(1,'IC','Integrated Circuit','U','chips'),
    (2,'Cap','Capacitor','C','capacitors'),
    (3,'CN','Capacitor Network','CN','capacitor_networks'),
    (4,'Res','Resistor','R','resistors'),
    (5,'RN','Resistor Network','RN','resistor_networks'),
    (6,'Diode','Diode','D','diodes'),
    (7,'Transistor','Transistor','Q','transistors'),
    (8,'Inductor','Inductor','L','inductors'),
    (9,'Switch','Switch','SW','switches'),
    (10,'Xtal','Crystal','Y','crystals'),
    (11,'Jack','Connector Jack','J','connector_jacks'),
    (12,'Plug','Connector Plug','JP','connector_plugs'),
    (13,'Fuse','Fuse','F','fuses'),
    (14,'XFMR','Transformer','T','transformers'),
    (15,'Wire','Wire','W','wires'),
    (16,'Socket','Socket','ICS','sockets');
commit;

INSERT INTO component_sub_types (id, component_type_id, name, description)
VALUES 
	(1,1,'7400','7400 series of chips'),
    (2,1,'5400','5400 series of chips'),
    (3,1,'4000','4000 series of chips'),
    (4,1,'Power','Power related chips'),
    (5,1,'Driver','Signal or bus driver chips'),
    (6,1,'Linear','Linear chips'),
    (7,1,'PIA','Peripheral Interface Adapter chips '),
    (8,1,'MPU','Micro Processor Unit chips'),
    (10,1,'Memory','Memory chips'),
    (11,1,'PIC','PIC Micro-controller'),
    (12,1,'UART','UART Support Chips'),
    (13,1,'MAX','Maxim Communication Line Driver Chips'),
    (14,1,'I2C','I2C Support chips'),
    (15,1,'Optical','Optical Support Chips'),
    (16,1,'Analog','Analog Support chips'),
    (17,2,'Ceramic','Ceramic Capacitor'),
    (18,2,'Film','Film Capacitor'),
    (19,2,'Tantalum','Polarized Tantalum Capacitor'),
    (20,2,'Polymer','Polymer Capacitor'),
    (21,2,'Electrolytic','Polarized Electrolytic Capacitor'),
    (22,2,'Super Cap','Polarized Super Capacitor'),
    (23,2,'Trimmer','Trimmer Capacitor'),
    (24,2,'Variable','Variable Capacitor'),
    (25,3,'Ceramic','Ceramic Capacitor'),
    (26,3,'Film','Thick Film Capacitor'),
    (27,3,'Poly','Polypropylene Capacitor'),
    (28,4,'Metal Film','Metal Film Resistor'),
    (29,4,'Variable','Variable Resistor'),
    (30,4,'Wire Wound','Wire Wound Resistor'),
    (31,4,'Carbon','Carbon Composite Resistor'),
    (32,4,'Photo','Photo Resistor'),
    (33,4,'Thermistor','Thermistor'),
    (36,1,'Atmel','Atmel AVR MCU'),
    (37,10,'VCXO','Voltage-Controlled Crystal Oscillator)'),
    (38,10,'TCXO','Temperature-Compensated Crystal Oscillator'),
    (39,10,'OCXO','Oven-Controlled Crystal Oscillator'),
    (40,10,'VCTCXO','Voltage-Controlled Temperature-Compensated Crystal Oscillator'),
    (41,1,'Timer','Timer and related chips'),
    (42,1,'Audio','Audio chips'),
    (43,1,'Sensor','Data Collection chips'),
    (44,1,'Op Amp','Operational Amplifiers'),
    (45,1,'LED Display','LED Segmented Display'),
    (46,1,'Video','Video related'),
    (47,15,'Solid','Solid Core'),
    (48,15,'Stranded','Stranded Core'),
    (49,15,'M/M','Male to Male'),
    (50,15,'F/F','Female to Female'),
    (51,15,'F/M','Female to Male'),
    (52,7,'BJT NPN','Bipolar Junction Transistor NPN'),
    (53,7,'FET N-Channel','Field-Effect Transistor N-Channel'),
    (54,7,'BJT PNP','Bipolar Junction Transistor PNP'),
    (55,7,'FET P-Channel','Field Effect Transistor P-Channel'),
    (56,5,'Bussed','Bussed Common'),
    (57,5,'Isolated','Individual resistors'),
    (58,5,'Voltage Divider','Series with taps'),
    (59,5,'R2R Ladder','R–2R ladder D to A Conversion'),
    (60,5,'Decade Resistor','Decade Resistor'),
    (61,5,'Dual Terminator','Dual-line termination'),
    (62,4,'Carbon Film','Carbon Film Resistor'),
    (63,16,'Gold','Gold Leads'),
    (64,16,'Tin','Tin Leads'),
    (65,16,'TIn-Lead','Tin-Lead Leads'),
    (66,6,'LED','Light Emitting Diode'),
    (67,6,'Zener','Zener'),
    (68,6,'Schotkey','Schotkey'),
    (69,6,'General','General'),
    (70,12,'Tin','Tin Leads'),
    (71,12,'Gold','Gold Leads'),
    (72,11,'Tin','Tin Leads'),
    (73,11,'Gold','Gold Leads'),
    (74,13,'Medium Blow','Medium Blow'),
    (75,13,'Slow Blow','Slow Blow'),
    (76,13,'Fast Blow','Fast Blow'),
    (77,9,'Momentary','Momentary'),
    (78,9,'Slide','Slide'),
    (79,9,'Toggle','Toggle'),
    (80,9,'Rotary','Rotary');
commit;

INSERT INTO component_packages (component_type_id, package_type_id)
VALUES 
    (1, 1), (1, 4), (1, 6), (1, 9), (1, 10), (1, 13), (1, 14), (1, 16), (1, 17), (1, 19),
	(2, 2), (2, 3), (2, 5), (2, 7),
	(3, 1), (3, 6), (3, 7), (3, 15),
    (4, 2), (4, 3), (4, 5), (4, 7), (4, 8), (4, 15),
    (5, 1), (5, 6), (5, 7), (5, 10), (5, 11), (5, 15), (5, 17), 
    (6, 2), (6, 3), (6, 7), (6, 12), (6, 17),
    (7, 11), (7, 17),
    (8, 2), (8, 3), (8, 15),
    (9, 15),
    (10, 1), (10, 3), (10, 7), (10, 15),
    (11, 6), (11, 7), (11, 15),
    (12, 6), (12, 7), (12, 15),
    (13, 2), (13, 3), (13, 7), (13, 15), (13, 18),
    (14, 15),
    (15, 2),
    (16, 1), (16, 4), (16, 6), (16, 9);
commit;

INSERT INTO lists (id, name, description)
VALUES 
	(1,'Capacitance','Suffix for capacitor values in Farads'),
    (2,'Resistance','Suffix for resistor values in ohms'),
    (3,'ProjectStatus','Project Statuses'),
    (4,'LEDColor','LED light color'),
    (5,'Voltages','Suffix for various  voltages'),
    (6,'LensColor','Lens Color'),
    (7,'FuseRating','Amp Rating for fuse'),
    (8,'Frequency','Frequency modifiers'),
    (9,'Power','Power Rating Units Watts'),
    (10,'TransistorUsage','Transistor Usage Type');
commit;

INSERT INTO list_entries (id, list_id, sequence, name, description, modifier_value)
VALUES 
	(1,1,1,'pF','pico-farad',-12),
    (2,1,2,'nF','nano-farad',-9),
    (3,1,3,'&micro;F','micro-farad',-6),
    (4,1,4,'mF','milli-farad',-3),
    (5,1,5,'F','farad',0),
    (6,2,1,'&Omega;','Ohm',0),
    (7,2,2,'k&Omega;','Kilo-Ohm',3),
    (8,2,2,'M&Omega;','Mega-Ohm',6),
    (9,3,1,'Pending','Pending',0),
    (10,3,2,'Ordering','Ordering Parts',0),
    (11,3,3,'Ready','Ready to start',0),
    (12,3,4,'In Progress','In Progress',0),
    (13,3,5,'Completed','Completed',0),
    (14,3,6,'Canceled','No longer working',0),
    (15,3,0,'New','New Project',0),
    (16,4,1,'Red','Red',2),
    (17,4,2,'Amber','Amber',2),
    (18,4,3,'Green','Green',2),
    (19,4,4,'Blue','Blue',2),
    (20,4,6,'Red/Green','Red and Green',3),
    (21,4,5,'White','White',2),
    (22,4,7,'RGB','Multi',4),
    (23,5,1,'V','Volts',0),
    (24,5,2,'mV','milli-voltes',-3),
    (25,6,1,'Clear','Clear',0),
    (26,6,2,'Red','Red',0),
    (27,6,3,'Orange','Orange',0),
    (28,6,4,'Yellow','Yellow',0),
    (29,6,5,'Green','Green',0),
    (30,6,6,'Blue','Blue',0),
    (31,5,3,'&micro;V','micro-volt',-6),
    (32,7,1,'A','Amp',0),
    (33,7,2,'mA','milli-amp',-3),
    (34,7,3,'&micro;A','micro-amp',-6),
    (35,8,1,'Hz','Hertz',0),
    (36,8,2,'kHz','Kilohertz',3),
    (37,8,3,'mHz','megahertz',6),
    (38,8,4,'gHz','gigahertz',9),
    (39,9,1,'&micro;W','micro-watt',-6),
    (40,9,2,'mW','milli-watt',-3),
    (41,9,3,'W','Watt',0),
    (42,9,4,'kW','kilo-watt',3),
    (43,9,5,'MW','mega-watt',6),
    (44,9,6,'GW','giga-watt',9),
    (45,10,1,'General','General',0),
    (46,10,2,'Switch','Switch',0),
    (47,10,3,'Audio','Audio',0),
    (48,10,4,'Reset','Reset',0);
commit;

INSERT INTO manufacturer (id, name)
VALUES 
	(2,'Advanced Micro Devices'),(3,'Advanced Monolithic Systems'),(4,'AEG'),(5,'Allegro Microsystems'),(6,'Altera'),
    (7,'AMD'),(8,'Amperex'),(9,'Amtel'),(10,'Analog Devices'),(11,'Analog Systems'),(12,'Apex'),(13,'Atmel'),
    (14,'Benchmarq Microelectronics Inc.'),(15,'Brooktree'),(16,'Burr-Brown'),(17,'California Micro Devices Corp.'),
    (18,'Comlinear'),(19,'Cypress'),(20,'Dallas Semiconductor'),(21,'Datel'),(22,'EG&G Reticon'),(23,'Elantec'),(24,'Epson'),
    (25,'Ericsson'),(26,'ESMF'),(27,'Exar'),(28,'Fairchild'),(29,'Ferranti'),(30,'Fujitsu'),(31,'Gazelle'),(32,'GE'),
    (33,'GEC-Plessey Semiconductor'),(34,'General Instrument'),(35,'Goldstar'),(36,'Harris'),(37,'Harris, Cherry Semiconductor'),
    (38,'Harris, Temic'),(39,'Hewlett-Packard'),(40,'Hitachi'),(41,'Holtek'),(42,'Honeywell'),(43,'Hyundai'),(44,'IC Works'),
    (45,'Information Chips and Technology Inc.'),(46,'Information Strorage Devices'),(47,'Inmos'),(48,'Integrated Device Technology'),
    (49,'Integrated Silicon Solutions Inc.'),(50,'Intel'),(51,'International Rectifier'),(52,'ITT'),(53,'Lattice'),
    (54,'Linear Technology Corporation'),(55,'LSI Computer Systems'),(56,'Lucent Technologies'),(57,'M. S. Kennedy'),(58,'Macronix'),
    (59,'Marconi'),(60,'Maxim'),(61,'Micra Hybrids'),(62,'Micrel'),(63,'Micro Linear Corp.'),(64,'Micro Networks'),
    (65,'Micro Power (Exar)'),(66,'Microchip'),(67,'Microcomputers Systems Components'),(68,'Microsystems International'),
    (69,'Mitel Semiconductor'),(70,'Mitsubishi'),(71,'Monolithics'),(72,'MOS Technology'),(73,'Mostek'),(74,'Motorola'),
    (75,'National Semiconductor'),(76,'NEC'),(77,'New Japanese Radio Corp.'),(78,'Newport'),(79,'Nippon Precision Circuits'),
    (80,'Nitron'),(81,'Oki'),(82,'ON Semiconductor'),(83,'ON Semiconductor (previously Thomson)'),(84,'ON Semiconductor (previously Thomson))'),
    (85,'Optek'),(86,'Optical Electronics Inc.'),(87,'Panasonic'),(88,'Paradigm'),(89,'Performance Semiconductor'),(90,'Philips'),
    (91,'Plessy'),(92,'Precision Monolithic'),(93,'Quality Semiconductor Inc.'),(94,'Raytheon'),(95,'Rockwell'),(96,'Samsung'),(97,'Sanyo'),
    (98,'Seeq'),(99,'Seiko'),(100,'Sharp'),(101,'Siemens'),(102,'Silicon General (Infinity Micro)'),(103,'Silicon Storage Technology'),
    (104,'Siliconix'),(105,'Siliconix, Intel'),(106,'Siltronics'),(107,'Sony'),(108,'Sony, Cyrix'),(109,'Sprague'),
    (110,'Standard Microsystem Corp.'),(111,'Startech'),(112,'Supertex, Temic'),(113,'Syntaq'),(114,'Taytheon'),(115,'Telcom Semiconductor'),
    (116,'Teledyne Philbrick'),(117,'Teledyne Semiconductor'),(118,'Telefunken'),(119,'Telmos'),(120,'Temic'),
    (121,'Temic, Seagate Microelectronics'),(122,'TESLA'),(123,'Texas Instruments'),(124,'Toshiba'),(125,'TRW'),
    (126,'United Microelectronics Corp.'),(127,'Unitrode'),(128,'US Microchip'),(129,'Vantis (AMD)'),(130,'VLSI Technology Inc.'),
    (131,'VTC'),(132,'Waferscale Integration inc. (WSI)'),(133,'Western Digital'),(134,'Xicor'),(135,'Zentrum Microelectronics'),
    (136,'Zetex'),(137,'Zilog'),(138,'Signetics Corporation (NPX)'),(139,'Würth Elektronik'),(140,'Stackpole Electronics Inc'),
    (141,'Bourns Inc'),(142,'KYOCERA AVX'),(143,'KEMET'),(144,'TDK Corporation'),(145,'Adam Tech'),(146,'TE Connectivity AMP Connectors'),
    (147,'On Shore Technology Inc.'),(148,'AdaFruit Industries LLC'),(149,'Amphenol ICC'),(150,'TE Connectivity ALCOSWITCH Switches'),
    (151,'Assmann WSW Components');
commit;

INSERT INTO mfg_codes (id, manufacturer_id, mfg_code) 
VALUES 
	(1,2,'AM'),(2,3,'AMSREF'),(3,4,'OM'),(4,4,'PCD'),(5,4,'PCF'),(6,4,'SAA'),(7,4,'SAB'),(8,4,'SAF'),(9,4,'SCB'),(10,4,'SCN'),(11,4,'TAA'),(12,4,'TBA'),
    (13,4,'TCA'),(14,4,'TEA'),(15,5,'A'),(16,5,'STR'),(17,5,'UCN'),(18,5,'UDN'),(19,5,'UDS'),(20,5,'UGN'),(21,6,'EP'),(22,6,'EPM'),(23,6,'PL'),(24,7,'A'),
    (25,7,'Am'),(26,7,'AMPAL'),(27,7,'PAL'),(28,8,'OM'),(29,8,'PCD'),(30,8,'PCF'),(31,8,'SAA'),(32,8,'SAB'),(33,8,'SAF'),(34,8,'SCB'),(35,8,'SCN'),
    (36,8,'TAA'),(37,8,'TBA'),(38,8,'TCA'),(39,8,'TEA'),(40,9,'V'),(41,10,'AD'),(42,10,'ADEL'),(43,10,'ADG'),(44,10,'ADLH'),(45,10,'ADM'),(46,10,'ADVFC'),
    (47,10,'AMP'),(48,10,'BUF'),(49,10,'CAV'),(50,10,'CMP'),(51,10,'DAC'),(52,10,'HAS'),(53,10,'HDM'),(54,10,'MUX'),(55,10,'OP'),(56,10,'PM'),(57,10,'REF'),
    (58,10,'SSM'),(59,10,'SW'),(60,11,'MA'),(61,12,'PA'),(62,13,'AT'),(63,13,'ATV'),(64,14,'BQ'),(65,15,'BT'),(66,16,'ADS'),(67,16,'ALD'),(68,16,'BUF'),
    (69,16,'DAC'),(70,16,'DCP'),(71,16,'INA'),(72,16,'IS'),(73,16,'ISO'),(74,16,'IVC'),(75,16,'MPC'),(76,16,'MPY'),(77,16,'OPA'),(78,16,'OPT'),(79,16,'PCM'),
    (80,16,'PGA'),(81,16,'PWR'),(82,16,'RCV'),(83,16,'REF'),(84,16,'REG'),(85,16,'SHC'),(86,16,'UAF'),(87,16,'VCA'),(88,16,'VFC'),(89,16,'XTR'),(90,17,'G'),
    (91,18,'CLC'),(92,19,'CY'),(93,19,'PALCE'),(94,20,'DS'),(95,21,'AM'),(96,22,'RD'),(97,22,'RF'),(98,22,'RM'),(99,22,'RT'),(100,22,'RU'),(101,23,'EL'),
    (102,24,'RTC'),(103,25,'PBL'),(104,26,'SFC'),(105,27,'XR'),(106,28,'A'),(107,28,'DM'),(108,28,'F'),(109,28,'L'),(110,28,'MM'),(111,28,'NM'),(112,28,'NMC'),
    (113,28,'UNX'),(114,29,'FSS'),(115,29,'ZLD'),(116,29,'ZN'),(117,30,'MB'),(118,30,'MBL8'),(119,30,'MBM'),(120,31,'GA'),(121,32,'GEL'),(122,33,'MVA'),
    (123,33,'ZN'),(124,34,'ACF'),(125,34,'AY'),(126,34,'GIC'),(127,34,'GP'),(128,34,'SPR'),(129,35,'GL'),(130,35,'GM'),(131,35,'GMM'),(132,36,'AD'),
    (133,36,'CA'),(134,36,'CD'),(135,36,'CDP'),(136,36,'CP'),(137,36,'H'),(138,36,'HA'),(139,36,'HFA'),(140,36,'HI'),(141,36,'HIN'),(142,36,'HIP'),
    (143,36,'HV'),(144,36,'ICH'),(145,36,'ICL'),(146,36,'ICM'),(147,36,'IM'),(148,37,'CS'),(149,38,'DG'),(150,39,'HCPL'),(151,39,'HCTL'),(152,39,'HPM'),
    (153,40,'HA'),(154,40,'HD'),(155,40,'HG'),(156,40,'HL'),(157,40,'HM'),(158,40,'HN'),(159,41,'HT'),(160,42,'HAD'),(161,42,'HDAC'),(162,42,'SS'),(163,43,'HY'),
    (164,44,'W'),(165,45,'PEEL'),(166,46,'ISD'),(167,47,'IMS'),(168,48,'IDT'),(169,49,'IS'),(170,50,'C'),(171,50,'i'),(172,50,'I'),(173,50,'N'),(174,50,'P'),
    (175,50,'PA'),(176,51,'IR'),(177,52,'ITT'),(178,53,'GAL'),(179,53,'ISPLSI'),(180,54,'LT'),(181,54,'LTC'),(182,54,'LTZ'),(183,55,'LS'),(184,56,'ATT'),
    (185,57,'MSK'),(186,58,'MX'),(187,59,'MA'),(188,60,'MAX'),(189,60,'MX'),(190,60,'SI'),(191,61,'MC'),(192,62,'MIC'),(193,63,'ML'),(194,64,'MN'),(195,65,'MP'),
    (196,66,'PIC'),(197,67,'MSC'),(198,68,'MIL'),(199,69,'MT'),(200,70,'M'),(201,70,'MSL8'),(202,71,'CMP'),(203,71,'MAT'),(204,71,'OP'),(205,71,'SSS'),
    (206,72,'MCS'),(207,73,'MK'),(208,74,'HEP'),(209,74,'LF'),(210,74,'MC'),(211,74,'MCC'),(212,74,'MCCS'),(213,74,'MCM'),(214,74,'MCT'),(215,74,'MEC'),
    (216,74,'MM'),(217,74,'MPF'),(218,74,'MPQ'),(219,74,'MPS'),(220,74,'MPSA'),(221,74,'MWM'),(222,74,'SG'),(223,74,'SN'),(224,74,'TDA'),(225,74,'TL'),
    (226,74,'UA'),(227,74,'UAA'),(228,74,'UC'),(229,74,'ULN'),(230,74,'XC'),(231,75,'A'),(232,75,'ADC'),(233,75,'CLC'),(234,75,'COP'),(235,75,'DAC'),(236,75,'DM'),
    (237,75,'DP'),(238,75,'DS'),(239,75,'F'),(240,75,'L'),(241,75,'LF'),(242,75,'LFT'),(243,75,'LH'),(244,75,'LM'),(245,75,'LMC'),(246,75,'LMD'),(247,75,'LMF'),
    (248,75,'LMX'),(249,75,'LPC'),(250,75,'LPC'),(251,75,'MF'),(252,75,'MM'),(253,75,'NH'),(254,75,'UNX'),(255,76,'PB'),(256,76,'PC'),(257,76,'PD'),(258,76,'UPD'),
    (259,76,'UPD8'),(260,77,'NJM'),(261,78,'NSC'),(262,79,'SM'),(263,80,'NC'),(264,81,'MM'),(265,81,'MSM'),(266,82,'MC'),(267,83,'EF'),(268,83,'ET'),(269,83,'GSD'),
    (270,83,'HCF'),(271,83,'L'),(272,83,'LM'),(273,83,'LS'),(274,83,'M'),(275,83,'MC'),(276,83,'MK'),(277,83,'OM'),(278,83,'PCD'),(279,83,'PCF'),(280,83,'SAA'),
    (281,83,'SAB'),(282,83,'SAF'),(283,83,'SCB'),(284,83,'SCN'),(285,83,'SFC'),(286,83,'SG'),(287,83,'ST'),(288,83,'TAA'),(289,83,'TBA'),(290,83,'TCA'),(291,83,'TD'),
    (292,83,'TDA'),(293,83,'TDF'),(294,83,'TEA'),(295,83,'TL'),(296,83,'TS'),(297,83,'TSH'),(298,83,'UC'),(299,83,'ULN'),(300,84,'AVS'),(301,85,'OHN'),(302,86,'AH'),
    (303,87,'AN'),(304,88,'PDM'),(305,89,'P'),(306,90,'HEF'),(307,90,'MAB'),(308,90,'N'),(309,90,'NE'),(310,90,'OM'),(311,90,'PC'),(312,90,'PCD'),(313,90,'PCF'),
    (314,90,'PLC'),(315,90,'PLS'),(316,90,'PZ'),(317,90,'S'),(318,90,'SA'),(319,90,'SAA'),(320,90,'SAB'),(321,90,'SAF'),(322,90,'SC'),(323,90,'SCB'),(324,90,'SCC'),
    (325,90,'SCN'),(326,90,'SE'),(327,90,'SP'),(328,90,'TAA'),(329,90,'TBA'),(330,90,'TCA'),(331,90,'TDA'),(332,90,'TEA'),(333,90,'UA'),(334,90,'UMA'),(335,91,'MN'),
    (336,91,'SL'),(337,91,'SP'),(338,91,'TAB'),(339,92,'BUF'),(340,93,'QS'),(341,94,'R'),(342,94,'Ray'),(343,94,'RC'),(344,94,'RM'),(345,95,'R'),(346,96,'KA'),
    (347,96,'KM'),(348,96,'KMM'),(349,97,'LA'),(350,97,'LC'),(351,98,'NQ'),(352,98,'PQ'),(353,99,'RTC'),(354,100,'IR'),(355,101,'OM'),(356,101,'PCD'),(357,101,'PCF'),
    (358,101,'SAA'),(359,101,'SAB'),(360,101,'SABE'),(361,101,'SAF'),(362,101,'SCB'),(363,101,'SCN'),(364,101,'TAA'),(365,101,'TBA'),(366,101,'TCA'),(367,101,'TEA'),
    (368,102,'SG'),(369,103,'PH'),(370,104,'DF'),(371,104,'L'),(372,104,'LD'),(373,105,'D'),(374,106,'L'),(375,106,'LD'),(376,107,'BX'),(377,107,'CXK'),(378,108,'CX'),
    (379,109,'TPQ'),(380,109,'UCS'),(381,110,'COM'),(382,110,'KR'),(383,111,'ST'),(384,112,'CM'),(385,113,'SYD'),(386,113,'SYS'),(387,114,'TMC'),(388,115,'TC'),
    (389,115,'TCM'),(390,116,'TP'),(391,117,'TSC'),(392,118,'OM'),(393,118,'PCD'),(394,118,'PCF'),(395,118,'SAA'),(396,118,'SAB'),(397,118,'SAF'),(398,118,'SCB'),
    (399,118,'SCN'),(400,118,'TAA'),(401,118,'TBA'),(402,118,'TCA'),(403,118,'TEA'),(404,119,'TML'),(405,120,'HM'),(406,120,'MC'),(407,120,'P'),(408,120,'S'),
    (409,120,'SD'),(410,120,'SI'),(411,120,'U'),(412,121,'IP'),(413,122,'MA'),(414,122,'MAA'),(415,122,'MH'),(416,122,'MHB'),(417,123,'MC'),(418,123,'NE'),
    (419,123,'OP'),(420,123,'RC'),(421,123,'SG'),(422,123,'SN'),(423,123,'TIBPAL'),(424,123,'TIL'),(425,123,'TIP'),(426,123,'TIPAL'),(427,123,'TIS'),(428,123,'TL'),
    (429,123,'TLC'),(430,123,'TLE'),(431,123,'TM'),(432,123,'TMS'),(433,123,'UA'),(434,123,'ULN'),(435,124,'T'),(436,124,'TA'),(437,124,'TC'),(438,124,'TD'),
    (439,124,'THM'),(440,124,'TMM'),(441,124,'TMP'),(442,124,'TMPZ'),(443,125,'TDC'),(444,126,'UM'),(445,127,'L'),(446,127,'UC'),(447,127,'UCC'),(448,128,'ULN'),
    (449,129,'MACH'),(450,129,'PALCE'),(451,130,'VT'),(452,131,'VA'),(453,131,'VC'),(454,132,'PSD'),(455,133,'WD'),(456,134,'X'),(457,135,'U'),(458,135,'UD'),
    (459,136,'ZH'),(460,136,'ZLDO'),(461,136,'ZM'),(462,136,'ZMR'),(463,136,'ZR'),(464,136,'ZRA'),(465,136,'ZRB'),(466,136,'ZREF'),(467,136,'ZRT'),(468,136,'ZSD'),
    (469,136,'ZSM'),(470,137,'Z'),(471,138,'S'),(472,139,'WE'),(473,140,'SPE'),(474,141,'BI'),(475,142,'KA'),(476,143,'KE'),(477,144,'TDK'),(478,145,'AT'),
    (479,146,'AMP'),(480,147,'OST'),(481,148,'ADF'),(483,123,'CD'),(484,149,'FCI'),(485,150,'ALC'),(486,151,'AWSW'),(487,82,'2N');
commit;

INSERT INTO location_types (id, name, description, tag) 
VALUES 
	(1,'Room','Room in a building','RM'),
    (2,'Bookshelf','Bookshelf','BS'),
    (3,'Bin','Storage Bin','BN'),
    (4,'Box','Storage Box','BX'),
    (5,'Shelf','Shelf','SH'),
    (6,'Building','Building','BLD'),
    (7,'Workbench','Workbench','WB'),
    (8,'Desk','Desk','DSK'),
    (9,'Drawer','Drawer','DWR'),
    (10,'Tray','Chip Tray','TR'),
    (11,'Basket','Basket','BSK'),
    (12,'Bag','Anti-static parts bag','BG');
commit;

GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE VIEW, SHOW VIEW ON chip_data.* TO `chip_app`@`%`;
FLUSH PRIVILEGES;

