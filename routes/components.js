var express = require('express');
var router = express.Router();
const { createComponentType, updateComponentType, getComponentTypeList, getComponentType, 
  getPackageTypesForComponentType, getSelectedPackageTypesForComponentType} = require('../database');

/* GET home page. */
router.get('/', async function(req, res, next) {
  const data = await getComponentTypeList();
  res.render('component_type/list', { title: 'Component Types', component_types: data });
});

router.get('/new', async function(req, res, next) {
  res.redirect('/component_types/');
});

/* GET item page */
router.get('/:id', async function(req, res, next) {
  const id = req.params.id;
  const data = await getComponentType(id);
  const packs = await getPackageTypesForComponentType(id);
  res.render('component_type/detail', {title: 'Component Type', component_type: data, package_types: packs});
});

/* GET Edit item page */
router.get('/edit/:id', async function(req, res, next) {
  const id = req.params.id;
  const data = await getComponentType(id);
  const packs = await getSelectedPackageTypesForComponentType(id);
  res.render('component_type/edit', {title: 'Component Type', component_type: data, package_types: packs});
})

/* POST existing item update */
router.post('/:id', async function( req, res, next) {
  const id = req.params.id;
  await updateComponentType(id, req.body.description, req.body.symbol, req.body.table_name, req.body.package_type_selection)
  res.redirect('/component_types/'+id);
})

module.exports = router;
