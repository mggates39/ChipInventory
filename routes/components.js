var express = require('express');
const { searchChips, getComponentTypeList, getComponentType} = require('../database');
var router = express.Router();

/* GET chip list page. */
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

module.exports = router;
