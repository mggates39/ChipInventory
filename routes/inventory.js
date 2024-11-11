var express = require('express');
const { searchInventory, getInventory, getInventoryDates, searchComponents, getManufacturerCodes, getComponent, getComponentTypeList,
  lookupInventory, createInventory, updateInventory, createInventoryDate, updateInventoryDate, lookupInventoryDate, 
  getLocationList} = require('../database');
var router = express.Router();

/* GET Inventory list page. */
router.get('/', async function(req, res, next) {
  const search_query = req.query.q;
  const search_type = req.query.w;
  var component_type_id = req.query.component_type_id;
  var part_search = true;
  var key_search = false;
  var search_by = 'p';
  if (search_type == 'k') {
    part_search = false;
    key_search = true;
    search_by = 'k';
  }
  if (typeof component_type_id == 'undefined') {
    component_type_id = 0;
  }
  
  const inventory = await searchInventory(search_query, search_by, component_type_id);
  const component_types = await getComponentTypeList();
  res.render('inventory/list', { title: 'Component Inventory', inventory: inventory, searched: search_query, part_search: part_search, key_search: key_search, 
    component_types: component_types, component_type_id: component_type_id});
});

router.get('/edit/:id', async function(req, res, next) {
  const id = req.params.id;
  const data = await getInventory(id);
  const manufacturers = await getManufacturerCodes();
  const component = await getComponent(data.component_id);
  const locations = await getLocationList();
  res.render('inventory/edit', {title: 'Edit Component Inventory', data: data, manufacturers: manufacturers, components: [component], locations: locations});
});

router.get('/new/:component_id', async function(req, res, next) {
  const component_id = req.params.component_id;
  const manufacturers = await getManufacturerCodes();
  const component = await getComponent(component_id);
  const locations = await getLocationList();
  res.render('inventory/new', {title: 'Add to Component Inventory', manufacturers: manufacturers, components: [component], locations: locations});
});

router.get('/new', async function(req, res, next) {
  const manufacturers = await getManufacturerCodes();
  const components = await searchComponents('', '', 0);
  const locations = await getLocationList();
  res.render('inventory/new', {title: 'Add to Component Inventory', manufacturers: manufacturers, components: components, locations: locations});
});

router.post('/new', async function(req, res) {
  const data = req.body;
  var inv_id = 0;
  var new_qty = parseInt(data.quantity);
  var old_qty = 0;
  var location_id = data.location_id;
  if (location_id == '') {
    location_id = null;
  }

  const inv = await lookupInventory(data.chip_id, data.full_number, data.mfg_code_id);
  if (inv.length) {
    inv_id = inv[0].id;
    old_qty = parseInt(inv[0].quantity)
    await updateInventory(inv_id, inv[0].component_id, inv[0].full_number, inv[0].mfg_code_id, (old_qty + new_qty), location_id)
  } else {
    const new_inv = await createInventory(data.chip_id, data.full_number, data.mfg_code_id, data.quantity, location_id);
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

router.post('/:id', async function(req, res) {
  const id = req.params.id;
  const data = req.body;
  var location_id = data.location_id;
  if (location_id == '') {
    location_id = null;
  }

  await updateInventory(id, data.component_id, data.full_number, data.mfg_code_id, data.quantity, location_id);
  res.redirect('/inventory/'+id);
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
  await updateInventory(inv_id, inv.component_id, inv.full_number, inv.mfg_code_id, (old_qty + new_qty))
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
