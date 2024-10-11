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
    res.render('switch/new', {title: 'switch', package_type: data, component_types: comps, mounting_types: mounts});
  });
  
/* GET item page */
router.get('/:id', async function(req, res, nest) {
    const id = req.params.id;
    const data = await getSwitch(id);
    res.render('switch/detail', {title: 'switch', switch: data});
});

/* GET Edit item page */
router.get('/edit/:id', async function(req, res, next) {
    const id = req.params.id;
    const data = await getSwitch(id);
    res.render('switch/edit', {title: 'switch', switch: data});
  })
  
router.post('/new', async function( req, res, next) {
    const switch_item = await createSwitch(req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_type_selection)
    const id = switch_item.id
    res.redirect('/switches/'+id);
  });

router.post('/:id', async function( req, res, next) {
    const id = req.params.id;
    await updateSwitch(id, req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_type_selection)
    res.redirect('/switches/'+id);
  })
  
module.exports = router;
