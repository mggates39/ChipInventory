var mysql = require('mysql2');
var dotenv = require('dotenv');

dotenv.config()

const pool = mysql.createPool({
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE
}).promise()

async function getSystemData() {
  const [rows] = await pool.query(`select 
      (select count(*) from aliases) aliases,
      (select sum(quantity) from inventory) on_hand,
      (select count(*) from (select distinct component_id from inventory) a) used_components,
      (select min(date_code) from inventory_dates where date_code REGEXP '^[0-9]+$') min_date,
      (select max(date_code) from inventory_dates where date_code REGEXP '^[0-9]+$') max_date,
      (select count(*) from manufacturer) mfgs,
      (select count(*) from mfg_codes) codes
    `)
  return rows[0]
}

async function getComponentCounts() {
  const [rows] = await pool.query(`
    select case when ct.description = 'Switch' then concat(ct.description, 'es') else concat(ct.description, 's') end description, 
      table_name, count(cmp.id) ni
    from component_types ct
    join components cmp on ct.id = cmp.component_type_id
    group by ct.description, table_name
    order by ct.description`);
  return rows;
}

async function getAliasCounts() {
  const [rows] = await pool.query(`
    select concat(ct.description, ' Aliases') description, table_name, count(c.id) ni
    from component_types ct
    join components c on ct.id = c.component_type_id
    join aliases a on a.component_id = c.id
    group by ct.description, table_name
    order by ct.description`);
  return rows;
}

async function getInventoryCounts() {
  const [rows] = await pool.query(`
    select case when ct.description = 'Switch' then concat(ct.description, 'es') else concat(ct.description, 's') end description, table_name, count(c.id) ni, sum(i.quantity) quantity
    from component_types ct
    join components c on ct.id = c.component_type_id
    join inventory i on i.component_id = c.id
    where c.id in (select distinct component_id from inventory)
    group by ct.description, table_name
    order by ct.description`);
  return rows;
}

async function searchChips(query, type, component_type_id) {
  if (query) {
    value = ['%' + query + '%', component_type_id]
    if (component_type_id == 0) {
      if (type == 'p') {
        sql = "SELECT * FROM chip_aliases WHERE chip_number LIKE ? ORDER BY chip_number, description";
      } else if (type == 'k') {
        sql = "SELECT * FROM chip_aliases WHERE description LIKE ? ORDER BY chip_number, description";
      } else {
        sql = "SELECT * FROM chip_aliases ORDER BY chip_number, description";
      }
    } else {
      if (type == 'p') {
        sql = "SELECT * FROM chip_aliases WHERE chip_number LIKE ? AND component_type_id = ? ORDER BY chip_number, description";
      } else if (type == 'k') {
        sql = "SELECT * FROM chip_aliases WHERE description LIKE ? AND component_type_id = ? ORDER BY chip_number, description";
      } else {
        sql = "SELECT * FROM chip_aliases ORDER BY chip_number, description";
      }      
    }
  } else {
    if (component_type_id == 0) {
      sql = "SELECT * FROM chip_aliases ORDER BY chip_number, description";
      value = [];
    } else {
      sql = "SELECT * FROM chip_aliases WHERE component_type_id = ? ORDER BY chip_number, description";
      value = [component_type_id];
    }
  }
  const [rows] = await pool.query(sql, value);
  return rows
}

async function getComponent(component_id) {
  const [rows] = await pool.query(`
  SELECT cmp.*, pt.name as package, ct.description as component, ct.table_name 
  FROM components cmp
  JOIN package_types pt on pt.id = cmp.package_type_id
  JOIN component_types ct on ct.id = cmp.component_type_id
  WHERE cmp.id = ?
  `, [component_id])
  return rows[0]
}

async function getChip(component_id) {
  const [rows] = await pool.query(`
    SELECT c.*, cmp.name as chip_number, cmp.description, cmp.package_type_id, cmp.component_sub_type_id, cmp.pin_count, pt.name as package, cst.description as component_type 
    FROM components cmp
    JOIN chips c on c.component_id = cmp.id
    JOIN package_types pt on pt.id = cmp.package_type_id
    JOIN component_types ct on ct.id = cmp.component_type_id
    LEFT JOIN component_sub_types cst on cst.id = cmp.component_sub_type_id
    WHERE c.component_id = ?
  `, [component_id])
  return rows[0]
}

async function getCrystal(component_id) {
  const [rows] = await pool.query(`
    SELECT c.*, cmp.name as chip_number, cmp.description, cmp.package_type_id, cmp.component_sub_type_id, cmp.pin_count, pt.name as package, cst.description as component_type 
    FROM components cmp
    JOIN crystals c on c.component_id = cmp.id
    JOIN package_types pt on pt.id = cmp.package_type_id
    JOIN component_types ct on ct.id = cmp.component_type_id
    LEFT JOIN component_sub_types cst on cst.id = cmp.component_sub_type_id
    WHERE c.component_id = ?
    `, [component_id])
   return rows[0]
}

