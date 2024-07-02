var express = require('express');
const { getInventoryList } = require('../database');
var router = express.Router();

/* GET Inventory list page. */
router.get('/', async function(req, res, next) {
    const inventory = await getInventoryList();
  res.render('inventorylist', { title: 'Inventory', inventory: inventory });
});

module.exports = router;
