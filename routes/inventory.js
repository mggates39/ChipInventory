var express = require('express');
const { getInventoryList, getInventory, getInventoryDates, searchChips, getMfgCodes, lookupInventory, createInventory, createInventoryDate } = require('../database');
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
  const inv = await lookupInventory(data.chip_id, data.full_chip_number, data.mfg_code_id);
  if (inv.length) {
    inv_id = inv[0].id;
    // update iventory qty with data.qty
  } else {
    const new_inv = await createInventory(data.chip_id, data.full_chip_number, data.mfg_code_id, data.quantity);
    inv_id = new_inv.id;
  }
  await createInventoryDate(inv_id, data.date_code, data.quantity) 

  res.redirect('/inventory/'+inv_id);
})

router.get('/:id', async function(req, res, next) {
  const id = req.params.id;
  const inventory = await getInventory(id);
  const inventory_dates = await getInventoryDates(id);
  res.render('inventorydetail', { title: inventory.full_number, inventory: inventory, inventory_dates: inventory_dates });
});

module.exports = router;