async function getPins(component_id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM pins
  WHERE component_id = ?
  ORDER BY pin_number
  `, [component_id])
  return rows
}

async function getPin(component_id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM pins
  WHERE id = ?
  ORDER BY pin_number
  `, [component_id])
  return rows[0]
}

async function getDipLeftPins(component_id) {
  const [rows] = await pool.query(`
  select cmp.name as chip_number, cmp.pin_count, pinleft.pin_number, pinleft.pin_symbol
from components cmp
join pins pinleft on pinleft.component_id = cmp.id
where cmp.id = ?
  and pinleft.pin_number <= (cmp.pin_count/2)
order by cast(pin_number as signed);
  `, [component_id])
  return rows
}

async function getDipRightPins(component_id) {
  const [rows] = await pool.query(`
  select cmp.name as chip_number, cmp.pin_count, pinright.pin_number, pinright.pin_symbol
from components cmp
join pins pinright on pinright.component_id = cmp.id
where cmp.id = ?
  and pinright.pin_number > (cmp.pin_count/2)
order by cast(pin_number as signed) desc;
  `, [component_id])
  return rows
}

async function getPllcLeftPins(component_id) {
  const [rows] = await pool.query(`
  select cmp.name as chip_number, cmp.pin_count, pinleft.pin_number, pinleft.pin_symbol
from components cmp
join pins pinleft on pinleft.component_id = cmp.id
where cmp.id = ?
  and pinleft.pin_number > ((cmp.pin_count/8) + ((cmp.pin_count/4) % 2))
  and pinleft.pin_number <= ((cmp.pin_count/8) + (cmp.pin_count/4) + ((cmp.pin_count/4) % 2))
order by cast(pin_number as signed);
  `, [component_id])
  return rows
}

async function getPllcRightPins(component_id) {
  const [rows] = await pool.query(`
  select cmp.name as chip_number, cmp.pin_count, pinright.pin_number, pinright.pin_symbol
from components cmp
join pins pinright on pinright.component_id = cmp.id
where cmp.id = ?
  and pinright.pin_number > ((cmp.pin_count/8) + (cmp.pin_count/2) + ((cmp.pin_count/4) % 2))
  and pinright.pin_number <= (cmp.pin_count - (cmp.pin_count/8) + ((cmp.pin_count/4) % 2))
order by cast(pin_number as signed) desc;
  `, [component_id])
  return rows
}

async function getPllcTopPins(component_id) {
  const [rowsl] = await pool.query(`
    select cmp.name as chip_number, cmp.pin_count, pintop.pin_number, pintop.pin_symbol
from components cmp
join pins pintop on pintop.component_id = cmp.id
where cmp.id = ?
  and (pintop.pin_number >= 1 and pintop.pin_number <= ((cmp.pin_count/8) + ((cmp.pin_count/4) % 2)))
order by cast(pin_number as signed) desc;
    `, [component_id]);
   
  const [rowsr] = await pool.query(`
    select cmp.name as chip_number, cmp.pin_count, pintop.pin_number, pintop.pin_symbol
from components cmp
join pins pintop on pintop.component_id = cmp.id
where cmp.id = ?
  and pintop.pin_number > (cmp.pin_count - (cmp.pin_count/8) + ((cmp.pin_count/4) % 2))
order by cast(pin_number as signed) desc;
      `, [component_id]);

  const rows = rowsl.concat(rowsr);
  return rows;
}

async function getPllcBottomPins(component_id) {
  const [rows] = await pool.query(`
    select cmp.name as chip_number, cmp.pin_count, binbottom.pin_number, binbottom.pin_symbol
from components cmp
join pins binbottom on binbottom.component_id = cmp.id
where cmp.id = ?
  and binbottom.pin_number > ((cmp.pin_count/8) + (cmp.pin_count/4) + ((cmp.pin_count/4) % 2))
  and binbottom.pin_number <= ((cmp.pin_count/8) + (cmp.pin_count/2) + ((cmp.pin_count/4) % 2))
order by cast(pin_number as signed);
    `, [component_id])
    return rows    
}

async function getQuadLeftPins(component_id) {
  const [rows] = await pool.query(`
  select cmp.name as chip_number, cmp.pin_count, pinleft.pin_number, pinleft.pin_symbol
from components cmp
join pins pinleft on pinleft.component_id = cmp.id
where cmp.id = ?
  and pinleft.pin_number > (cmp.pin_count - (cmp.pin_count/4))
order by cast(pin_number as signed) desc
  `, [component_id]);
  return rows;
}

