var express = require('express');
var router = express.Router();
const {  getCapacitor, getPins, getDipLeftPins, getDipRightPins, getSipPins,
  getSpecs, getNotes, getAliases, createAlias, deleteAliases, createCapacitor, updateCapacitor, createPin, updatePin,
  getInventoryByComponentList, getPackageTypesForComponentType, getComponentSubTypesForComponentType,
  getPickListByName, getComponentType, getComponentTypeList} = require('../database');
const {parse_symbol} = require('../utility');

/* GET new item page */
router.get('/new', async function(req, res, next) {
  const component_type_id = 2;
  const component_type = await getComponentType(component_type_id);
  data = {chip_number: '',
    aliases: '',
    package_type_id: '',
    pin_count: 2,
    component_sub_type_id: '',
    capacitance: '',
    unit_id: 3,
    tolerance: '',
    working_voltage: '',
    datasheet: '',
    description: '',
    component_name: component_type.decscription,
    table_name: component_type.table_name,
  };
  var pin=[];
  var sym = [];
  var descr = [];
  pin.push(1);
  sym.push("L");
  descr.push("Left Pin");
  pin.push(2);
  sym.push("R");
  descr.push("Rigth Pin");
  
  data['pin'] = pin;
  data['sym'] = sym;
  data['descr'] = descr;

  const package_types = await getPackageTypesForComponentType(component_type_id);
  const component_sub_types = await getComponentSubTypesForComponentType(component_type_id);
  const unit_list = await getPickListByName('Capacitance');

  res.render('capacitor/new', {title: 'New Capacitor Definition', data: data, package_types: package_types, 
    component_sub_types: component_sub_types, unit_list: unit_list});
});
  
/* GET item page */
router.get('/:id', async function(req, res, nest) {
  const id = req.params.id;
  const data = await getCapacitor(id);
  const pins = await getPins(id);
  const sip_pins = await getSipPins(id);
  const dip_left_pins = await getDipLeftPins(id);
  const dip_right_pins = await getDipRightPins(id);
  const specs = await getSpecs(id);
  const notes = await getNotes(id);
  const inventory = await getInventoryByComponentList(id);
  const aliases = await getAliases(id);
  const component_types = await getComponentTypeList();
  const component_type_id = data.component_type_id;

  fixed_pins = [];
  iswide = 'dpindiagram';
  pins.forEach(function(pin) {
    if (pin.pin_description.length > 100) {
       iswide = 'dpindiagramwide';
    }
    fixed_pins.push(
      {pin_number: pin.pin_number, pin_symbol: parse_symbol(pin.pin_symbol), pin_description: pin.pin_description, iswide: iswide}
    )
  });

  layout_pins = [];
  top_pins = [];
  bottom_pins = [];
  if (data.package == 'Radial') {
    sip_pins.forEach(function(pin) {
      if (pin.pin_number == 1) {
        bull = '&nbsp;&#9679;'
      } else {
        bull = ''
      }
      layout_pins.push({'pin': pin.pin_number, 'bull': bull, 'sym': parse_symbol(pin.pin_symbol)});
    });
  
  } else {
    i = 0;
    dip_left_pins.forEach(function(pin) {
      if (pin.pin_number == 1) {
        bull = '&nbsp;&#9679;'
      } else {
        bull = ''
      }
      layout_pins.push(
        {'left_pin': pin.pin_number, 'bull': bull, 'right_pin': dip_right_pins[i].pin_number, 
        'left_sym': parse_symbol(pin.pin_symbol), 'right_sym': parse_symbol(dip_right_pins[i].pin_symbol),
      });
      i++;
    });
  }

  clean_specs = [];
  specs.forEach(function(spec) {
    clean_specs.push(
      {id: spec.id, parameter: parse_symbol(spec.parameter), unit: parse_symbol(spec.unit), value: parse_symbol(spec.value)}
    )
  })

  clean_notes = [];
  notes.forEach(function(note) {
    clean_notes.push(
      {id: note.id, note: parse_symbol(note.note)}
    )
  })

  res.render('capacitor/detail', { title: data.chip_number + ' - ' + data.description, data: data, 
    pins: fixed_pins, layout_pins: layout_pins,
    specs: clean_specs, notes: clean_notes, aliases: aliases, inventory: inventory,
    component_types: component_types, component_type_id: component_type_id });
});

