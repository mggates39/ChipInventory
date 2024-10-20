var express = require('express');
var router = express.Router();
const { getListEntry, updateListEntry, deleteListEntry} = require('../database');

// Delete list entry data
router.get('/delete/:id', async function(req, res) {
    const list_entry_id = req.params.id;
    const data = await getListEntry(list_entry_id);
    const list_id = data.list_id;
    await deleteListEntry(list_entry_id)
    res.redirect('/lists/'+list_id);
  })
  
// GET list entry data
router.get('/:id', async function(req, res, next) {
    const id = req.params.id;
    const data = await getListEntry(id);
    res.send(data);
  });

/* POST existing list entry update */
router.post('/:id', async function( req, res, next) {
    const id = req.params.id;
    const list_id = req.body.list_id;
    await updateListEntry(id, list_id, req.body.sequence, req.body.name, req.body.description, req.body.modifier_value)
    res.redirect('/lists/'+list_id);
  })
  
module.exports = router;