async function getQuadRightPins(component_id) {
  const [rows] = await pool.query(`
  select cmp.name as chip_number, cmp.pin_count, pinright.pin_number, pinright.pin_symbol
from components cmp
join pins pinright on pinright.component_id = cmp.id
where cmp.id = ?
  and pinright.pin_number > (cmp.pin_count/4)
  and pinright.pin_number <= (cmp.pin_count/2)
order by cast(pin_number as signed)
  `, [component_id]);
  return rows;
}

async function getQuadTopPins(component_id) {
  const [rows] = await pool.query(`
    select cmp.name as chip_number, cmp.pin_count, pintop.pin_number, pintop.pin_symbol
from components cmp
join pins pintop on pintop.component_id = cmp.id
where cmp.id = ?
  and (pintop.pin_number >= 1 and pintop.pin_number <= (cmp.pin_count/4))
order by cast(pin_number as signed)
      `, [component_id]);
  return rows;
}

async function getQuadBottomPins(component_id) {
  const [rows] = await pool.query(`
    select cmp.name as chip_number, cmp.pin_count, binbottom.pin_number, binbottom.pin_symbol
from components cmp
join pins binbottom on binbottom.component_id = cmp.id
where cmp.id = ?
  and binbottom.pin_number > (cmp.pin_count/2)
  and binbottom.pin_number <= (cmp.pin_count - (cmp.pin_count/4))
order by cast(pin_number as signed) desc
    `, [component_id])
    return rows    
}

async function getSpecs(component_id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM specs
  WHERE component_id = ?
  `, [component_id])
  return rows
}

async function getNotes(component_id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM notes
  WHERE component_id = ?
  `, [component_id])
  return rows
}

async function searchInventory(query, type) {
  if (query) {
    value = ['%' + query + '%']
    if (type == 'p') {
      sql = `select inventory.id, cmp.id as component_id, full_number, quantity, cmp.name as chip_number, cmp.description, description, mfg_code, manufacturer.name 
      from inventory 
      join chips on chips.component_id = inventory.component_id
      join components cmp on cmp.id = chips.component_id
      join mfg_codes on mfg_codes.id = inventory.mfg_code_id
      join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
      where full_number like ? or chip_number like ?
      order by chip_number, full_number`;
      value = ['%' + query + '%', '%' + query + '%'];
    } else if (type == 'k') {
      sql = `select inventory.id, cmp.id as component_id, full_number, quantity, cmp.name as chip_number, description, description, mfg_code, manufacturer.name 
      from inventory
      join chips on component_id.id = inventory.component_id
      join components cmp on cmp.id = chips.component_id
      join mfg_codes on mfg_codes.id = inventory.mfg_code_id
      join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
      where description like ?
      order by chip_number, full_number`;
    } else {
      sql = `select inventory.id, cmp.id as component_id, full_number, quantity, cmp.name as chip_number, description, description, mfg_code, manufacturer.name 
    from inventory
    join chips on chips.component_id = inventory.component_id
    join components cmp on cmp.id = chips.component_id
    join mfg_codes on mfg_codes.id = inventory.mfg_code_id
    join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
    order by chip_number, full_number`;
    }
  } else {
    sql = `select inventory.id, cmp.id as component_id, full_number, quantity, cmp.name as chip_number, description, description, mfg_code, manufacturer.name 
      from inventory
      join chips on chips.component_id = inventory.component_id
      join components cmp on cmp.id = chips.component_id
      join mfg_codes on mfg_codes.id = inventory.mfg_code_id
      join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
      order by chip_number, full_number`;
    value = []
  }
  const [rows] = await pool.query(sql, value);
  return rows
}

async function getInventoryList() {
  const [rows] = await pool.query(`select inventory.id, inventory.component_id, full_number, quantity, cmp.name as chip_number, cmp.description, mfg_code, manufacturer.name 
    from inventory
    join components cmp on cmp.id = inventory.component_id
    join mfg_codes on mfg_codes.id = inventory.mfg_code_id
    join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
    order by chip_number, full_number`)
  return rows
}

async function getInventoryByComponentList(component_id) {
  const [rows] = await pool.query(`select inventory.id, component_id, full_number, quantity, cmp.name as chip_number, mfg_code, manufacturer.name   
    from inventory
    join components cmp on cmp.id = inventory.component_id
    join mfg_codes on mfg_codes.id = inventory.mfg_code_id
    join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
    where inventory.component_id = ?
    order by full_number`, [component_id])
  return rows
}

async function lookupInventory(component_id, full_number, mfg_code_id) {
  const [rows] = await pool.query(`select *   
    from inventory
    where inventory.component_id = ?
      and full_number = ?
      and mfg_code_id = ?
    order by full_number`, [component_id, full_number, mfg_code_id]);
  return rows
}

