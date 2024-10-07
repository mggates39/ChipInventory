var express = require('express');
const { searchInventory, getInventory, getInventoryDates, getChip, searchChips, getMfgCodes, 
  lookupInventory, createInventory, updateInventory, createInventoryDate, updateInventoryDate, lookupInventoryDate } = require('../database');
var router = express.Router();

/* GET Inventory list page. */
router.get('/', async function(req, res, next) {
  const search_query = req.query.q;
  const search_type = req.query.w;
  var part_search = true;
  var key_search = false;
  var search_by = 'p';
  if (search_type == 'k') {
    part_search = false;
    key_search = true;
    search_by = 'k';
  }
  
  const inventory = await searchInventory(search_query, search_by);
  res.render('inventory/list', { title: 'Chip Inventory', inventory: inventory, searched: search_query, part_search: part_search, key_search: key_search  });
});

router.get('/new/:chip_id', async function(req, res, next) {
  const chip_id = req.params.chip_id;
  const manufacturers = await getMfgCodes();
  const chip = await getChip(chip_id);
  res.render('inventory/new', {title: 'Add to Chip Inventory', manufacturers: manufacturers, chips: [chip]});
});

router.get('/new', async function(req, res, next) {
  const manufacturers = await getMfgCodes();
  const chips = await searchChips('', '');
  res.render('inventory/new', {title: 'Add to Chip Inventory', manufacturers: manufacturers, chips: chips});
});

router.post('/new', async function(req, res) {
  const data = req.body;
  var inv_id = 0;
  var new_qty = parseInt(data.quantity);
  var old_qty = 0;
  const inv = await lookupInventory(data.chip_id, data.full_number, data.mfg_code_id);
  if (inv.length) {
    inv_id = inv[0].id;
    old_qty = parseInt(inv[0].quantity)
    await updateInventory(inv_id, inv[0].chip_id, inv[0].full_number, inv[0].mfg_code_id, (old_qty + new_qty))
  } else {
    const new_inv = await createInventory(data.chip_id, data.full_number, data.mfg_code_id, data.quantity);
    inv_id = new_inv.id;
  }
  const inv_date = await lookupInventoryDate(inv_id, data.date_code);
  if (inv_date.length) {
    old_qty = parseInt(inv_date[0].quantity)
    await updateInventoryDate(inv_date[0].id, inv_date[0].inventory_id, inv_date[0].date_code, (old_qty + new_qty))
  } else {
    await createInventoryDate(inv_id, data.date_code, data.quantity) 
  }

  res.redirect('/inventory/'+inv_id);
});

router.get('/:id/newdate', async function(req, res, next) {
  const id = req.params.id;
  const inventory = await getInventory(id);
  res.render('inventory/datenew', { title: inventory.full_number, inventory: inventory });
});

router.post('/:id/newdate', async function(req, res, next) {
  const inv_id = req.params.id;
  const data = req.body;
  var new_qty = parseInt(data.quantity);
  var old_qty = 0;
  const inv = await getInventory(inv_id);
  old_qty = parseInt(inv.quantity)
  await updateInventory(inv_id, inv.chip_id, inv.full_number, inv.mfg_code_id, (old_qty + new_qty))
  const inv_date = await lookupInventoryDate(inv_id, data.date_code);
  if (inv_date.length) {
    old_qty = parseInt(inv_date[0].quantity)
    await updateInventoryDate(inv_date[0].id, inv_date[0].inventory_id, inv_date[0].date_code, (old_qty + new_qty))
  } else {
    await createInventoryDate(inv_id, data.date_code, data.quantity) 
  }

  res.redirect('/inventory/'+inv_id);
});

router.get('/:id', async function(req, res, next) {
  const id = req.params.id;
  const inventory = await getInventory(id);
  const inventory_dates = await getInventoryDates(id);
  res.render('inventory/detail', { title: inventory.full_number, inventory: inventory, inventory_dates: inventory_dates });
});

module.exports = router;
