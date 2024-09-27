var express = require('express');
var router = express.Router();
const { getComponentTypeList, getComponentType, getPackageTypesForComponentType} = require('../database');

/* GET home page. */
router.get('/', async function(req, res, next) {
  const data = await getComponentTypeList();
  res.render('component_type/list', { title: 'Component Types', component_types: data });
});

/* GET item page */
router.get('/:id', async function(req, res, nest) {
  const id = req.params.id;
  const data = await getComponentType(id);
  const packs = await getPackageTypesForComponentType(id);
  res.render('component_type/detail', {title: 'Component Type', component_type: data, package_types: packs});
});

module.exports = router;