async function getInventory(inventory_id) {
  const [rows] = await pool.query(`
  SELECT inventory.id, component_id, full_number, mfg_code_id, quantity, cmp.name as chip_number, description, description, mfg_code, manufacturer.name 
    from inventory
    join components cmp on cmp.id = inventory.component_id
    join mfg_codes on mfg_codes.id = inventory.mfg_code_id
    join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
  WHERE inventory.id = ?
  `, [inventory_id])
  return rows[0]
}

async function createInventory(component_id, full_chip_number, mfg_code_id, quantity) {
  const [result] = await pool.query(`
    INSERT INTO inventory (component_id, full_number, mfg_code_id, quantity)
    VALUES (?, ?, ?, ?)
    `, [component_id, full_chip_number, mfg_code_id, quantity])
  const inventory_id = result.insertId;
  return getInventory(inventory_id)
}

async function updateInventory(inventory_id, component_id, full_chip_number, mfg_code_id, quantity) {
  const [result] = await pool.query(`
    UPDATE inventory SET
      component_id = ?, 
      full_number = ?, 
      mfg_code_id = ?, 
      quantity = ?
    WHERE id = ?
    `, [component_id, full_chip_number, mfg_code_id, quantity, inventory_id])
  return getInventory(id);  
}

async function getInventoryDates(inventory_id) {
  const [rows] = await pool.query(`
    SELECT * 
    FROM inventory_dates
    WHERE inventory_id = ?
    order by date_code
    `, [inventory_id])
    return rows
}

async function lookupInventoryDate(inventory_id, date_code) {
  const [rows] = await pool.query(`
    SELECT * 
    FROM inventory_dates
    WHERE inventory_id = ?
      AND date_code = ?
    `, [inventory_id, date_code])
    return rows
}

async function getInventoryDate(inventory_date_id) {
  const [rows] = await pool.query(`
    SELECT * 
    FROM inventory_dates
    WHERE id = ?
    `, [inventory_date_id])
  return rows
}


async function createInventoryDate(inventory_id, date_code, quantity) {
  const [result] = await pool.query(`
    INSERT INTO inventory_dates (inventory_id, date_code, quantity)
    VALUES (?, ?, ?)
    `, [inventory_id, date_code, quantity])
  const inventory_date_id = result.insertId
  return getInventoryDate(inventory_date_id)
}

async function updateInventoryDate(inventory_date_id, inventory_id, date_code, quantity) {
  const [result] = await pool.query(`
    UPDATE inventory_dates SET
      inventory_id = ?, 
      date_code = ?, 
      quantity = ?
    WHERE id = ?
    `, [inventory_id, date_code, quantity, inventory_date_id]);
  return getInventoryDate(inventory_date_id)
}


async function getManufacturers() {
  const [rows] = await pool.query(`
    SELECT * 
    FROM manufacturer
    order by name`);
  return rows;
}

async function getMfgCodes() {
  const [rows] = await pool.query(`
    select mfg_codes.id, concat(mfg_code, ' (', name, ')') display_name
    from manufacturer
    join mfg_codes on mfg_codes.manufacturer_id = manufacturer.id
    order by mfg_code, name`);
  return rows;
}

async function getManufacturer(manufacturer_id) {
  const [rows] = await pool.query(`
    select *
    from manufacturer
    where id = ?`, [manufacturer_id]);
  return rows[0];
}

async function getMfgCodesForMfg(manufacturer_id) {
  const [rows] = await pool.query(`
    select *
    from mfg_codes
    where manufacturer_id = ?
    order by mfg_code`, [manufacturer_id]);
  return rows;
}

async function getMfgCode(manufacturer_code_id) {
  const [rows] = await pool.query(`
    select *
    from mfg_codes
    where id = ?`, [manufacturer_code_id]);
  return rows[0];
}

async function getManufacturerList() {
  const [rows] = await pool.query(`select m.id, m.name, 
    (select group_concat( ' ', mfg_code) from mfg_codes mc where mc.manufacturer_id = m.id) mfg_codes
    from manufacturer m
    order by m.name`);
  return rows;
}

async function searchManufacturers(query, type) {
  var sql = `select m.id, m.name, 
    (select group_concat( ' ', mfg_code) from mfg_codes mc where mc.manufacturer_id = m.id) mfg_codes
    from manufacturer m`;
    
  if (query) {
    value = ['%' + query + '%']
    if (type == 'm') {
      sql += " WHERE m.name LIKE ? ";
    } else if (type == 'c') {
      sql = `select * from (select m.id, m.name, 
(select group_concat( ' ', mfg_code) from mfg_codes mc where mc.manufacturer_id = m.id and mfg_code like ?) mfg_codes
from manufacturer m) a
where a.mfg_codes is not null`;
    }
  } else {
    value = []
  }
  sql += ' order by name';
  const [rows] = await pool.query(sql, value);
  return rows
}

