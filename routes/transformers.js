var express = require('express');
var router = express.Router();
const { getTransformer, getPackageType, getMountingTypeList, updateTransformer, createTransformer,
    getComponentTypesForPackageType, getSelectedComponentTypesForPackageType} = require('../database');

/* GET new item page */
router.get('/new', async function(req, res, next) {
    const data = {name: '',
        description: '',
        mounting_type_id: ''
      };
    const comps = await getSelectedComponentTypesForPackageType(0);
    const mounts = await getMountingTypeList();
    res.render('transformer/new', {title: 'transformer', package_type: data, component_types: comps, mounting_types: mounts});
  });
  
/* GET item page */
router.get('/:id', async function(req, res, nest) {
    const id = req.params.id;
    const data = await getTransformer(id);
    res.render('transformer/detail', {title: 'transformer', transformer: data});
});

/* GET Edit item page */
router.get('/edit/:id', async function(req, res, next) {
    const id = req.params.id;
    const data = await getTransformer(id);
    res.render('transformer/edit', {title: 'transformer', transformer: data});
  })
  
router.post('/new', async function( req, res, next) {
    const transformer = await createTransformer(req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_type_selection)
    const id = transformer.id
    res.redirect('/transformers/'+id);
  });

router.post('/:id', async function( req, res, next) {
    const id = req.params.id;
    await updateTransformer(id, req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_type_selection)
    res.redirect('/transformers/'+id);
  })
  
module.exports = router;
