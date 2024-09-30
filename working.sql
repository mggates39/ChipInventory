use chip_data;

-- truncate table pins;
-- truncate table notes;
-- truncate table specs;
-- truncate table aliases;
-- truncate table chips;
-- truncate table inventory_dates;
-- truncate table inventory;

--  INSERT INTO inventory ( chip_id, full_number, mfg_code_id, quantity)
--  VALUES
--  (70, 'LF353N', 241, 2);

-- INSERT INTO inventory ( chip_id, full_number, mfg_code_id, quantity)
-- VALUES
-- (70, 'LF353N', 287, 5),
-- (218, 'AM27C128', 25, 2),
-- (131, 'AM27C512', 25, 2),
-- (119, '74ATC823', 422, 9),
-- (224, '74ATC821', 422, 4),
-- (62, 'SN74HC374N', 422, 1),
-- (62, 'SN74LS374N', 422, 3),
-- (62, 'SN74LS374NB', 422, 10),
-- (181, 'MC68B09P', 210, 1),
-- (248, 'UCN5800A', 17, 1);

select mfg_codes.id, name, mfg_code
from manufacturer
join mfg_codes on mfg_codes.manufacturer_id = manufacturer.id
 where mfg_code = 'ST'
order by name, mfg_code;

-- insert into component_types ( description, symbol)
-- values
-- ('Integrated Circuit', 'IC');

-- Insert into inventory_dates (inventory_id, date_code, quantity)
-- values
-- (1, '92B509', 3),
-- (1, '57AT', 1),
-- (1, '34AF', 1),
-- (2, '9225', 2),
-- (3, '9313', 1),
-- (3, '9442', 1),
-- (4, '9248', 7),
-- (4, '9536', 2),
-- (5, '9218', 3),
-- (5, '9452', 1),
-- (6, '614DS', 1),
-- (7, '544DS', 1),
-- (7, '614DS', 2),
-- (8, '6803', 1),
-- (8, '6821', 1),
-- (8, '6823', 3),
-- (8, '6813', 5),
-- (9, '8815', 1),
-- (10, '8823', 1)
-- ;

select * from inventory
where id in (1,77);
select * from inventory_dates
where inventory_id in (1,77);

-- update inventory set quantity = 3 where id = 1;

-- update inventory_dates
-- set inventory_id = 77
-- where id in (2,3);

-- update inventory_dates set date_code = 'M57AT'
-- where id = 2;
-- update inventory_dates set date_code = 'M34AF'
-- where id = 3;
-- update inventory set full_number = 'SN74S244NB'
-- where id = 70;

select count(*) ni from chips;


-- update aliases set alias_chip_number = 'SN74H87'
-- where id =77;

select * from chips where chip_number = '7478';
-- update chips set description='4-bit arithmetic logic unit/function generator' where id =253;

select c.*, (select sum(quantity) from inventory i where i.chip_id = c.id) on_hand
from chips c;

select * from notes;

select * from chips where id = 256;
-- update chips set chip_number = '744078' where id=256;
select * from aliases where chip_id = 256;
-- update aliases set alias_chip_number = 'MC74HC4078' where id = 88;


select inventory.id, chip_id, full_number, quantity, chip_number, mfg_code, name, description from inventory
join chips on chips.id = inventory.chip_id
join mfg_codes on mfg_codes.id = inventory.mfg_code_id
join manufacturer on manufacturer.id = mfg_codes.manufacturer_id;

select chips.chip_number, pins.* from chips join pins on pins.chip_id = chips.id where pins.pin_symbol like '%\_\_%';

select chips.chip_number, chips.pin_count, pinleft.pin_number, pinleft.pin_symbol
from chips
join pins pinleft on pinleft.chip_id = chips.id
where chips.id = 29
  and pinleft.pin_number <= (chips.pin_count/2)
order by cast(pin_number as signed);

select chips.chip_number, chips.pin_count, pinright.pin_number, pinright.pin_description
from chips
join pins pinright on pinright.chip_id = chips.id
where chips.id = 29
  and pinright.pin_number > (chips.pin_count/2)
