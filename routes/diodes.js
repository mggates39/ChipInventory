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
    res.render('diode/new', {title: 'diode', package_type: data, component_types: comps, mounting_types: mounts});
  });
  
/* GET item page */
router.get('/:id', async function(req, res, nest) {
    const id = req.params.id;
    const data = await getdiode(id);
    res.render('diode/detail', {title: 'diode', diode: data});
});

/* GET Edit item page */
router.get('/edit/:id', async function(req, res, next) {
    const id = req.params.id;
    const data = await getdiode(id);
    res.render('diode/edit', {title: 'diode', diode: data});
  })
  
router.post('/new', async function( req, res, next) {
    const diode = await creatediode(req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_type_selection)
    const id = diode.id
    res.redirect('/diodes/'+id);
  });

router.post('/:id', async function( req, res, next) {
    const id = req.params.id;
    await updatediode(id, req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_type_selection)
    res.redirect('/diodes/'+id);
  })
  
module.exports = router;
