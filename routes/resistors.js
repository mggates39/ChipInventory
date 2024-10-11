var express = require('express');
var router = express.Router();
const { getPackageTypesForComponentType, getComponentSubTypesForComponentType} = require('../database');

/* GET new item page */
router.get('/new', async function(req, res, next) {
  data = {chip_number: '',
    package_type_id: '',
    component_sub_type_id: '',
    resistance: '',
    tolerance: '',
    power: '',
    datasheet: '',
    description: ''
  }
  const package_types = await getPackageTypesForComponentType(4);
  const component_sub_types = await getComponentSubTypesForComponentType(4);

  res.render('resistor/new', {title: 'New Resistor Definition', data: data, package_types: package_types, component_sub_types: component_sub_types});
  });
  
// /* GET item page */
// router.get('/:id', async function(req, res, nest) {
//     const id = req.params.id;
//     const data = await getresistor(id);
//     res.render('resistor/detail', {title: 'resistor', resistor: data});
// });

// /* GET Edit item page */
// router.get('/edit/:id', async function(req, res, next) {
//     const id = req.params.id;
//     const data = await getresistor(id);
//     res.render('resistor/edit', {title: 'resistor', resistor: data});
//   })
  
// router.post('/new', async function( req, res, next) {
//     const resistor = await createresistor(req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_type_selection)
//     const id = resistor.id
//     res.redirect('/resistors/'+id);
//   });

// router.post('/:id', async function( req, res, next) {
//     const id = req.params.id;
//     await updateresistor(id, req.body.name, req.body.description, req.body.mounting_type_id, req.body.component_type_selection)
//     res.redirect('/resistors/'+id);
//   })
  
module.exports = router;
