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
    res.render('inductor/new', {title: 'inductor', package_type: data, component_types: comps, mounting_types: mounts});
  });
  
/* GET item page */
router.get('/:id', async function(req, res, nest) {
    const id = req.params.id;
    const data = await getinductor(id);
    res.render('inductor/detail', {title: 'inductor', data: data});
});

/* GET Edit item page */
router.get('/edit/:id', async function(req, res, next) {
    const id = req.params.id;
    const data = await getinductor(id);
    res.render('inductor/edit', {title: 'inductor', data: data});
  })
  
router.post('/new', async function( req, res, next) {
    const inductor = await createinductor(req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_type_selection)
    const id = inductor.id
    res.redirect('/inductors/'+id);
  });

router.post('/:id', async function( req, res, next) {
    const id = req.params.id;
    await updateinductor(id, req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_type_selection)
    res.redirect('/inductors/'+id);
  })
  
module.exports = router;
