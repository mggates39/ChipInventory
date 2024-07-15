var express = require('express');
var router = express.Router();
const { getSystemData} = require('../database');

/* GET home page. */
router.get('/', async function(req, res, next) {
  const data = await getSystemData();
  res.render('index', { title: 'Lab Management System', data: data });
});

module.exports = router;
