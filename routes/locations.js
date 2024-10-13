var express = require('express');
var router = express.Router();
const {getLocationList, getLocation, createLocation, updateLocation, getLocationTypeList, getChildLocationList, getInventoryByLocationList} = require('../database');

/* GET home page. */
router.get('/', async function(req, res, next) {
  const data = await getLocationList();
  res.render('location/list', { title: 'Locations', locations: data });
});

// GET new location type page
router.get('/new', async function(req, res, next) {
  const data = {name: '',
    description: '',
    location_type_id: '',
    parent_location_id: ''
  };
  const location_types = await getLocationTypeList();
  const parent_locations = await getLocationList();
  res.render('location/new', {title: 'Location', location: data, location_types: location_types, parent_locations: parent_locations});
})

/* GET item page */
router.get('/:id', async function(req, res, next) {
  const id = req.params.id;
  const data = await getLocation(id);
  const child_locations = await getChildLocationList(id);
  const inventories = await getInventoryByLocationList(id);
  res.render('location/detail', {title: 'Location', location: data, child_locations: child_locations, inventories: inventories});
});

router.get('/edit/:id', async function(req, res, next) {
  const id = req.params.id;
  const data = await getLocation(id);
  const location_types = await getLocationTypeList();
  const parent_locations = await getLocationList();
  res.render('location/edit', {title: 'Location', location: data, location_types: location_types, parent_locations: parent_locations});
})

router.post('/new', async function( req, res, next) {
  const location = await createLocation(req.body.parent_location_id, req.body.location_type_id, req.body.name, req.body.description);
  const id = location.id
  res.redirect('/locations/'+id);
});

router.post('/:id', async function( req, res, next) {
  const id = req.params.id;
  await updateLocation(id, req.body.parent_location_id, req.body.location_type_id, req.body.name, req.body.description);
  res.redirect('/locations/'+id);
})

module.exports = router;
