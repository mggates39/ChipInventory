var express = require('express');
var router = express.Router();
const {getLists, getList, createList, updateList, deleteList, createListEntry, getListEntriesForList} = require('../database');

// GET home page
router.get('/', async function(req, res, next) {
    const data = await getLists();
    res.render('list/list', { title: 'Pick Lists', lists: data });
  });
  
// Delete list data
router.get('/delete/:id', async function(req, res) {
    const list_id = req.params.id;
    await deleteList(list_id)
    res.redirect('/lists/');
  })
  
 
// Start a new List
  router.get('/new', async function(req, res, next) {
    const data = {
      name: '',
      description: ''
    };
    res.render('list/new', {title: 'List', list: data});
  });
  
  /* GET item page */
  router.get('/:id', async function(req, res, next) {
    const id = req.params.id;
    const data = await getList(id);
    const list_entries = await getListEntriesForList(id);
    res.render('list/detail', {title: 'List', list: data, list_entries: list_entries});
  });
  
  /* GET Edit item page */
  router.get('/edit/:id', async function(req, res, next) {
    const id = req.params.id;
    const data = await getList(id);
    res.render('list/edit', {title: 'List', list: data});
  })
  
  router.post('/new', async function( req, res, next) {
    const list = await createList(req.body.name, req.body.description)
    const id = list.id
    res.redirect('/lists/'+id);
  });
  
  /* POST existing item update */
  router.post('/:id', async function( req, res, next) {
    const list_id = req.params.id;
    await updateList(list_id, req.body.name, req.body.description)
    res.redirect('/lists/'+list_id);
  })

  
  router.post('/:id/newentry/', async function(req, res, next) {
    const id = req.params.id;
    await createListEntry(id, req.body.sequence,req.body.name, req.body.description, req.body.modifier_value);
    res.redirect('/lists/'+id);
  });
  
  
module.exports = router;
