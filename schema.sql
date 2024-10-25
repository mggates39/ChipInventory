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

CREATE TABLE `crystals` (
  `component_id` int NOT NULL,
  `frequency` varchar(32) NOT NULL,
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

CREATE TABLE `sockets` (
  `component_id` int NOT NULL,
  `datasheet` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`component_id`),
  CONSTRAINT `sockets_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `connectors` (
  `component_id` int NOT NULL,
  `datasheet` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`component_id`),
  CONSTRAINT `connectors_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `fuses` (
  `component_id` int NOT NULL,
  `datasheet` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`component_id`),
  CONSTRAINT `fuses_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
) ENGINE=InnoDB;

CREATE TABLE `inductors` (
  `component_id` int NOT NULL,
  `datasheet` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`component_id`),
  CONSTRAINT `inductors_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
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
  `unit` varchar(32) NOT NULL,
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
    PRIMARY KEY (`id`),
    KEY `project_status_idx` (`status_id`),
    CONSTRAINT `project_status_ibfk` FOREIGN KEY (`status_id`) REFERENCES `list_entries`(`id`)
) ENGINE=InnoDB;

CREATE TABLE `project_items` (
	`id` int NOT NULL AUTO_INCREMENT,
    `project_id` INT NOT NULL,
    `number` int NOT NULL,
    `component_id` int NOT NULL,
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
CREATE VIEW `component_search` AS 
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
CREATE VIEW `inventory_search` AS 
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