var express = require('express');
var router = express.Router();
const { getMountingTypeList, getMountingType, getPackageTypesForMountingType} = require('../database');

/* GET home page. */
router.get('/', async function(req, res, next) {
  const data = await getMountingTypeList();
  res.render('mounting_type/list', { title: 'Mounting Types', mounting_types: data });
});

/* GET item page */
router.get('/:id', async function(req, res, nest) {
  const id = req.params.id;
  const data = await getMountingType(id);
  const packs = await getPackageTypesForMountingType(id);
  res.render('mounting_type/detail', {title: 'Mounting Type', mounting_type: data, package_types: packs});
});

module.exports = router;
