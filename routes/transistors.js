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
    res.render('transister/new', {title: 'transister', package_type: data, component_types: comps, mounting_types: mounts});
  });
  
/* GET item page */
router.get('/:id', async function(req, res, nest) {
    const id = req.params.id;
    const data = await gettransister(id);
    res.render('transister/detail', {title: 'transister', data: data});
});

/* GET Edit item page */
router.get('/edit/:id', async function(req, res, next) {
    const id = req.params.id;
    const data = await gettransister(id);
    res.render('transister/edit', {title: 'transister', data: data});
  })
  
router.post('/new', async function( req, res, next) {
    const transister = await createtransister(req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_type_selection)
    const id = transister.id
    res.redirect('/transisters/'+id);
  });

router.post('/:id', async function( req, res, next) {
    const id = req.params.id;
    await updatetransister(id, req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_type_selection)
    res.redirect('/transisters/'+id);
  })
  
module.exports = router;
