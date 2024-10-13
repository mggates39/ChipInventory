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

CREATE TABLE `resistors` (
  `component_id` int NOT NULL,
  `resistance`  int unsigned NOT NULL,
  `tolerance` float(6.4) NOT NULL,
  `power` float(7,3) NOT NULL,
  `number_resistors` int NULL,
  `datasheet` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`component_id`),
  CONSTRAINT `resistor_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
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


-- Create any Views
-- DROP VIEW chip_aliases ;
CREATE VIEW `chip_aliases` AS 
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
    LEFT JOIN `component_sub_types` `cst` ON ((`cst`.`id` = `cmp`.`component_sub_type_id`)))