order by cast(pin_number as signed) desc;


select * from pins
where chip_id = 261
order by cast(pin_number as signed);

update pins set pin_description = 'Data Input/Output' where id in (4463, 4484, 4485, 4487, 4488, 4489, 4490, 4491);
commit;
update pins set pin_symbol = '~OE~/V__PP' where id = 2384;
commit;

-- delete from pins where chip_id in (249, 250);
-- delete from chips where id in (249, 250);


select * from notes;
select * from specs;

-- https://semiconductors.es/semiconductors.php?id=500445

select * from chips;
select * from aliases;

-- delete from aliases where id = 112;
-- commit;

select * from pins where pin_description like '%data%';

select *, replace(pin_symbol, 'DA', 'DA__') newsym from pins where pin_symbol like 'DA_';
select * from pins where chip_id = 7;

SELECT inventory.id, chip_id, full_number, quantity, chip_number, description, mfg_code_id 
from inventory
join chips on chips.id = inventory.chip_id
WHERE inventory.id = 18;



select count(*) ni from manufacturer;
select count(*) ni from mfg_codes;
select * from mfg_codes;

select mfg_codes.id, name, mfg_code, concat(mfg_code, ' (', name, ')') display_name
from manufacturer
join mfg_codes on mfg_codes.manufacturer_id = manufacturer.id
-- where mfg_code = 'TMS'
order by mfg_code, name;



    select mfg_codes.id, concat(mfg_code, ' (', name, ')') display_name
    from manufacturer
    join mfg_codes on mfg_codes.manufacturer_id = manufacturer.id
    order by mfg_code, name;

select id, chip_number, description 
from chips
union all
select chip_id as id, alias_chip_number as chip_number, concat("See <a href='/chips/", a.chip_id,"' target='_blank'>", x.chip_number, "</a>") as description
from aliases a
join chips as x on x.id = a.chip_id
order by 2, 3;

select * from notes;
-- update notes set note = 'Output Drive Capability: 10 LSTTL Loads'
-- where id = 256;
-- update notes set note = 'Low Input Current: 1 &micro;A'
-- where id = 258;

select * from specs;

-- update specs set value = '-55 to +125', unit = '&deg;C'
-- where id = 606;

-- update specs set value = replace(value, 'V ', 'V: ')
-- where id = 607;


select * from chip_aliases
order by 2,3;

select * from manufacturer;
-- insert into manufacturer (name) values ('Signetics Corporation (NPX)');
-- 138
select * from mfg_codes
where manufacturer_id = 75;

select *, (select group_concat( ' ', mfg_code) from mfg_codes mc where mc.manufacturer_id = m.id) mfg_codes
from manufacturer m
order by m.name;


-- insert into mfg_codes (manufacturer_id, mfg_code) values ( 138, 'S');
-- commit;


select c.chip_number, c.description, sum(i.quantity) on_hand
from chips c
join inventory i on i.chip_id = c.id
group by c.chip_number, c.description
order by c.chip_number;

    select (SELECT count(*) from chips ) chips,
      (select sum(quantity) from inventory) items;
      
      
-- drop view chip_aliases;

-- CREATE VIEW chip_aliases AS
-- SELECT id, chip_number, family, package, pin_count, description, (select sum(quantity) from inventory i where i.chip_id = c.id) on_hand
-- FROM chips c
-- UNION ALL
-- SELECT chip_id as id, alias_chip_number as chip_number,  '' family, '' package, '' pin_count, concat("See <a href='/chips/", a.chip_id,"'>", x.chip_number, "</a>") as description, '' on_hand
-- FROM aliases a
-- JOIN chips x ON x.id = a.chip_id;

select * from chip_aliases
order by chip_number;

select * from inventory
where chip_id = 70;

select * from inventory_dates
where inventory_id in (1, 77, 81,82);

delete from inventory where id in (81,82);

select sum(quantity) inv_count from inventory;
select sum(quantity) date_count from inventory_dates;