async function createManufacturer(manufacture_name) {
  const [result] = await pool.query(`
    INSERT INTO manuracturer (name)
    VALUES (?)
    `, [manufacture_name])
    const manufacturer_id = result.insertId;
    return getManufacturer(manufacturer_id)   
}

async function createManufacturerCode(manufacturer_id, code) {
  const [result] = await pool.query(`
    INSERT INTO mfg_codes (manufacturer_id, mfg_code)
    VALUES (?, ?)
    `, [manufacturer_id, code])
  const manufacturer_code_id = result.insertId;
  return getMfgCode(manufacturer_code_id)   
}

async function createComponent(chip_number, component_type_id, package_type_id, component_sub_type_id, description, pin_count) {
  const [result] = await pool.query(`
    INSERT INTO components (name, component_type_id, package_type_id, component_sub_type_id, description, pin_count)
    VALUES (?, ?, ?, ?, ?, ?)
    `, [chip_number, component_type_id, package_type_id, component_sub_type_id, description, pin_count])
  const component_id = result.insertId
  return component_id;
}

async function updateComponent(component_id, chip_number, component_type_id, package_type_id, component_sub_type_id, description, pin_count) {
  await pool.query(`
    UPDATE components SET
      name = ?, 
      component_type_id = ?, 
      package_type_id = ?, 
      component_sub_type_id = ?,
      description = ?, 
      pin_count = ?
    WHERE id = ?
    `, [chip_number, component_type_id, package_type_id, component_sub_type_id, description, pin_count, component_id])
  return true;
}

async function createChip(chip_number, family, pin_count, package_type_id, component_sub_type_id, datasheet, description) {
  const component_type_id = 1;
  const component_id = await createComponent(chip_number, component_type_id, package_type_id, component_sub_type_id, description, pin_count);
  await pool.query(`
      INSERT INTO chips (component_id, family, datasheet)
      VALUES (?, ?, ?)
      `, [component_id, family, datasheet])
  return getChip(component_id)
}

async function updateChip(component_id, chip_number, family, pin_count, package_type_id, component_sub_type_id, datasheet, description) {
  const component_type_id = 1;
  await updateComponent(component_id, chip_number, component_type_id, package_type_id, component_sub_type_id, description, pin_count);
  await pool.query(`
    UPDATE chips SET
      family = ?, 
      datasheet = ?
    WHERE component_id = ?
    `, [family, datasheet, component_id])
  return getChip(component_id)
}

async function deleteChip(component_id) {
  await pool.query('DELETE FROM aliases WHERE component_id = ?', [component_id]);
  await pool.query('DELETE FROM notes WHERE component_id = ?', [component_id]);
  await pool.query('DELETE FROM specs WHERE component_id = ?', [component_id]);
  await pool.query('DELETE FROM pins WHERE component_id = ?', [component_id]);
  await pool.query('DELETE FROM chips WHERE component_id = ?', [component_id]);
  await pool.query('DELETE FROM components WHERE id = ?', [component_id]);
  return true
}

async function createCrystal(chip_number, frequency, pin_count, package_type_id, component_sub_type_id, datasheet, description) {
  const component_type_id = 10;
  const component_id = await createComponent(chip_number, component_type_id, package_type_id, component_sub_type_id, description, pin_count);
  await pool.query(`
      INSERT INTO crystals (component_id, frequency, datasheet)
      VALUES (?, ?, ?)
      `, [component_id, frequency, datasheet])
  return getCrystal(component_id)
}

async function updateCrystal(component_id, chip_number, frequency, pin_count, package_type_id, component_sub_type_id, datasheet, description) {
  const component_type_id = 10;
  await updateComponent(component_id, chip_number, component_type_id, package_type_id, component_sub_type_id, description, pin_count);
  await pool.query(`
    UPDATE crystals SET
      frequency = ?, 
      datasheet = ?
    WHERE component_id = ?
    `, [frequency, datasheet, component_id])
  return getCrystal(component_id)
}

async function deleteCrystal(component_id) {
  await pool.query('DELETE FROM aliases WHERE component_id = ?', [component_id]);
  await pool.query('DELETE FROM notes WHERE component_id = ?', [component_id]);
  await pool.query('DELETE FROM specs WHERE component_id = ?', [component_id]);
  await pool.query('DELETE FROM pins WHERE component_id = ?', [component_id]);
  await pool.query('DELETE FROM crystals WHERE component_id = ?', [component_id]);
  await pool.query('DELETE FROM components WHERE id = ?', [component_id]);
  return true
}

