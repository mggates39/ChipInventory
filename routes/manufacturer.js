var express = require('express');
var router = express.Router();
const { getManufacturer, searchManufacturers, getMfgCodesForMfg} = require('../database');

/* GET home page. */
router.get('/', async function(req, res, next) {
  const search_query = req.query.q;
  const search_type = req.query.w;
  var mfg_search = true;
  var code_search = false;
  var search_by = 'm';
  if (search_type == 'c') {
    mfg_search = false;
    code_search = true;
    search_by = 'c';
  }
  
  const data = await searchManufacturers(search_query, search_by);
  res.render('manufacturer/list', { title: 'Manufacturers', manufacturers: data, searched: search_query, mfg_search: mfg_search, code_search: code_search });
});

router.get('/new', async function(req, res, next) {
  res.redirect('/manufacturers/');
});

router.get('/:id', async function(req, res, next) {
    const id = req.params.id;
    const mfg = await getManufacturer(id);
    const codes = await getMfgCodesForMfg(id);
    res.render('manufacturer/detail', { title: 'Manufacturer Codes', mfg: mfg, codes: codes });
});

module.exports = router;
