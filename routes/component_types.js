var express = require('express');
var router = express.Router();
const { createComponentType, updateComponentType, getComponentTypeList, getComponentType, createCompnentSubType,
  getPackageTypesForComponentType, getSelectedPackageTypesForComponentType, getComponentSubTypesForComponentType} = require('../database');

/* GET home page. */
router.get('/', async function(req, res, next) {
  const data = await getComponentTypeList();
  res.render('component_type/list', { title: 'Component Types', component_types: data });
});

router.get('/new', async function(req, res, next) {
  const data = {description: '',
    symbol: '',
    table_name: ''
  };
  const packs = await getSelectedPackageTypesForComponentType(0);
  res.render('component_type/new', {title: 'Component Type', component_type: data, package_types: packs});
});

/* GET item page */
router.get('/:id', async function(req, res, next) {
  const id = req.params.id;
  const data = await getComponentType(id);
  const packs = await getPackageTypesForComponentType(id);
  const component_sub_types = await getComponentSubTypesForComponentType(id);
  res.render('component_type/detail', {title: 'Component Type', component_type: data, package_types: packs, component_sub_types: component_sub_types});
});

/* GET Edit item page */
router.get('/edit/:id', async function(req, res, next) {
  const id = req.params.id;
  const data = await getComponentType(id);
  const packs = await getSelectedPackageTypesForComponentType(id);
  res.render('component_type/edit', {title: 'Component Type', component_type: data, package_types: packs});
})

router.post('/new', async function( req, res, next) {
  const component_type = await createComponentType(req.body.description, req.body.symbol, req.body.table_name, req.body.package_type_selection)
  const id = component_type.id
  res.redirect('/component_types/'+id);
});

/* POST existing item update */
router.post('/:id', async function( req, res, next) {
  const id = req.params.id;
  await updateComponentType(id, req.body.description, req.body.symbol, req.body.table_name, req.body.package_type_selection)
  res.redirect('/component_types/'+id);
})

router.post('/:id/newsubtype/', async function(req, res, next) {
  const id = req.params.id;
  await createCompnentSubType(id, req.body.name, req.body.description);
  res.redirect('/component_types/'+id);
});

module.exports = router;
