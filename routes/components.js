var express = require('express');
var router = express.Router();
const { getComponentTypeList} = require('../database');

/* GET home page. */
router.get('/', async function(req, res, next) {
  const data = await getComponentTypeList();
  res.render('component_type/list', { title: 'Component Types', component_types: data });
});

module.exports = router;