async function createSpec(component_id, parameter, value, units) {
  const [result] = await pool.query(`
  INSERT INTO specs (component_id, parameter, value, unit)
  VALUES (?, ?, ?, ?)
  `, [component_id, parameter, value, units])
  const id = result.insertId
  return getChip(component_id)
}

async function deleteSpec(spec_id) {
  const [result] = await pool.query("DELETE FROM specs WHERE id = ?", [spec_id])
  return true
}

async function getSpec(spec_id) {
  const [rows] = await pool.query("select * from specs where id = ?", [spec_id]);
  return rows[0];
}

async function updateSpec(spec_id, component_id, parameter, value, units) {
  const [result] = await pool.query(`
  UPDATE specs SET
    component_id = ?, 
    parameter = ?, 
    value = ?, 
    unit = ?)
  WHERE id = ?
  `, [component_id, parameter, value, units, spec_id])
  const id = result.insertId
  return getChip(component_id)
}

async function createNote(component_id, note) {
  const [result] = await pool.query(`
  INSERT INTO notes (component_id, note)
  VALUES (?, ?)
  `, [component_id, note])
  const id = result.insertId
  return getChip(component_id)
}

async function deleteNote(note_id) {
  const [result] = await pool.query("DELETE FROM notes WHERE id = ?", [note_id])
  return true
}

async function getNote(note_id) {
  const [rows] = await pool.query("SELECT * FROM notes WHERE id = ?", [note_id]);
  return rows[0];
}

async function updateNote(note_id, component_id, note) {
  const [result] = await pool.query(`
    UPDATE notes SET 
      component_id = ?, 
      note = ?
    WHERE id = ?
    `, [component_id, note, note_id])
    return getNote(note_id)
  
}

async function createPin(component_id, pin_number, pin_symbol, pin_description) {
  const [result] = await pool.query(`
  INSERT INTO pins (component_id, pin_number, pin_symbol, pin_description)
  VALUES (?, ?, ?, ?)
  `, [component_id, pin_number, pin_symbol, pin_description])
  const pin_id = result.insertId
  return getPin(pin_id)
}

async function updatePin(pin_id, component_id, pin_number, pin_symbol, pin_description) {
  const [result] = await pool.query(`
  UPDATE pins SET
    component_id = ?, 
    pin_number = ?, 
    pin_symbol = ?, 
    pin_description = ?
  WHERE id = ?
  `, [component_id, pin_number, pin_symbol, pin_description, pin_id])
  return getPin(pin_id)
}

async function createAlias(component_id, alias_number) {
  const [result] = await pool.query("INSERT INTO aliases (component_id, alias_chip_number) VALUES (?, ?)", [component_id, alias_number])
  const alias_id = result.insertId
  return getAlias(alias_id)
}

async function deleteAliases(component_id) {
  const [result] = await pool.query("DELETE FROM aliases WHERE component_id = ?", [component_id])
  return true
}

async function getAliases(component_id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM aliases
  WHERE component_id = ?
  `, [component_id])
  return rows
}

async function getAlias(alias_id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM aliases
  WHERE id = ?
  `, [alias_id])
  return rows[0]
}

async function getComponentTypeList() {
  const [rows] = await pool.query(`SELECT ct.* , (select count(*) ni from component_sub_types where component_type_id = ct.id) num
FROM component_types ct
ORDER BY description`);
  return rows
}