select min(date_code) min, max(date_code) max
from inventory_dates
where date_code REGEXP '^[0-9]+$';

    select (SELECT count(*) from chips ) chips,
      (select count(*) from aliases) aliases,
      (select sum(quantity) from inventory) on_hand,
      (select min(date_code) from inventory_dates where date_code REGEXP '^[0-9]+$') min_date,
      (select max(date_code) from inventory_dates where date_code REGEXP '^[0-9]+$') max_date,
      (select count(*) from manufacturer) mfgs,
      (select count(*) from mfg_codes) codes;

select * from component_types;

-- INSERT INTO component_types (id, description, symbol, table_name)
-- VALUES
-- 	(1,'Integrated Circuit','U','chips'),
-- 	(2,'Capacitor','C','passives'),
-- 	(3,'Capacitor Network','CN','passives'),
-- 	(4,'Resistor','R','passives'),
--     (5,'Resistor Network','RN','passives'),
--     (6,'Diode','D','passives'),
--     (7,'Transistor','Q','transistors'),
--     (8,'Inductor','L','passives'),
--     (9,'Switch','SW','switches'),
--     (10,'Crystal','Y','crystals'),
--     (11,'Connector jack','J','connectors'),
--     (12,'Connector plug ','JP','connectors');
-- commit;

select * from component_types;

select * from pins where chip_id = 3;

select family, count(*) ni
from chips
group by family
order by family;

select * from chips
order by family, chip_number;

-- Insert into mounting_types (name, is_through_hole, is_surface_mount, is_chassis_mount)
-- values	
-- 	("through hole", 1, 0, 0),
-- 	("carrier mount", 1, 1, 0),
-- 	('surface mount', 0, 1, 0),
-- 	('chassis mount', 0, 0, 1);
-- commit;


-- INSERT INTO  package_types (name, description, mounting_type_id)
-- VALUES
-- 	('DIP', 'Dual In-Line Package', 1),
-- 	('Axial', 'Axial', 1),
-- 	('Radial', 'Radial', 1),
-- 	('PLCC','Plastic Leaded Chip Carrier', 2),
-- 	('Chassis', 'Chassis', 4),
--  ('Array', 'In-line Array', 1),
-- 	('SMD', 'Surface Mount Device', 3),
-- 	('MELF', 'Metal Electrode Leadless Face', 3),
--     ('SOIC', 'Small Outline Integrated Circuit', 3),
-- 	('SOP', 'Small Outline Package', 3),
-- 	('SOT','Small Outline Transistor', 3),
-- 	('SOD', 'Small Outline Diode', 3),
--     ('QFP', 'Quad Flat Package', 3),
--     ('QFN', 'Quad Flat No-Leads Package', 3),
-- 	('THD', 'Through Hole Device', 1);
;
-- commit;
-- INSERT INTO  package_types (name, description, mounting_type_id)
-- VALUES
-- commit;


select * from component_types;
select * from package_types;

truncate table component_packages;

INSERT INTO component_packages (component_type_id, package_type_id)
VALUES (1, 1), (1, 4), (1, 9), (1, 10), (1, 13), (1, 14),
	(2, 2), (2, 3), (2, 5), (2, 7),
	(3, 6),
    (4, 2), (4, 3), (4, 7), (4, 8),
    (5, 6), 
    (6, 2), (6, 7), (6, 12),
    (7, 11), (7, 7), (7,15),
    (8, 15),
    (9, 15),
    (10, 12), (10, 15),
    (11, 12), (11, 15),
    (12, 11), (12, 15);
commit;

select * from package_types;

SELECT id, name,
    CASE WHEN is_through_hole = 1 THEN 'Yes' ELSE 'No' END is_through_hole,
    CASE WHEN is_surface_mount = 1 THEN 'Yes' ELSE 'No' END is_surface_mount, 
    CASE WHEN is_chassis_mount = 1 THEN 'Yes' ELSE 'No' END is_chassis_mount 
    FROM mounting_types ORDER BY name;
    
SELECT p.id, p.name, p.description, m.name mounting_type 
FROM package_types p
JOIN mounting_types m on m.id = p.mounting_type_id
ORDER BY p.name;

select * from chips;

