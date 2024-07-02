var express = require('express');
const { getInventoryList, getInventory, getInventoryDates } = require('../database');
var router = express.Router();

/* GET Inventory list page. */
router.get('/', async function(req, res, next) {
  const inventory = await getInventoryList();
  res.render('inventorylist', { title: 'Inventory', inventory: inventory });
});

router.get('/:id', async function(req, res, next) {
  const id = req.params.id;
  const inventory = await getInventory(id);
  const inventory_dates = await getInventoryDates(id);
  console.log( inventory);
  res.render('inventorydetail', { title: inventory.full_number, inventory: inventory, inventory_dates: inventory_dates });
})

module.exports = router;
