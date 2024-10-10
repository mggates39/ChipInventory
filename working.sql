use chip_data;

select mfg_codes.id, name, mfg_code
from manufacturer
join mfg_codes on mfg_codes.manufacturer_id = manufacturer.id
 where mfg_code = 'ST'
order by name, mfg_code;

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


select * from chips where chip_number = '7478';

select c.*, (select sum(quantity) from inventory i where i.chip_id = c.id) on_hand
from chips c;

select * from notes;

select * from chips where id = 256;

select * from aliases where chip_id = 256;

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

select * from notes;
select * from specs;

-- https://semiconductors.es/semiconductors.php?id=500445

select * from chips;
select * from aliases;


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

select * from specs;

select * from chip_aliases
order by 2,3;

select * from manufacturer;

select * from mfg_codes
where manufacturer_id = 75;

select *, (select group_concat( ' ', mfg_code) from mfg_codes mc where mc.manufacturer_id = m.id) mfg_codes
from manufacturer m
order by m.name;

select c.chip_number, c.description, sum(i.quantity) on_hand
from chips c
join inventory i on i.chip_id = c.id
group by c.chip_number, c.description
order by c.chip_number;

    select (SELECT count(*) from chips ) chips,
      (select sum(quantity) from inventory) items;
      
      
-- drop view chip_aliases;


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

select concat(ct.description, 's') description, table_name, count(c.id) ni
from component_types ct
left join components c on ct.id = c.component_type_id
group by ct.description, table_name;

select table_name from component_types;

alter table component_sub_types modify description varchar(64) not null;


select * from component_types;

select * from pins where chip_id = 3;

select family, count(*) ni
from chips
group by family
order by family;

select * from chips
order by family, chip_number;


select * from component_types;
select * from component_sub_types;

select * from package_types;


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

select p.*, CASE WHEN cpt.component_type_id IS NOT NULL THEN 'checked' ELSE '' END used
from package_types p
left join component_packages cpt on cpt.package_type_id = p.id and cpt.component_type_id = 1;


SELECT pt.*, 
      CASE WHEN cpt.component_type_id IS NOT NULL THEN 'true' ELSE 'false' END used  
    FROM package_types pt
    LEFT JOIN component_packages cpt on cpt.package_type_id = pt.id and cpt.component_type_id = 14
    ORDER BY pt.description;
    
select * from component_packages 
-- where component_type_id = 14
order by component_type_id, package_type_id;

-- Migrate core chip data to components
-- INSERT components (id, component_type_id, package_type_id, name, description)
-- SELECT id, 1, package_type_id, chip_number, description
-- FROM chips
-- WHERE 1=1;
-- commit;

-- CREATE INDEX chip_pkg_idx ON chips(package_type_id);
-- ALTER TABLE chips ADD FOREIGN KEY pkg_type_idfk (package_type_id) REFERENCES package_types(id);

-- alter table chips 
-- 	drop FOREIGN KEY chips_ibfk_1,
-- 	drop index chip_pkg_idx,
-- 	drop column package_type_id, 
--     drop column chip_number, 
--     drop column description;
--     commit;-- 

select * from components;

select table_name, count(*) ni
from component_types
group by table_name;


select ct.description component_type, pt.name package_type, count(*) ni 
from components c
join component_types ct on ct.id = c.component_type_id
join package_types pt on pt.id = c.package_type_id
group by ct.description, pt.name
order by ct.description, pt.name;

select id, pin_count, pin_count/4 by4, (pin_count/4) % 2 mod2
from chips;

-- Top
select cmp.name as chip_number, c.pin_count, pintop.pin_number, pintop.pin_symbol
from components cmp
join chips c on c.id = cmp.id
join pins pintop on pintop.chip_id = c.id
where c.id = 267
  and (pintop.pin_number >= 1 and pintop.pin_number <= (pin_count/4))
order by cast(pin_number as signed);

