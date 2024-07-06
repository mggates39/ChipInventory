var mysql = require('mysql2');
var dotenv = require('dotenv');

dotenv.config()

const pool = mysql.createPool({
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE
}).promise()

async function searchChips(query, type) {
  if (query) {
    value = ['%' + query + '%']
    if (type == 'p') {
      sql = "SELECT * FROM chips WHERE chip_number LIKE ? ORDER BY chip_number";
    } else if (type == 'k') {
      sql = "SELECT * FROM chips WHERE description LIKE ? ORDER BY chip_number";
    } else {
      sql = "SELECT * FROM chips order by chip_number";
    }
  } else {
    sql = "SELECT * FROM chips order by chip_number";
    value = []
  }
  console.log(sql, value);
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

async function getInventory(id) {
  const [rows] = await pool.query(`
  SELECT inventory.id, chip_id, full_number, quantity, chip_number, description, description, mfg_code, name  
    from inventory
    join chips on chips.id = inventory.chip_id
    join mfg_codes on mfg_codes.id = inventory.mfg_code_id
    join manufacturer on manufacturer.id = mfg_codes.manufacturer_id
  WHERE inventory.id = ?
  `, [id])
  return rows[0]
}

async function getInventoryDates(id) {
  const [rows] = await pool.query(`
  SELECT * 
  FROM inventory_dates
  WHERE inventory_id = ?
  order by date_code
  `, [id])
  return rows
}

async function createNote(title, contents) {
  const [result] = await pool.query(`
  INSERT INTO notes (title, contents)
  VALUES (?, ?)
  `, [title, contents])
  const id = result.insertId
  return getNote(id)
}

module.exports = { searchChips, getChip, getPins, getLeftPins, getRightPins, getSpecs, getNotes, getInventoryList, getInventory, getInventoryDates, getInventoryByChipList }