async function getComponentType(component_type_id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM component_types
  WHERE id = ?
  `, [component_type_id])
  return rows[0]
}

async function getComponentSubTypesForComponentType(component_type_id) {
  const [rows] = await pool.query(`
    SELECT * 
    FROM component_sub_types
    WHERE component_type_id = ?
    ORDER BY name
    `, [component_type_id])
    return rows;
}

async function setComponentPackageTypes( component_type_id, package_types) {
  const insertSql = 'INSERT INTO component_packages (component_type_id, package_type_id) VALUES (?, ?)';

  await pool.query('DELETE FROM component_packages WHERE component_type_id = ?', [component_type_id]);
  if (typeof(package_types) == 'object') {
    for (const package_type_id of package_types) {
      await pool.query(insertSql, [component_type_id, package_type_id]);
    }; 
  } else if (typeof(package_types) == 'string') {
      package_type_id = package_types;
      await pool.query(insertSql, [component_type_id, package_type_id]);
  }
}

async function createComponentType(name, description, symbol, table_name, package_types) {
  const [result] = await pool.query(`
    INSERT INTO component_types (description, symbol, table_name)
    VALUES (?, ?, ?, ?)
    `, [name, description, symbol, table_name])
    const component_type_id = result.insertId

    await setComponentPackageTypes(component_type_id, package_types);

    return getComponentType(component_type_id)    
}

async function updateComponentType(component_type_id, name, description, symbol, table_name, package_types) {
  const [result] = await pool.query(`
    UPDATE component_types SET
      name = ?,
      description = ?, 
      symbol = ?, 
      table_name = ?
    WHERE id = ?
    `, [name, description, symbol, table_name, component_type_id]);

    await setComponentPackageTypes(component_type_id, package_types);

    return getComponentType(component_type_id)
}

async function getComponentSubType(component_sub_type_id) {
  const [rows] = await pool.query(`
    SELECT * 
    FROM component_sub_types
    WHERE id = ?
    `, [component_sub_type_id])
    return rows[0];
}

async function createCompnentSubType(component_type_id, name, description) {
  const [result] = await pool.query("INSERT INTO component_sub_types (component_type_id, name, description) VALUES (?, ?, ?)", 
    [component_type_id, name, description])
  const component_sub_type_id = result.insertId
  return getComponentSubType(component_sub_type_id)
}

async function updateComponentSubType(component_sub_type_id, component_type_id, name, description) {
  const [result] = await pool.query("UPDATE component_sub_types set component_type_id = ?, name = ?, description = ? WHERE id =?", 
    [component_type_id, name, description, component_sub_type_id])
  return getComponentSubType(component_sub_type_id)
}

async function deleteComponentSubType(companent_sub_type_id) {
  const [result] = await pool.query("DELETE FROM component_sub_types WHERE id = ?", [companent_sub_type_id])
  return true
}

async function getMountingTypeList() {
  const [rows] = await pool.query(`SELECT id, name,
    CASE WHEN is_through_hole = 1 THEN 'Yes' ELSE 'No' END is_through_hole,
    CASE WHEN is_surface_mount = 1 THEN 'Yes' ELSE 'No' END is_surface_mount, 
    CASE WHEN is_chassis_mount = 1 THEN 'Yes' ELSE 'No' END is_chassis_mount 
    FROM mounting_types ORDER BY name`);
  return rows
}

async function getMountingType(mounting_type_id) {
  const [rows] = await pool.query(`
  SELECT id, name,
    CASE WHEN is_through_hole = 1 THEN 'Yes' ELSE 'No' END is_through_hole,
    CASE WHEN is_surface_mount = 1 THEN 'Yes' ELSE 'No' END is_surface_mount, 
    CASE WHEN is_chassis_mount = 1 THEN 'Yes' ELSE 'No' END is_chassis_mount  
  FROM mounting_types
  WHERE id = ?
  `, [mounting_type_id])
  return rows[0]
}

async function getMountingTypePlain(mounting_type_id) {
  const [rows] = await pool.query(`
  SELECT *
  FROM mounting_types
  WHERE id = ?
  `, [mounting_type_id])
  return rows[0]
}

async function updateMountingType(mounting_type_id, name, is_through_hole, is_surface_mount, is_chassis_mount) {
  const [result] = await pool.query(`
    UPDATE mounting_types SET
      name = ?, 
      is_through_hole = ?, 
      is_surface_mount = ?, 
      is_chassis_mount = ?
    WHERE id = ?
    `, [name, is_through_hole, is_surface_mount, is_chassis_mount, mounting_type_id])
    return getMountingType(mounting_type_id)
}

async function createMountingType(name, is_through_hole, is_surface_mount, is_chassis_mount) {
  const [result] = await pool.query(`
  INSERT INTO mounting_types (name, is_through_hole, is_surface_mount, is_chassis_mount))
  VALUES (?, ?, ?, ?)
  `, [name, is_through_hole, is_surface_mount, is_chassis_mount])
  const mounting_type_id = result.insertId
  return getMountingType(mounting_type_id)
}

async function getMountingTypes() {
  const [rows] = await pool.query("SELECT id, name FROM mounting_types ORDER BY name");
  return rows
}

async function getPackageTypeList() {
  const [rows] = await pool.query(`SELECT p.id, p.name, p.description, m.name mounting_type 
    FROM package_types p
    JOIN mounting_types m on m.id = p.mounting_type_id
    ORDER BY p.name, m.name`);
  return rows
}

async function getPackageType(package_type_id) {
  const [rows] = await pool.query(`SELECT p.*, m.name mounting_type  
    FROM package_types p
    JOIN mounting_types m on m.id = p.mounting_type_id
    WHERE p.id = ?
  `, [package_type_id])
  return rows[0]
}

async function setPackageComponentTypes( package_type_id, component_types) {
  const insertSql = 'INSERT INTO component_packages (component_type_id, package_type_id) VALUES (?, ?)';

  await pool.query('DELETE FROM component_packages WHERE package_type_id = ?', [package_type_id]);
  if (typeof(component_types) == 'object') {
    for (const component_type_id of component_types) {
      await pool.query(insertSql, [component_type_id, package_type_id]);
    }; 
  } else if (typeof(component_types) == 'string') {
      component_type_id = component_types;
      await pool.query(insertSql, [component_type_id, package_type_id]);
  };
}

async function createPackageType(name, description, mounting_type_id, component_types) {
  const [result] = await pool.query(`
  INSERT INTO package_types (name, description, mounting_type_id)
  VALUES (?, ?, ?)
  `, [name, description, mounting_type_id]);
  const package_type_id = result.insertId;
  await setPackageComponentTypes(package_type_id, component_types);
  return getPackageType(package_type_id);
}

async function updatePackageType(package_type_id, name, description, mounting_type_id, component_types) {
  const [result] = await pool.query(`
     UPDATE package_types SET
      name = ?, 
      description = ?, 
      mounting_type_id = ?
    WHERE id = ?
  `, [name, description, mounting_type_id, package_type_id]);
  await setPackageComponentTypes(package_type_id, component_types);
  return getPackageType(package_type_id);
}

async function getComponentTypesForPackageType(package_type_id) {
  const [rows] = await pool.query(`SELECT ct.*  
    FROM component_packages cp
    JOIN component_types ct on ct.id = cp.component_type_id
    WHERE cp.package_type_id = ?
    ORDER BY ct.description
  `, [package_type_id])
  return rows
}

async function getPackageTypesForComponentType(component_type_id) {
  const [rows] = await pool.query(`SELECT pt.*, mt.name mounting_type  
    FROM component_packages cp
    JOIN package_types pt on pt.id = cp.package_type_id
    JOIN mounting_types mt on mt.id = pt.mounting_type_id
    WHERE cp.component_type_id = ?
    ORDER BY pt.description
  `, [component_type_id])
  return rows
}

async function getSelectedPackageTypesForComponentType(component_type_id) {
  const [rows] = await pool.query(`SELECT pt.*, 
      CASE WHEN cpt.component_type_id IS NOT NULL THEN 'true' ELSE 'false' END used  
    FROM package_types pt
    LEFT JOIN component_packages cpt on cpt.package_type_id = pt.id and cpt.component_type_id = ?
    ORDER BY pt.description
  `, [component_type_id])
  return rows
}

async function getSelectedComponentTypesForPackageType(package_type_id) {
  const [rows] = await pool.query(`SELECT ct.*, 
      CASE WHEN cpt.package_type_id IS NOT NULL THEN 'true' ELSE 'false' END used  
    FROM component_types ct
    LEFT JOIN component_packages cpt on cpt.component_type_id = ct.id and cpt.package_type_id = ?
    ORDER BY ct.description
  `, [package_type_id])
  return rows
}

async function getPackageTypesForMountingType(mounting_type_id) {
  const [rows] = await pool.query(`SELECT *  
    FROM package_types
    WHERE mounting_type_id = ?
    ORDER BY name
  `, [mounting_type_id])
  return rows
}

module.exports = { getSystemData, getAliasCounts, getComponentCounts, getInventoryCounts, getComponent, 
  searchChips, getChip, createChip, updateChip, deleteChip, getPins, 
  createPin, updatePin, getDipLeftPins, getDipRightPins, 
  getPllcLeftPins, getPllcRightPins, getPllcTopPins, getPllcBottomPins,
  getQuadLeftPins, getQuadRightPins, getQuadTopPins, getQuadBottomPins,
  getSpecs, createSpec, getSpec, updateSpec, deleteSpec,
  getNotes, createNote, getNote, updateNote, deleteNote,
  getCrystal, createCrystal, updateCrystal, deleteCrystal,
  searchInventory, getInventoryList, getInventory, getInventoryByComponentList, lookupInventory, createInventory, updateInventory,
  createInventoryDate, updateInventoryDate, getInventoryDates, getInventoryDate, lookupInventoryDate,
  createAlias, getAliases, deleteAliases, 
  getManufacturers, createManufacturer, getManufacturerList, getManufacturer, searchManufacturers,
  getMfgCode, getMfgCodes, getMfgCodesForMfg, createManufacturerCode,
  getComponentTypeList, getComponentType, createComponentType, updateComponentType, 
  getComponentSubTypesForComponentType, createCompnentSubType, getComponentSubType, updateComponentSubType, deleteComponentSubType,
  getMountingTypeList, getMountingType, getMountingTypePlain, getMountingTypes, getPackageTypesForMountingType, 
  updateMountingType, createMountingType,
  getPackageTypeList, getPackageType, updatePackageType, createPackageType, 
  getPackageTypesForComponentType, getSelectedPackageTypesForComponentType,
  getComponentTypesForPackageType, getSelectedComponentTypesForPackageType}