/* GET Edit item page */
router.get('/edit/:id', async function(req, res, next) {
  const capacitor_id = req.params.id;
  const capacitor = await getCapacitor(capacitor_id);
  const pins = await getPins(capacitor_id);
  const aliases = await getAliases(capacitor_id);
  const package_types = await getPackageTypesForComponentType(2);
  const component_sub_types = await getComponentSubTypesForComponentType(2);
  const unit_list = await getPickListByName('Capacitance');

  aliasList = "";
  sep = "";
  aliases.forEach(function(alias) {
    aliasList += (sep + alias.alias_chip_number);
    sep = ", ";
  })
  
  data = {
    component_id: capacitor_id,
    chip_number: capacitor.chip_number,
    aliases: aliasList,
    capacitance: capacitor.capacitance,
    unit_id: capacitor.unit_id,
    tolerance: capacitor.tolerance,
    working_voltage: capacitor.working_voltage,
    package_type_id: capacitor.package_type_id,
    component_sub_type_id: capacitor.component_sub_type_id,
    pin_count: capacitor.pin_count,
    datasheet: capacitor.datasheet,
    description: capacitor.description,
    component_name: capacitor.component_name,
    table_name: capacitor.table_name,
 }

  var pin_id=[];
  var pin_num=[];
  var sym = [];
  var descr = [];
  pins.forEach(function(pin) {
    pin_id.push(pin.id);
    pin_num.push(pin.pin_number);
    sym.push(pin.pin_symbol);
    descr.push(pin.pin_description);
  });

  data['pin_id'] = pin_id;
  data['pin'] = pin_num;
  data['sym'] = sym;
  data['descr'] = descr;

  res.render('capacitor/edit', {title: 'Edit Capacitor Definition', data: data, package_types: package_types, 
    component_sub_types: component_sub_types, unit_list: unit_list});
})
  
router.post('/new', async function( req, res, next) {
  const component_type_id = 2;
  const component_type = await getComponentType(component_type_id);
  data = {chip_number: req.body.chip_number,
    aliases: req.body.aliases,
    capacitance: req.body.capacitance,
    unit_id: req.body.unit_id,
    tolerance: req.body.tolerance,
    working_voltage: req.body.working_voltage,
    package_type_id: req.body.package_type_id,
    component_sub_type_id: req.body.component_sub_type_id,
    pin_count: req.body.pin_count,
    datasheet: req.body.datasheet,
    description: req.body.description,
    component_name: component_type.decscription,
    table_name: component_type.table_name,
  }
  const package_types = await getPackageTypesForComponentType(component_type_id);
  const component_sub_types = await getComponentSubTypesForComponentType(component_type_id);
  var pin=[];
  var sym = [];
  var descr = [];
  for (var i = 0; i < req.body.pin_count; i++) {
    pin.push(req.body["pin_"+i]);
    sym.push(req.body["sym_"+i]);
    descr.push(req.body["descr_"+i]);
  }
  data['pin'] = pin;
  data['sym'] = sym;
  data['descr'] = descr;

  if (descr[req.body.pin_count-1]) {
    
    const capacitor = await createCapacitor(data.chip_number, data.package_type_id, data.component_sub_type_id, data.description, data.pin_count, 
      data.capacitance, data.unit_id, data.working_voltage, data.tolerance, data.datasheet);
    capacitor_id = capacitor.component_id;

    for (var i = 0; i < req.body.pin_count; i++) {
      await createPin(capacitor_id, pin[i], sym[i], descr[i]);
    }

    aliases = data.aliases.split(',');
    for( const alias of aliases) {
      if (alias.length > 0) {
        await createAlias(capacitor_id, alias.trim());
      }
    }

    res.redirect('/capacitors/'+capacitor_id);
  } else {
    res.render('capacitor/new', {title: 'New Capacitor Definition', data: data, package_types: package_types, component_sub_types: component_sub_types});
  }
});

router.post('/:id', async function( req, res, next) {
  const id = req.params.id;
  data = {chip_number: req.body.chip_number,
    aliases: req.body.aliases,
    capacitance: req.body.capacitance,
    unit_id: req.body.unit_id,
    tolerance: req.body.tolerance,
    working_voltage: req.body.working_voltage,
    package_type_id: req.body.package_type_id,
    component_sub_type_id: req.body.component_sub_type_id,
    pin_count: req.body.pin_count,
    datasheet: req.body.datasheet,
    description: req.body.description,
  }
  var pin_id=[];
  var pin=[];
  var sym = [];
  var descr = [];
  for (var i = 0; i < req.body.pin_count; i++) {
    pin_id.push(req.body["pin_id_"+i]);
    pin.push(req.body["pin_"+i]);
    sym.push(req.body["sym_"+i]);
    descr.push(req.body["descr_"+i]);
  }
  data['pin_id'] = pin_id;
  data['pin'] = pin;
  data['sym'] = sym;
  data['descr'] = descr;

  const capacitor = await updateCapacitor(id, data.chip_number, data.package_type_id, data.component_sub_type_id, data.description, data.pin_count, 
    data.capacitance, data.unit_id, data.working_voltage, data.tolerance, data.datasheet);
  capacitor_id =capacitor.component_id;

  for (var i = 0; i < req.body.pin_count; i++) {
    await updatePin(pin_id[i], capacitor_id, pin[i], sym[i], descr[i]);
  }

  await deleteAliases(capacitor_id);

  aliases = data.aliases.split(',');
  for( const alias of aliases) {
    if (alias.length > 0) {
      await createAlias(capacitor_id, alias.trim());
    }
  }

  res.redirect('/capacitors/'+id);
})
  
module.exports = router;
