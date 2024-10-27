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

select * from component_search
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
      
      
-- drop view component_search;


select * from component_search
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
      (select count(*) from (select distinct component_id from inventory) a) used_components,
      (select min(date_code) from inventory_dates where date_code REGEXP '^[0-9]+$') min_date,
      (select max(date_code) from inventory_dates where date_code REGEXP '^[0-9]+$') max_date,
      (select count(*) from manufacturer) mfgs,
      (select count(*) from mfg_codes) codes;

select count(*) from (select distinct component_id from inventory) a;

select concat(ct.description, ' Aliases') description, table_name, count(c.id) ni
from component_types ct
join components c on ct.id = c.component_type_id
join aliases a on a.component_id = c.id
group by ct.description, table_name
order by ct.description;

select case when ct.description = 'Switch' then concat(ct.description, 'es') else concat(ct.description, 's') end description, table_name, count(c.id) ni, sum(i.quantity) quantity
from component_types ct
join components c on ct.id = c.component_type_id
join inventory i on i.component_id = c.id
where c.id in (select distinct component_id from inventory)
group by ct.description, table_name
order by ct.description;

select case when ct.description = 'Switch' then concat(ct.description, 'es') else concat(ct.description, 's') end description, table_name, count(c.id) ni
from component_types ct
left join components c on ct.id = c.component_type_id
group by ct.description, table_name
order by ct.description;

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

select * from component_search;
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
-- where cmp.component_sub_type_id is null
group by family
order by count(*) desc;

select family, count(*) ni
from chips c
join components cmp on cmp.id = c.component_id
group by family
order by family;

select * from package_types;

select cst.name, count(c.id) ni
from component_sub_types cst
left join components c on cst.id = c.component_sub_type_id
group by cst.name
order by cst.name;

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


SELECT ct.* , (select count(*) ni from component_sub_types where component_type_id = ct.id) num
FROM component_types ct
ORDER BY description;

SELECT cmp.*, pt.name as package, ct.description as component, ct.table_name 
  FROM components cmp
  JOIN package_types pt on pt.id = cmp.package_type_id
  JOIN component_types ct on ct.id = cmp.component_type_id
  WHERE cmp.id = 268;

select 
      (select count(*) from aliases) aliases,
      (select sum(quantity) from inventory) on_hand,
      (select count(*) from (select distinct component_id from inventory) a) used_components,
      (select SUBSTRING(min(centcode), 3) from (select  case when date_code < '6000' then date_code + 200000 else date_code + 190000 end centcode from inventory_dates where date_code REGEXP '^[0-9]+$') A) min_date,
      (select SUBSTRING(max(centcode), 3) from (select  case when date_code < '6000' then date_code + 200000 else date_code + 190000 end centcode from inventory_dates where date_code REGEXP '^[0-9]+$') A) max_date,
      (select min(date_code) from inventory_dates where date_code REGEXP '^[0-9]+$') omin_date,
      (select max(date_code) from inventory_dates where date_code REGEXP '^[0-9]+$') omax_date,
      (select count(*) from manufacturer) mfgs,
      (select count(*) from mfg_codes) codes
    ;

select SUBSTRING(min(centcode),3) min, SUBSTRING(max(centcode), 3) max
from (
select  case when date_code < '6000' then date_code + 200000 else date_code + 190000 end centcode
from inventory_dates where date_code REGEXP '^[0-9]+$'
) A;


-- truncate table resistors;
-- delete from components where id = 275;
-- commit;

select * from sockets;
select * from components where id = 284;


