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
    res.render('connector/new', {title: 'Connector', package_type: data, component_types: comps, mounting_types: mounts});
  });
  
/* GET item page */
router.get('/:id', async function(req, res, nest) {
    const id = req.params.id;
    const data = await getConnector(id);
    res.render('connector/detail', {title: 'Connector', connector: data});
});

/* GET Edit item page */
router.get('/edit/:id', async function(req, res, next) {
    const id = req.params.id;
    const data = await getConnector(id);
    res.render('connector/edit', {title: 'Connector', connector: data});
  })
  
router.post('/new', async function( req, res, next) {
    const connector = await createConnector(req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_type_selection)
    const id = connector.id
    res.redirect('/connectors/'+id);
  });

router.post('/:id', async function( req, res, next) {
    const id = req.params.id;
    await updateConnector(id, req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_type_selection)
    res.redirect('/connectors/'+id);
  })
  
module.exports = router;
