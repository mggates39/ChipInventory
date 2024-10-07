var express = require('express');
var router = express.Router();
const {getSystemData, getComponentCounts} = require('../database');

/* GET home page. */
router.get('/', async function(req, res, next) {
  const data = await getSystemData();
  const counts = await getComponentCounts();
  res.render('index', { title: 'Lab Management System', data: data, counts: counts });
});

module.exports = router;
