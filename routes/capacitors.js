var express = require('express');
var router = express.Router();
const { getPackageTypeList, getPackageType, getMountingTypeList, updatePackageType, createPackageType,
    getComponentTypesForPackageType, getSelectedComponentTypesForPackageType} = require('../database');

/* GET new item page */
router.get('/new', async function(req, res, next) {
    const data = {name: '',
        description: '',
        mounting_type_id: ''
      };
    const comps = await getSelectedComponentTypesForPackageType(0);
    const mounts = await getMountingTypeList();
    res.render('capacitor/new', {title: 'Capacitor', package_type: data, component_types: comps, mounting_types: mounts});
  });
  
/* GET item page */
router.get('/:id', async function(req, res, nest) {
    const id = req.params.id;
    const data = await getCapacitor(id);
    res.render('capacitor/detail', {title: 'Capacitor', capacitor: data});
});

/* GET Edit item page */
router.get('/edit/:id', async function(req, res, next) {
    const id = req.params.id;
    const data = await getCapacitor(id);
    res.render('capacitor/edit', {title: 'Capacitor', capacitor: data});
  })
  
router.post('/new', async function( req, res, next) {
    const capacitor = await createCapcitor(req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_type_selection)
    const id = capacitor.id
    res.redirect('/capacitors/'+id);
  });

router.post('/:id', async function( req, res, next) {
    const id = req.params.id;
    await updateCapacitor(id, req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_type_selection)
    res.redirect('/capacitors/'+id);
  })
  
module.exports = router;
