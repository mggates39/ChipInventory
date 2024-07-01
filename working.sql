use chip_data;
truncate table chips;
truncate table pins;

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