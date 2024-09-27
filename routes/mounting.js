var express = require('express');
var router = express.Router();
const { getMountingTypeList} = require('../database');

/* GET home page. */
router.get('/', async function(req, res, next) {
  const data = await getMountingTypeList();
  res.render('mounting_type/list', { title: 'Mounting Types', mounting_types: data });
});

module.exports = router;
