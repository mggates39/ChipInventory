use chip_data;

Insert into mounting_types (id, name, is_through_hole, is_surface_mount, is_chassis_mount)
values	
	(1, "through hole", 1, 0, 0),
	(2, "carrier mount", 1, 1, 0),
	(3, 'surface mount', 0, 1, 0),
	(4, 'chassis mount', 0, 0, 1);
commit;

INSERT INTO  package_types (id, name, description, mounting_type_id)
VALUES
	('1', 'DIP', 'Dual In-Line Package', '1'),
	('2', 'Axial', 'Axial', '1'),
	('3', 'Radial', 'Radial', '1'),
	('4', 'PLCC', 'Plastic Leaded Chip Carrier', '2'),
	('5', 'Chassis', 'Chassis', '4'),
	('6', 'Array', 'In-line Array', '1'),
	('7', 'SMD', 'Surface Mount Device', '3'),
	('8', 'MELF', 'Metal Electrode Leadless Face', '3'),
	('9', 'SOIC', 'Small Outline Integrated Circuit', '3'),
	('10', 'SOP', 'Small Outline Package', '3'),
	('11', 'SOT', 'Small Outline Transistor', '3'),
	('12', 'SOD', 'Small Outline Diode', '3'),
	('13', 'QFP', 'Quad Flat Package', '3'),
	('14', 'QFN', 'Quad Flat No-Leads Package', '3'),
	('15', 'THD', 'Through Hole Device', '1'),
	('16', 'QIP', 'Quad in-line package', '1'),
	('17', 'TO-XX', 'Transistor Outline', '1'),
	('18', 'Clamp', 'Fuse Clamp', '1');
commit;

INSERT INTO component_types (id, description, symbol, table_name)
VALUES
	(1,'Integrated Circuit','U','chips'),
	(2,'Capacitor','C','passives'),
	(3,'Capacitor Network','CN','passives'),
	(4,'Resistor','R','passives'),
    (5,'Resistor Network','RN','passives'),
    (6,'Diode','D','passives'),
    (7,'Transistor','Q','transistors'),
    (8,'Inductor','L','passives'),
    (9,'Switch','SW','switches'),
    (10,'Crystal','Y','crystals'),
    (11,'Connector jack','J','connectors'),
    (12,'Connector plug ','JP','connectors'),
	(13,'Fuse','F','power'),
	(14,'Transformer','T','power');
commit;

-- This can be reloaded to reset the valid packages types for each component type
TRUNCATE TABLE component_packages;
INSERT INTO component_packages (component_type_id, package_type_id)
VALUES (1, 1), (1, 4), (1, 9), (1, 10), (1, 13), (1, 14), (1, 16), (1, 17),
	(2, 2), (2, 3), (2, 5), (2, 7),
	(3, 6),
    (4, 2), (4, 3), (4, 7), (4, 8),
    (5, 6), 
    (6, 2), (6, 7), (6, 12), (6, 17),
    (7, 7), (7, 11), (7,15),
    (8, 15),
    (9, 15),
    (10, 12), (10, 15),
    (11, 12), (11, 15),
    (12, 11), (12, 15),
    (13, 18),
    (14, 15);
commit;


