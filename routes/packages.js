var express = require('express');
var router = express.Router();
const { getPackageTypeList} = require('../database');

/* GET home page. */
router.get('/', async function(req, res, next) {
  const data = await getPackageTypeList();
  res.render('package_type/list', { title: 'Package Types', package_types: data });
});

module.exports = router;
