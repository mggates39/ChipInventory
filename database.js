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
  const [rows] = await pool.query(`
    select (SELECT count(*) from chips ) chips,
      (select count(*) from aliases) aliases,
      (select sum(quantity) from inventory) on_hand,
      (select min(date_code) from inventory_dates where date_code REGEXP '^[0-9]+$') min_date,
      (select max(date_code) from inventory_dates where date_code REGEXP '^[0-9]+$') max_date,
      (select count(*) from manufacturer) mfgs,
      (select count(*) from mfg_codes) codes
    `)
  return rows[0]
}

async function searchChips(query, type) {
  if (query) {
    value = ['%' + query + '%']
    if (type == 'p') {
      sql = "SELECT * FROM chip_aliases WHERE chip_number LIKE ? ORDER BY chip_number, description";
    } else if (type == 'k') {
      sql = "SELECT * FROM chip_aliases WHERE description LIKE ? ORDER BY chip_number, description";
    } else {
      sql = "SELECT * FROM chip_aliases order by chip_number, description";
    }
  } else {
    sql = "SELECT * FROM chip_aliases order by chip_number, description";
    value = []
  }
  const [rows] = await pool.query(sql, value);
  return rows
}

async function getChip(chip_id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM chips
  WHERE id = ?
  `, [chip_id])
  return rows[0]
}

async function getPins(chip_id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM pins
  WHERE chip_id = ?
  ORDER BY pin_number
  `, [chip_id])
  return rows
}

async function getPin(chip_id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM pins
  WHERE id = ?
  ORDER BY pin_number
  `, [chip_id])
  return rows[0]
}

async function getLeftPins(chip_id) {
  const [rows] = await pool.query(`
  select chips.chip_number, chips.pin_count, pinleft.pin_number, pinleft.pin_symbol
from chips
join pins pinleft on pinleft.chip_id = chips.id
where chips.id = ?
  and pinleft.pin_number <= (chips.pin_count/2)
order by cast(pin_number as signed);
  `, [chip_id])
  return rows
}

async function getRightPins(chip_id) {
  const [rows] = await pool.query(`
  select chips.chip_number, chips.pin_count, pinright.pin_number, pinright.pin_symbol
from chips
join pins pinright on pinright.chip_id = chips.id
where chips.id = ?
  and pinright.pin_number > (chips.pin_count/2)
order by cast(pin_number as signed) desc;
  `, [chip_id])
  return rows
}

async function getSpecs(chip_id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM specs
  WHERE chip_id = ?
  `, [chip_id])
  return rows
}

