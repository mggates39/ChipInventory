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
    var inventory_id = req.body.inventory_id;
    const qty_needed = req.body.qty_needed;
    var qty_available = req.body.qty_available;
    var qty_to_order = req.body.qty_to_order;
    if (inventory_id) {
      const inv = await getInventory(inventory_id);
      if (inv.quantity > qty_needed){
        qty_available = qty_needed;
      } else {
        qty_available = inv.quantity;
        qty_to_order = qty_needed - qty_available;
      }
      // TODO: remove it from inventory quantity on hand
    } else {
      inventory_id = null;
      qty_to_order = qty_needed;
    }
  
    await updateProjectItem(id, project_id, req.body.number, req.body.part_number, req.body.component_id, qty_needed, 
        inventory_id, qty_available, qty_to_order);
    res.redirect('/projects/'+project_id);
  })
  
module.exports = router;