select * from pins;
select inventory.id, cmp.id as component_id, full_number, quantity, cmp.name as chip_number, cmp.description, description, mfg_code, manufacturer.name 
      from inventory 
      join components cmp on cmp.id = inventory.component_id
      join mfg_codes on mfg_codes.id = inventory.mfg_code_id
      join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
      where full_number like '%300%' or cmp.name like '%300%'
      order by chip_number, full_number;
      
      
    SELECT cst.id, cst.name, cst.description, count(c.id) ni
    FROM component_sub_types cst
    left join components c on c.component_sub_type_id = cst.id
    WHERE cst.component_type_id = 1
    group by cst.id, cst.name, cst.description
    ORDER BY cst.name;
    
    

  SELECT i.id, component_id, full_number, i.mfg_code_id, i.quantity, cmp.name as chip_number, cmp.description, i.location_id, l.name loacation, mfg_code, manufacturer.name 
    from inventory i
    join components cmp on cmp.id = i.component_id
    join mfg_codes on mfg_codes.id = i.mfg_code_id
    join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
    left join locations l on l.id = i.location_id
  WHERE i.id = 1;
  
  
  select i.id, component_id, i.full_number, i.quantity, cmp.name as chip_number, l.name loacation, mfg_code, manufacturer.name   
    from inventory i
    join components cmp on cmp.id = i.component_id
    join mfg_codes on mfg_codes.id = i.mfg_code_id
    join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
    left join locations l on l.id = i.location_id
    where i.component_id = 218
    order by full_number;
  
select inventory.id, inventory.component_id, full_number, quantity, cmp.name as chip_number, cmp.description, 
    l.name location, mfg_code, manufacturer.name 
    from inventory
    join components cmp on cmp.id = inventory.component_id
    join mfg_codes on mfg_codes.id = inventory.mfg_code_id
    join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
    left join locations l on l.id = inventory.location_id
    order by cmp.name, full_number;
    



select inventory.id, cmp.id as component_id, full_number, quantity, 
	cmp.name as chip_number, cmp.description, ct.description as type, ct.table_name, l.name location, 
    mfg_code, manufacturer.name 
from inventory
join components cmp on cmp.id = inventory.component_id
join component_types ct on ct.id = cmp.component_type_id
join mfg_codes on mfg_codes.id = inventory.mfg_code_id
join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
left join locations l on l.id = inventory.location_id
;     

select * from inventory_search;


SELECT ol.id, ol.parent_location_id, ol.location_type_id, ol.name, ol.description, pl.name as parent_location , lt.name as location_type, 
	(select sum(quantity) from inventory where inventory.location_id = ol.id) num_items,
    (select sum(1) from locations cl where cl.parent_location_id = ol.id) num_child_locations
    FROM locations ol
    LEFT JOIN locations pl on pl.id = ol.parent_location_id
    LEFT JOIN location_types lt on lt.id = ol.location_type_id
    ORDER BY ol.name;
    
    
SELECT ol.*, lt.name as location_type, 
 	(select sum(quantity) from inventory where inventory.location_id = ol.id) num_items,
    (select sum(1) from locations cl where cl.parent_location_id = ol.id) num_child_locations
    FROM locations ol
    LEFT JOIN location_types lt on lt.id = ol.location_type_id
    WHERE ol.parent_location_id = 5
    ORDER BY ol.name;    

SELECT le.*
FROM list_entries le
JOIN lists l on l.id = le.list_id
WHERE l.name = 'ProjectStatus'
ORDER BY le.sequence;

select r.*, c.name, c.description 
from resistors r
join components c on c.id = r.component_id;

SELECT l.id, l.name, l.description, count(le.id) num_entries 
FROM lists l 
LEFT JOIN list_entries le on le.list_id = l.id
GROUP BY l.id, l.name, l.description
ORDER BY l.name;

select r.component_id, r.capacitance, le.name unit_label, c.name, c.description
from capacitors r
join components c on c.id = r.component_id
left join list_entries le on le.id = r.unit_id;

select r.component_id, r.resistance, le.name unit_label, c.name, c.description
from resistors r
join components c on c.id = r.component_id
left join list_entries le on le.id = r.unit_id;

   SELECT p.id, p.name, p.description, le.name as status_value,  count(pi.id) num_items, 
      sum(qty_needed) needed, sum(qty_available) available, sum(qty_to_order) on_order
    FROM projects p 
    JOIN list_entries le on le.id = p.status_id
    LEFT JOIN project_items pi on pi.project_id = p.id
    GROUP BY  p.id, p.name, p.description, le.name 
    ORDER BY p.name;
    
select c.*, ct.name component_type_name 
from components c
join component_types ct on ct.id = c.component_type_id;

