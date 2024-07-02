use chip_data;
truncate table chips;
truncate table pins;
truncate table notes;
truncate table specs;

runcate table inventory;

INSERT INTO inventory ( chip_id, full_number, quantity)
VALUES
(70, 'LF353N', 5),
(218, 'AM27C128', 2),
(131, 'AM27C512', 2)
;

select inventory.id, chip_id, full_number, quantity, chip_number, description from inventory
join chips on chips.id = inventory.chip_id;

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
where chip_id = 114
order by cast(pin_number as signed);


select * from notes;
select * from specs;