async function getNotes(chip_id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM notes
  WHERE chip_id = ?
  `, [chip_id])
  return rows
}

async function searchInventory(query, type) {
  if (query) {
    value = ['%' + query + '%']
    if (type == 'p') {
      sql = `select inventory.id, chip_id, full_number, quantity, chip_number, description, description, mfg_code, name 
      from inventory
      join chips on chips.id = inventory.chip_id
      join mfg_codes on mfg_codes.id = inventory.mfg_code_id
      join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
      where full_number like ? or chip_number like ?
      order by chip_number, full_number`;
      value = ['%' + query + '%', '%' + query + '%'];
    } else if (type == 'k') {
      sql = `select inventory.id, chip_id, full_number, quantity, chip_number, description, description, mfg_code, name 
      from inventory
      join chips on chips.id = inventory.chip_id
      join mfg_codes on mfg_codes.id = inventory.mfg_code_id
      join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
      where description like ?
      order by chip_number, full_number`;
    } else {
      sql = `select inventory.id, chip_id, full_number, quantity, chip_number, description, description, mfg_code, name 
    from inventory
    join chips on chips.id = inventory.chip_id
    join mfg_codes on mfg_codes.id = inventory.mfg_code_id
    join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
    order by chip_number, full_number`;
    }
  } else {
    sql = `select inventory.id, chip_id, full_number, quantity, chip_number, description, description, mfg_code, name 
      from inventory
      join chips on chips.id = inventory.chip_id
      join mfg_codes on mfg_codes.id = inventory.mfg_code_id
      join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
      order by chip_number, full_number`;
    value = []
  }
  const [rows] = await pool.query(sql, value);
  return rows
}

async function getInventoryList() {
  const [rows] = await pool.query(`select inventory.id, chip_id, full_number, quantity, chip_number, description, mfg_code, name 
    from inventory
    join chips on chips.id = inventory.chip_id
    join mfg_codes on mfg_codes.id = inventory.mfg_code_id
    join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
    order by chip_number, full_number`)
  return rows
}

async function getInventoryByChipList(chip_id) {
  const [rows] = await pool.query(`select inventory.id, chip_id, full_number, quantity, chip_number, mfg_code, name   
    from inventory
    join chips on chips.id = inventory.chip_id
    join mfg_codes on mfg_codes.id = inventory.mfg_code_id
    join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
    where inventory.chip_id = ?
    order by full_number`, [chip_id])
  return rows
}

async function lookupInventory(chip_id, full_number, mfg_code_id) {
  const [rows] = await pool.query(`select *   
    from inventory
    where inventory.chip_id = ?
      and full_number = ?
      and mfg_code_id = ?
    order by full_number`, [chip_id, full_number, mfg_code_id]);
  return rows
}

async function getInventory(inventory_id) {
  const [rows] = await pool.query(`
  SELECT inventory.id, chip_id, full_number, mfg_code_id, quantity, chip_number, description, description, mfg_code, name 
    from inventory
    join chips on chips.id = inventory.chip_id
    join mfg_codes on mfg_codes.id = inventory.mfg_code_id
    join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
  WHERE inventory.id = ?
  `, [inventory_id])
  return rows[0]
}

async function createInventory(chip_id, full_chip_number, mfg_code_id, quantity) {
  const [result] = await pool.query(`
    INSERT INTO inventory (chip_id, full_number, mfg_code_id, quantity)
    VALUES (?, ?, ?, ?)
    `, [chip_id, full_chip_number, mfg_code_id, quantity])
  const inventory_id = result.insertId;
  return getInventory(inventory_id)
}

async function updateInventory(inventory_id, chip_id, full_chip_number, mfg_code_id, quantity) {
  const [result] = await pool.query(`
    UPDATE inventory SET
      chip_id = ?, 
      full_number = ?, 
      mfg_code_id = ?, 
      quantity = ?
    WHERE id = ?
    `, [chip_id, full_chip_number, mfg_code_id, quantity, inventory_id])
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
  return rows[0[]];
}

async function getManufacturerList() {
  const [rows] = await pool.query(`select m.id, m.name, 
    (select group_concat( ' ', mfg_code) from mfg_codes mc where mc.manufacturer_id = m.id) mfg_codes
    from manufacturer m
    order by m.name`);
  return rows;
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

async function createChip(chip_number, family, pin_count, package, datasheet, description) {
  const [result] = await pool.query(`
  INSERT INTO chips (chip_number, family, pin_count, package, datasheet, description)
  VALUES (?, ?, ?, ?, ?, ?)
  `, [chip_number, family, pin_count, package, datasheet, description])
  const chip_id = result.insertId
  return getChip(chip_id)
}

async function updateChip(chip_id, chip_number, family, pin_count, package, datasheet, description) {
  const [result] = await pool.query(`
  UPDATE chips SET
    chip_number = ?, 
    family = ?, 
    pin_count = ?, 
    package = ?, 
    datasheet = ?, 
    description = ?
  WHERE id = ?
  `, [chip_number, family, pin_count, package, datasheet, description, chip_id])
  return getChip(chip_id)
}

async function deleteChip(chip_id) {
  await pool.query('DELETE FROM aliases WHERE chip_id = ?', [chip_id]);
  await pool.query('DELETE FROM notes WHERE chip_id = ?', [chip_id]);
  await pool.query('DELETE FROM specs WHERE chip_id = ?', [chip_id]);
  await pool.query('DELETE FROM pins WHERE chip_id = ?', [chip_id]);
  await pool.query('DELETE FROM chips WHERE id = ?', [chip_id]);
  
}

async function createSpec(chip_id, parameter, value, units) {
  const [result] = await pool.query(`
  INSERT INTO specs (chip_id, parameter, value, unit)
  VALUES (?, ?, ?, ?)
  `, [chip_id, parameter, value, units])
  const id = result.insertId
  return getChip(chip_id)
}

async function deleteSpec(spec_id) {
  const [result] = await pool.query("DELETE FROM specs WHERE id = ?", [spec_id])
  return true
}

async function getSpec(spec_id) {
  const [rows] = await pool.query("select * from specs where id = ?", [spec_id]);
  return rows[0];
}

async function updateSpec(spec_id, chip_id, parameter, value, units) {
  const [result] = await pool.query(`
  UPDATE specs SET
    chip_id = ?, 
    parameter = ?, 
    value = ?, 
    unit = ?)
  WHERE id = ?
  `, [chip_id, parameter, value, units, spec_id])
  const id = result.insertId
  return getChip(chip_id)
}

async function createNote(chip_id, note) {
  const [result] = await pool.query(`
  INSERT INTO notes (chip_id, note)
  VALUES (?, ?)
  `, [chip_id, note])
  const id = result.insertId
  return getChip(chip_id)
}

async function deleteNote(note_id) {
  const [result] = await pool.query("DELETE FROM notes WHERE id = ?", [note_id])
  return true
}

async function getNote(note_id) {
  const [rows] = await pool.query("SELECT * FROM notes WHERE id = ?", [note_id]);
  return rows[0];
}

async function updateNote(note_id, chip_id, note) {
  const [result] = await pool.query(`
    UPDATE notes SET 
      chip_id = ?, 
      note = ?
    WHERE id = ?
    `, [chip_id, note, note_id])
    return getNote(note_id)
  
}

async function createPin(chip_id, pin_number, pin_symbol, pin_description) {
  const [result] = await pool.query(`
  INSERT INTO pins (chip_id, pin_number, pin_symbol, pin_description)
  VALUES (?, ?, ?, ?)
  `, [chip_id, pin_number, pin_symbol, pin_description])
  const pin_id = result.insertId
  return getPin(pin_id)
}

async function updatePin(pin_id, chip_id, pin_number, pin_symbol, pin_description) {
  const [result] = await pool.query(`
  UPDATE pins SET
    chip_id = ?, 
    pin_number = ?, 
    pin_symbol = ?, 
    pin_description = ?
  WHERE id = ?
  `, [chip_id, pin_number, pin_symbol, pin_description, pin_id])
  return getPin(pin_id)
}

async function createAlias(chip_id, alias_number) {
  const [result] = await pool.query("INSERT INTO aliases (chip_id, alias_chip_number) VALUES (?, ?)", [chip_id, alias_number])
  const alias_id = result.insertId
  return getAlias(alias_id)
}

async function deleteAliases(chip_id) {
  const [result] = await pool.query("DELETE FROM aliases WHERE chip_id = ?", [chip_id])
  return true
}

async function getAliases(chip_id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM aliases
  WHERE chip_id = ?
  `, [chip_id])
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
  const [rows] = await pool.query(`
    SELECT * 
    FROM component_types
    Order by Description`)
    return rows
  }

module.exports = { getSystemData, searchChips, getChip, createChip, updateChip, deleteChip, getPins, 
  createPin, updatePin, getLeftPins, getRightPins, 
  getSpecs, createSpec, getSpec, updateSpec, deleteSpec,
  getNotes, createNote, getNote, updateNote, deleteNote,
  searchInventory, getInventoryList, getInventory, getInventoryByChipList, lookupInventory, createInventory, updateInventory,
  createInventoryDate, updateInventoryDate, getInventoryDates, getInventoryDate, lookupInventoryDate,
  createAlias, getAliases, deleteAliases, 
  getManufacturers, createManufacturer, getManufacturerList, getManufacturer,
  getMfgCode, getMfgCodes, getMfgCodesForMfg, createManufacturerCode,
  getComponentTypeList}

