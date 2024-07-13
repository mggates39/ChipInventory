var express = require('express');
const { getInventoryList, getInventory, getInventoryDates, searchChips, getMfgCodes, 
  lookupInventory, createInventory, updateInventory, createInventoryDate, updateInventoryDate, lookupInventoryDate } = require('../database');
var router = express.Router();

/* GET Inventory list page. */
router.get('/', async function(req, res, next) {
  const inventory = await getInventoryList();
  res.render('inventorylist', { title: 'Chip Inventory', inventory: inventory });
});

router.get('/inventorynew', async function(req, res, next) {
  const manufacturers = await getMfgCodes();
  const chips = await searchChips('', '');
  res.render('inventorynew', {title: 'Add to Chip Inventory', manufacturers, chips});
});

router.post('/inventorynew', async function(req, res) {
  const data = req.body;
  var inv_id = 0;
  var new_qty = parseInt(data.quantity);
  var old_qty = 0;
  const inv = await lookupInventory(data.chip_id, data.full_number, data.mfg_code_id);
  console.log (inv);
  if (inv.length) {
    inv_id = inv[0].id;
    old_qty = parseInt(inv[0].quantity)
    await updateInventory(inv_id, inv[0].chip_id, inv[0].full_number, inv[0].mfg_code_id, (old_qty + new_qty))
  } else {
    const new_inv = await createInventory(data.chip_id, data.full_number, data.mfg_code_id, data.quantity);
    console.log(new_inv);
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
})

router.get('/:id', async function(req, res, next) {
  const id = req.params.id;
  const inventory = await getInventory(id);
  const inventory_dates = await getInventoryDates(id);
  res.render('inventorydetail', { title: inventory.full_number, inventory: inventory, inventory_dates: inventory_dates });
});

module.exports = router;
