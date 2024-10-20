var express = require('express');
var router = express.Router();
const { getProjectItem, updateProjectItem, deleteProjectItem} = require('../database');

// Delete project item data
router.get('/delete/:id', async function(req, res) {
    const project_item_id = req.params.id;
    const data = await getProjectItem(project_item_id);
    const project_id = data.project_id;
    await deleteProjectItem(project_item_id)
    res.redirect('/projects/'+project_id);
  })
  
// GET project item data
router.get('/:id', async function(req, res, next) {
    const id = req.params.id;
    const data = await getProjectItem(id);
    res.send(data);
  });

/* POST existing project item update */
router.post('/:id', async function( req, res, next) {
    const id = req.params.id;
    const project_id = req.body.project_id;
    await updateProjectItem(id, project_id, req.body.number, req.body.component_id, req.body.qty_needed, 
        req.body.inventory_id, req.body.qty_available, req.body.qty_to_order);
    res.redirect('/projects/'+project_id);
  })
  
module.exports = router;
