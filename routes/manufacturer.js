var express = require('express');
var router = express.Router();
const { getManufacturer, getManufacturerList, getMfgCodesForMfg} = require('../database');

/* GET home page. */
router.get('/', async function(req, res, next) {
  const data = await getManufacturerList();
  res.render('manufacturer/list', { title: 'Manufacturers', manufacturers: data });
});

router.get('/:id', async function(req, res, next) {
    const id = req.params.id;
    const mfg = await getManufacturer(id);
    const codes = await getMfgCodesForMfg(id);
    res.render('manufacturer/detail', { title: 'Manufacturer Codes', mfg: mfg, codes: codes });
})

module.exports = router;
