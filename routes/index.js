var express = require('express');
var router = express.Router();
const {getSystemData, getComponentCounts, getAliasCounts, getInventoryCounts, checkDatabaseSchemaVersion} = require('../database');

/* GET home page. */
router.get('/', async function(req, res, next) {
  await checkDatabaseSchemaVersion();
  const data = await getSystemData();
  const counts = await getComponentCounts();
  const aliases = await getAliasCounts();
  const inventory = await getInventoryCounts();

  res.render('index', { title: 'Lab Management System', data: data, counts: counts, aliases: aliases, inventory: inventory });
});

module.exports = router;
