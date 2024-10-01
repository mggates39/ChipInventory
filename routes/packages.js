var express = require('express');
var router = express.Router();
const { getPackageTypeList, getPackageType, getMountingTypeList, updatePackageType, 
    getComponentTypesForPackageType, getSelectedComponentTypesForPackageType} = require('../database');

/* GET list page. */
router.get('/', async function(req, res, next) {
    const data = await getPackageTypeList();
    res.render('package_type/list', { title: 'Package Types', package_types: data });
});

/* GET item page */
router.get('/:id', async function(req, res, nest) {
    const id = req.params.id;
    const data = await getPackageType(id);
    const comps = await getComponentTypesForPackageType(id);
    res.render('package_type/detail', {title: 'Package Type', package_type: data, component_types: comps});
});

/* GET Edit item page */
router.get('/edit/:id', async function(req, res, next) {
    const id = req.params.id;
    const data = await getPackageType(id);
    const comps = await getSelectedComponentTypesForPackageType(id);
    const mounts = await getMountingTypeList();
    res.render('package_type/edit', {title: 'Package Type', package_type: data, component_types: comps, mounting_types: mounts});
  })
  
  router.post('/:id', async function( req, res, next) {
    const id = req.params.id;
    await updatePackageType(id, req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_types)
    res.redirect('/package_types/'+id);
  })
  
  module.exports = router;
