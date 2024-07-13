use chip_data;

-- truncate table pins;
-- truncate table notes;
-- truncate table specs;
-- truncate table aliases;
-- truncate table chips;
-- truncate table inventory_dates;
-- truncate table inventory;


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
where id = 4;
select * from inventory_dates
where inventory_id = 5;

-- update inventory_dates set date_code = '8621'
-- where id = 31;
-- update inventory set mfg_code_id = 232
-- where id = 4;

select count(*) ni from chips;

select * from aliases;
-- update aliases set alias_chip_number = 'SN74H87'
-- where id =77;

select * from chips where chip_number = '7478';
-- update chips set chip_number='7487' where id =251;



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
where chip_id = 250
order by cast(pin_number as signed);

-- delete from pins where chip_id in (249, 250);
-- delete from chips where id in (249, 250);


select * from notes;
select * from specs;

-- https://semiconductors.es/semiconductors.php?id=500445

select * from chips;
select * from aliases;

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



select * from chip_aliases
order by 2,3;

select * from manufacturer;
-- insert into manufacturer (name) values ('Signetics Corporation (NPX)');
-- 138
select * from mfg_codes
where manufacturer_id = 75;

-- insert into mfg_codes (manufacturer_id, mfg_code) values ( 138, 'S');
-- commit;


select c.chip_number, c.description, sum(i.quantity) on_hand
from chips c
join inventory i on i.chip_id = c.id
group by c.chip_number, c.description
order by c.chip_number;