select pi.*, c.name, c.description, i.full_number
from project_items pi
join components c on c.id = pi.component_id
left join inventory i on i.id = pi.inventory_id;

select *
from project_boms
order by project_id, number;

SELECT *
FROM project_boms
WHERE project_id = 1
  AND processed = 0
ORDER BY number;

SELECT *
FROM inventory_dates
where inventory_id = 111;

select * from inventory where id =111;

select * from locations;

select * from project_items where qty_available = 0;



WITH RECURSIVE cte_connect_by AS (
	SELECT 1 AS level, cast(CONCAT('/', name) as char(4000)) AS connect_by_path, s.* 
	FROM locations s WHERE id = 1
	UNION ALL
	SELECT level + 1 AS level, CONCAT(connect_by_path, '/', s.name) AS connect_by_path, s.* 
	FROM cte_connect_by r 
    INNER JOIN locations s ON  r.id = s.parent_location_id
)
SELECT p.name as project, pi.number, ct.name as type, c.name as component, i.full_number as part_number,
	pi.qty_needed, ccb.connect_by_path
FROM projects p
JOIN project_items pi ON pi.project_id = p.id
JOIN components c ON c.id = pi.component_id
JOIN component_types ct ON ct.id = c.component_type_id
LEFT JOIN inventory i ON i.id = pi.inventory_id
LEFT JOIN cte_connect_by ccb ON ccb.id =  i.location_id
WHERE p.id = 1
ORDER BY pi.number;


 with recursive cte (id, name, parent_location_id) as (
  select     id,
             name,
             parent_location_id
  from       locations
  where      parent_location_id = 1
  union all
  select     l.id,
             l.name,
             l.parent_location_id
  from       locations l
  inner join cte
          on l.parent_location_id = cte.id
)
select * from cte;


  WITH RECURSIVE cte_connect_by AS (
     SELECT 1 AS level, cast(CONCAT('/', name) as char(4000)) AS connect_by_path, s.* 
       FROM locations s WHERE id = 1
     UNION ALL
     SELECT level + 1 AS level, CONCAT(connect_by_path, '/', s.name) AS connect_by_path, s.* 
       FROM cte_connect_by r INNER JOIN locations s ON  r.id = s.parent_location_id
  )
  SELECT id, name, parent_location_id, level, connect_by_path path
  FROM cte_connect_by;
  
  
SELECT d.*, cmp.name as chip_number, cmp.description, cmp.package_type_id, cmp.component_sub_type_id, cmp.pin_count, pt.name as package, cst.description as component_type 
FROM components cmp
JOIN diodes d on d.component_id = cmp.id
JOIN package_types pt on pt.id = cmp.package_type_id
JOIN component_types ct on ct.id = cmp.component_type_id
LEFT JOIN component_sub_types cst on cst.id = cmp.component_sub_type_id
LEFT JOIN list_entries fvu on fvu.id = d.forward_unit_id
LEFT JOIN list_entries rvu on rvu.id = d.reverse_unit_id
LEFT JOIN list_entries lic on lic.id = d.light_color_id
LEFT JOIN list_entries lnc on lnc.id = d.lens_color_id
WHERE d.component_id = 1;

select ct.id, ct.name, ct.description, count(c.id) ni
from component_types ct
left join components c on c.component_type_id = ct.id
group by ct.id, ct.name, ct.description
having count(c.id) = 0
order by name;

select * from component_sub_types
where component_type_id = 6;

select * from components;

SELECT ct.*, 
  (select count(*) ni from component_sub_types where component_type_id = ct.id) num_sub_types,
  (select count(*) ni from components where component_type_id = ct.id) num_components
FROM component_types ct
ORDER BY description;

SELECT pt.*,  ct.name component_type
FROM package_types pt
JOIN component_packages cp on cp.package_type_id = pt.id
JOIN component_types ct on ct.id = cp.component_type_id
WHERE pt.name = 'DIP'
  AND ct.id = 1;

SELECT cst.id, cst.name, cst.description
FROM component_sub_types cst
WHERE cst.component_type_id = 1
  AND cst.name = 'memory';

select *
from specs
where component_id = 244;