var express = require('express');
const { searchChips, getComponentTypeList, getComponentType, getComponent, createSpec, deleteSpec, createNote} = require('../database');
var router = express.Router();

/* GET component list page. */
router.get('/', async function(req, res, next) {
  const search_query = req.query.q;
  const search_type = req.query.w;
  var component_type_id = req.query.component_type_id;
  var part_search = true;
  var key_search = false;
  var search_by = 'p';
  if (search_type == 'k') {
    part_search = false;
    key_search = true;
    search_by = 'k';
  }
  if (typeof component_type_id == 'undefined') {
    component_type_id = 0;
  }

  const chips = await searchChips(search_query, search_by, component_type_id);
  const component_types = await getComponentTypeList();
  res.render('component/list', { title: 'Component Master File', chips: chips, searched: search_query, part_search: part_search, key_search: key_search, 
    component_types: component_types, component_type_id: component_type_id });
});

router.post('/new/', async function(req, res, next) {
  const component_type_id = req.body.new_component;
  const comonent_type = await getComponentType(component_type_id);
  res.redirect("/"+comonent_type.table_name+"/new");
});

router.get('/:id', async function(req, res, next) {
  const id = req.params.id;
  const component = await getComponent(id);
  res.redirect("/"+component.table_name+"/"+id);
});

/* Add a specification to the selected component */
router.post('/:id/newspec', async function(req, res) {
  const id = req.params.id;
  await createSpec(id, req.body.param, req.body.value, req.body.units)
  res.redirect('/components/'+id);
});

router.get('/:id/delspec/:spec_id', async function(req, res) {
  const id = req.params.id;
  const spec_id = req.params.spec_id;
  await deleteSpec(spec_id)
  res.redirect('/components/'+id);
})

/* Add a note to the selected component */
router.post('/:id/newnote', async function(req, res) {
  const id = req.params.id;
  await createNote(id, req.body.note)
  res.redirect('/components/'+id);
});

/* Add one or more aliases to the selected chip */
router.post('/:id/newalias', async function(req, res) {
  const chip_id = req.params.id;
  aliases = req.body.alias.split(',');
  for( const alias of aliases) {
    if (alias.length > 0) {
      await createAlias(chip_id, alias.trim());
    }
  }
  res.redirect('/components/'+chip_id);
});

module.exports = router;
