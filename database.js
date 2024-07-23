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

async function getChip(id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM chips
  WHERE id = ?
  `, [id])
  return rows[0]
}

async function getPins(id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM pins
  WHERE chip_id = ?
  ORDER BY pin_number
  `, [id])
  return rows
}

async function getPin(id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM pins
  WHERE id = ?
  ORDER BY pin_number
  `, [id])
  return rows[0]
}

async function getLeftPins(id) {
  const [rows] = await pool.query(`
  select chips.chip_number, chips.pin_count, pinleft.pin_number, pinleft.pin_symbol
from chips
join pins pinleft on pinleft.chip_id = chips.id
where chips.id = ?
  and pinleft.pin_number <= (chips.pin_count/2)
order by cast(pin_number as signed);
  `, [id])
  return rows
}

async function getRightPins(id) {
  const [rows] = await pool.query(`
  select chips.chip_number, chips.pin_count, pinright.pin_number, pinright.pin_symbol
from chips
join pins pinright on pinright.chip_id = chips.id
where chips.id = ?
  and pinright.pin_number > (chips.pin_count/2)
order by cast(pin_number as signed) desc;
  `, [id])
  return rows
}

async function getSpecs(id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM specs
  WHERE chip_id = ?
  `, [id])
  return rows
}

async function getNotes(id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM notes
  WHERE chip_id = ?
  `, [id])
  return rows
}

async function getInventoryList() {
  const [rows] = await pool.query(`select inventory.id, chip_id, full_number, quantity, chip_number, description, description, mfg_code, name 
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

async function getInventory(id) {
  const [rows] = await pool.query(`
  SELECT inventory.id, chip_id, full_number, mfg_code_id, quantity, chip_number, description, description, mfg_code, name 
    from inventory
    join chips on chips.id = inventory.chip_id
    join mfg_codes on mfg_codes.id = inventory.mfg_code_id
    join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
  WHERE inventory.id = ?
  `, [id])
  return rows[0]
}

async function createInventory(chip_id, full_chip_number, mfg_code_id, quantity) {
  const [result] = await pool.query(`
    INSERT INTO inventory (chip_id, full_number, mfg_code_id, quantity)
    VALUES (?, ?, ?, ?)
    `, [chip_id, full_chip_number, mfg_code_id, quantity])
  const id = result.insertId;
  return getInventory(id)
}

async function updateInventory(id, chip_id, full_chip_number, mfg_code_id, quantity) {
  const [result] = await pool.query(`
    UPDATE inventory SET
      chip_id = ?, 
      full_number = ?, 
      mfg_code_id = ?, 
      quantity = ?
    WHERE id = ?
    `, [chip_id, full_chip_number, mfg_code_id, quantity, id])
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

async function getInventoryDate(id) {
  const [rows] = await pool.query(`
    SELECT * 
    FROM inventory_dates
    WHERE id = ?
    `, [id])
  return rows
}


async function createInventoryDate(inventory_id, date_code, quantity) {
  const [result] = await pool.query(`
    INSERT INTO inventory_dates (inventory_id, date_code, quantity)
    VALUES (?, ?, ?)
    `, [inventory_id, date_code, quantity])
  const id = result.insertId
  return getInventoryDate(id)
}

async function updateInventoryDate(id, inventory_id, date_code, quantity) {
  const [result] = await pool.query(`
    UPDATE inventory_dates SET
      inventory_id = ?, 
      date_code = ?, 
      quantity = ?
    WHERE id = ?
    `, [inventory_id, date_code, quantity, id]);
  return getInventoryDate(id)
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

async function getManufacturer(id) {
  const [rows] = await pool.query(`
    select *
    from manufacturer
    where id = ?`, [id]);
  return rows[0];
}

async function getMfgCodesForMfg(id) {
  const [rows] = await pool.query(`
    select *
    from mfg_codes
    where manufacturer_id = ?
    order by mfg_code`, [id]);
  return rows;
}

async function getManufacturerList() {
  const [rows] = await pool.query(`select m.id, m.name, 
    (select group_concat( ' ', mfg_code) from mfg_codes mc where mc.manufacturer_id = m.id) mfg_codes
    from manufacturer m
    order by m.name`);
  return rows;
}

async function createChip(chip_number, family, pin_count, package, datasheet, description) {
  const [result] = await pool.query(`
  INSERT INTO chips (chip_number, family, pin_count, package, datasheet, description)
  VALUES (?, ?, ?, ?, ?, ?)
  `, [chip_number, family, pin_count, package, datasheet, description])
  const id = result.insertId
  return getChip(id)
}

async function updateChip(id, chip_number, family, pin_count, package, datasheet, description) {
  const [result] = await pool.query(`
  UPDATE chips SET
    chip_number = ?, 
    family = ?, 
    pin_count = ?, 
    package = ?, 
    datasheet = ?, 
    description = ?
  WHERE id = ?
  `, [chip_number, family, pin_count, package, datasheet, description, id])
  return getChip(id)
}

async function deleteChip(id) {
  await pool.query('DELETE FROM aliases WHERE chip_id = ?', [id]);
  await pool.query('DELETE FROM nodes WHERE chip_id = ?', [id]);
  await pool.query('DELETE FROM specs WHERE chip_id = ?', [id]);
  await pool.query('DELETE FROM pins WHERE chip_id = ?', [id]);
  await pool.query('DELETE FROM chips WHERE id = ?', [id]);
  
}

async function createPin(chip_id, pin_number, pin_symbol, pin_description) {
  const [result] = await pool.query(`
  INSERT INTO pins (chip_id, pin_number, pin_symbol, pin_description)
  VALUES (?, ?, ?, ?)
  `, [chip_id, pin_number, pin_symbol, pin_description])
  const id = result.insertId
  return getPin(id)
}

async function createAlias(chip_id, alias_number) {
  const [result] = await pool.query("INSERT INTO aliases (chip_id, alias_chip_number) VALUES (?, ?)", [chip_id, alias_number])
  const id = result.insertId
  return getAlias(id)
}

async function getAliases(chip_id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM aliases
  WHERE chip_id = ?
  `, [chip_id])
  return rows
}

async function getAlias(id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM specs
  WHERE id = ?
  `, [id])
  return rows[0]
}



module.exports = { getSystemData, searchChips, getChip, createChip, updateChip, deleteChip, getPins, 
  createPin, getLeftPins, getRightPins, getSpecs, getNotes, 
  getInventoryList, getInventory, getInventoryByChipList, lookupInventory, createInventory, updateInventory,
  createInventoryDate, updateInventoryDate, getInventoryDates, getInventoryDate, lookupInventoryDate,
  createAlias, getAliases, getManufacturers, getMfgCodes, getManufacturerList, getMfgCodesForMfg, getManufacturer }

