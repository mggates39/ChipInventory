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
    res.render('fuse/new', {title: 'fuse', package_type: data, component_types: comps, mounting_types: mounts});
  });
  
/* GET item page */
router.get('/:id', async function(req, res, nest) {
    const id = req.params.id;
    const data = await getfuse(id);
    res.render('fuse/detail', {title: 'fuse', fuse: data});
});

/* GET Edit item page */
router.get('/edit/:id', async function(req, res, next) {
    const id = req.params.id;
    const data = await getfuse(id);
    res.render('fuse/edit', {title: 'fuse', fuse: data});
  })
  
router.post('/new', async function( req, res, next) {
    const fuse = await createfuse(req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_type_selection)
    const id = fuse.id
    res.redirect('/fuses/'+id);
  });

router.post('/:id', async function( req, res, next) {
    const id = req.params.id;
    await updatefuse(id, req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_type_selection)
    res.redirect('/fuses/'+id);
  })
  
module.exports = router;
