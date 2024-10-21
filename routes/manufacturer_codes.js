var express = require('express');
var router = express.Router();
const { getManufacturerCode, updateManufacturerCode, deleteManufacturerCode} = require('../database');

// Delete manufacturer item data
router.get('/delete/:id', async function(req, res) {
    const manufacturer_code_id = req.params.id;
    const data = await getManufacturerCode(manufacturer_code_id);
    const manufacturer_id = data.manufacturer_id;
    await deleteManufacturerCode(manufacturer_code_id)
    res.redirect('/manufacturers/'+manufacturer_id);
  })
  
// GET manufacturer code data
router.get('/:id', async function(req, res, next) {
    const id = req.params.id;
    const data = await getManufacturerCode(id);
    res.send(data);
  });

/* POST existing manufacturer item update */
router.post('/:id', async function( req, res, next) {
    const id = req.params.id;
    const manufacturer_id = req.body.manufacturer_id;
    await updateManufacturerCode(id, manufacturer_id, req.body.code);
    res.redirect('/manufacturers/'+manufacturer_id);
  })
  
module.exports = router;