-- right
select cmp.name as chip_number, c.pin_count, pinright.pin_number, pinright.pin_symbol
from components cmp
join chips c on c.id = cmp.id
join pins pinright on pinright.chip_id = c.id
where c.id = 267
  and pinright.pin_number > (c.pin_count/4)
  and pinright.pin_number <= (c.pin_count/2)
order by cast(pin_number as signed);

-- bottom
select cmp.name as chip_number, cmp.pin_count, binbottom.pin_number, binbottom.pin_symbol
from components cmp
join chips c on c.component_id = cmp.id
join pins binbottom on binbottom.component_id = cmp.id
where c.component_id = 267
  and binbottom.pin_number > (cmp.pin_count/2)
  and binbottom.pin_number <= (cmp.pin_count - (cmp.pin_count/4))
order by cast(pin_number as signed) desc;

-- left
select cmp.name as chip_number, c.pin_count, pinleft.pin_number, pinleft.pin_symbol
from components cmp
join chips c on c.id = cmp.id
join pins pinleft on pinleft.chip_id = c.id
where c.id = 267
  and pinleft.pin_number > (c.pin_count - (c.pin_count/4))
order by cast(pin_number as signed) desc;





select * from chips where pin_count = 16;

select * from package_types;
select * from mounting_types;
select * from component_types;

SELECT pt.*, 
	CASE WHEN mt.name IS NOT NULL THEN 'true' ELSE 'false' END used  
FROM package_types pt
LEFT JOIN mounting_types mt on mt.id = pt.mounting_type_id and mt.id = 1
ORDER BY pt.description
;

-- insert into crystals values (174, "32.768kHz","https://www.analog.com/media/jp/technical-documentation/data-sheets/2940.pdf");
-- delete from chips where component_id = 174;
-- commit;
-- update components set component_type_id = 10 where id = 174;
-- commit;

select pt.*, mt.name
from package_types pt
JOIN mounting_types mt on mt.id = pt.mounting_type_id
WHERE mt.is_chassis_mount = 1;

select * from chip_aliases;
select * from aliases;

-- update aliases set alias_chip_number = trim(alias_chip_number)
-- where alias_chip_number like ' %' OR  alias_chip_number like '% ';
-- commit;

-- update component_types set description = trim(description)
-- where description like ' %' or description like '% ';
-- commit;
select * from component_types;

select * from component_sub_types
where component_type_id = 1;

select * from  components cmp
join chips c on c.component_id = cmp.id
-- where cmp.component_sub_type_id is null
where  family like '%zil%'
order by cmp.name
;
select * 
from components cmp
join chips c on c.component_id = cmp.id
where cmp.component_sub_type_id is null
order by cmp.name;

select family, count(*) ni
from chips c
join components cmp on cmp.id = c.component_id
where cmp.component_sub_type_id is null
group by family
order by count(*) desc;

-- update components set component_sub_type_id = 10
-- where id in (select id from chips WHERE family like '%memory%');
-- commit;
-- update components set component_sub_type_id = 38
-- where id = 174;
-- update chips set family = 'Microship' where family like '%micro%';
-- commit;

select cst.name, count(*) ni
from components c
left join component_sub_types cst on cst.id = c.component_sub_type_id
group by cst.name
order by cst.name;


-- alter table components add column pin_count INTEGER null;
-- UPDATE components
-- JOIN chips ON components.id = chips.id
-- SET components.pin_count = chips.pin_count;
-- commit;
-- alter table components modify column pin_count INTEGER NOT NULL;
-- alter table chips drop column pin_count;

select * from components where pin_count is null;


SELECT c.*, cmp.name as chip_number, cmp.description, cmp.package_type_id, cmp.pin_count, pt.name as package 
    FROM components cmp
    JOIN crystals c on c.component_id = cmp.id
    JOIN package_types pt on pt.id = cmp.package_type_id
    JOIN component_types ct on ct.id = cmp.component_type_id;
    
select * from components where id = 80;
select * from chips where component_id = 80;
select * from aliases where component_id = 80;
select * from pins where component_id = 80;

