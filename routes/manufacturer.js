var express = require('express');
var router = express.Router();
const {createManufacturer, updateManufacturer, getManufacturer, searchManufacturers, getMfgCodesForMfg, createManufacturerCode} = require('../database');

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

router.get('/new/', async function(req, res, next) {
  const id = req.params.id;

  const data = {
    name: ''
  };
  res.render('manufacturer/new', {title: 'New Manufacturer', data: data});
});

router.get('/:id', async function(req, res, next) {
    const id = req.params.id;
    const mfg = await getManufacturer(id);
    const codes = await getMfgCodesForMfg(id);
    res.render('manufacturer/detail', { title: 'Manufacturer Codes', mfg: mfg, codes: codes });
});

router.get('/edit/:id', async function(req, res, next) {
  const id = req.params.id;
  const data = await getManufacturer(id);
  res.render('manufacturer/edit', {title: 'Edit Manufacturer', data: data});
})

router.post('/new', async function(req, res, next) {
  const manufacturer = await createManufacturer(req.body.name);
  const id = manufacturer.id
  res.redirect('/manufacturers/'+id);
});

router.post('/:id/newcode', async function( req, res, next) {
  const id = req.params.id;
  await createManufacturerCode(id, req.body.code);
  res.redirect('/manufacturers/'+id);
})

router.post('/:id', async function( req, res, next) {
  const id = req.params.id;
  await updateManufacturer(id, req.body.name);
  res.redirect('/manufacturers/'+id);
})

module.exports = router;
