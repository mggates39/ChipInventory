var express = require('express');
var router = express.Router();
const {getMountingTypeList, getMountingType, getPackageTypesForMountingType, 
  getMountingTypePlain, createMountingType, updateMountingType} = require('../database');

/* GET home page. */
router.get('/', async function(req, res, next) {
  const data = await getMountingTypeList();
  res.render('mounting_type/list', { title: 'Mounting Types', mounting_types: data });
});

// GET new mounting type page
router.get('/new', async function(req, res, next) {
  const data = {name: '',
    is_through_hole: '',
    is_service_mount: '',
    is_chasis_mount: ''
  };
  res.render('mounting_type/new', {title: 'Mounting Type', mounting_type: data});
})

/* GET item page */
router.get('/:id', async function(req, res, next) {
  const id = req.params.id;
  const data = await getMountingType(id);
  const packs = await getPackageTypesForMountingType(id);
  res.render('mounting_type/detail', {title: 'Mounting Type', mounting_type: data, package_types: packs});
});

router.get('/edit/:id', async function(req, res, next) {
  const id = req.params.id;
  const data = await getMountingTypePlain(id);
  res.render('mounting_type/edit', {title: 'Mounting Type', mounting_type: data});
})

router.post('/new', async function( req, res, next) {
  const package_type = await createMountingType(req.body.name, req.body.is_through_hole, req.body.is_surface_mount, req.body.is_chassis_mount);
  const id = package_type.id
  res.redirect('/mounting_types/'+id);
});

router.post('/:id', async function( req, res, next) {
  const id = req.params.id;
  await updateMountingType(id, req.body.name, req.body.is_through_hole, req.body.is_surface_mount, req.body.is_chassis_mount);
  res.redirect('/mounting_types/'+id);
})

module.exports = router;
