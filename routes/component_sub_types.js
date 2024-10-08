var express = require('express');
var router = express.Router();
const { getComponentSubType, updateComponentSubType, deleteComponentSubType} = require('../database');

// Delete sub type data
router.get('/deletesubtype/:id', async function(req, res) {
    const component_sub_type_id = req.params.id;
    const data = await getComponentSubType(component_sub_type_id);
    const component_type_id = data.component_type_id;
    await deleteComponentSubType(component_sub_type_id)
    res.redirect('/component_types/'+component_type_id);
  })
  
// GET sub type data
router.get('/:id', async function(req, res, next) {
    const id = req.params.id;
    const data = await getComponentSubType(id);
    res.send(data);
  });

/* POST existing sub type update */
router.post('/:id', async function( req, res, next) {
    const id = req.params.id;
    const component_type_id = req.body.component_type_id;
    await updateComponentSubType(id, component_type_id, req.body.name, req.body.description)
    res.redirect('/component_types/'+component_type_id);
  })
  
module.exports = router;
