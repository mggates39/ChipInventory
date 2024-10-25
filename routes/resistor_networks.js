var express = require('express');
var router = express.Router();
const {getResistorNetwork, getPins, getDipLeftPins, getDipRightPins, getSipPins,
  getSpecs, getNotes, getAliases, createAlias, deleteAliases, createResistorNetwork, updateResistorNetwork, createPin, updatePin,
  getInventoryByComponentList, getPackageTypesForComponentType, getComponentSubTypesForComponentType, getPickListByName} = require('../database');
const {parse_symbol} = require('../utility');

/* GET new item page */
router.get('/new', async function(req, res, next) {
  data = {chip_number: '',
    aliases: '',
    package_type_id: '',
    pin_count: '',
    component_sub_type_id: '',
    resistance: '',
    unit_id: 6, 
    tolerance: '',
    power: '',
    number_resistors: '',
    datasheet: '',
    description: ''
  };

  const package_types = await getPackageTypesForComponentType(5);
  const component_sub_types = await getComponentSubTypesForComponentType(5);
  const unit_list = await getPickListByName('Resistance');

  res.render('resistor_network/new', {title: 'New Resistor Network Definition', data: data, package_types: package_types, 
    component_sub_types: component_sub_types, unit_list: unit_list});
});
  
/* GET item page */
router.get('/:id', async function(req, res, nest) {
  const id = req.params.id;
  const data = await getResistorNetwork(id);
  const pins = await getPins(id);
  const sip_pins = await getSipPins(id);
  const dip_left_pins = await getDipLeftPins(id);
  const dip_right_pins = await getDipRightPins(id);
  const specs = await getSpecs(id);
  const notes = await getNotes(id);
  const inventory = await getInventoryByComponentList(id);
  const aliases = await getAliases(id);

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

  if (data.package == 'SIP') {
    if (data.pin_count > 12) {
      iswide = 'dpindiagramwide';
    }
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

  res.render('resistor_network/detail', { title: data.chip_number + ' - ' + data.description, resistor: data, 
    pins: fixed_pins, layout_pins: layout_pins,
    specs: clean_specs, notes: notes, aliases: aliases, inventory: inventory });
});

/* GET Edit item page */
router.get('/edit/:id', async function(req, res, next) {
  const resistor_id = req.params.id;
  const resistor = await getResistorNetwork(resistor_id);
  const pins = await getPins(resistor_id);
  const aliases = await getAliases(resistor_id);
  const package_types = await getPackageTypesForComponentType(5);
  const component_sub_types = await getComponentSubTypesForComponentType(5);
  const unit_list = await getPickListByName('Resistance');

  aliasList = "";
  sep = "";
  aliases.forEach(function(alias) {
    aliasList += (sep + alias.alias_chip_number);
    sep = ", ";
  })
  
  data = {
    id: resistor_id,
    chip_number: resistor.chip_number,
    aliases: aliasList,
    resistance: resistor.resistance,
    unit_id: resistor.unit_id,
    tolerance: resistor.tolerance,
    power: resistor.power,
    number_resistors: resistor.number_resistors,
    package_type_id: resistor.package_type_id,
    component_sub_type_id: resistor.component_sub_type_id,
    pin_count: resistor.pin_count,
    datasheet: resistor.datasheet,
    description: resistor.description,
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

  res.render('resistor_network/edit', {title: 'Edit Resistor Network Definition', data: data, package_types: package_types, 
    component_sub_types: component_sub_types, unit_list: unit_list});
})
  
router.post('/new', async function( req, res, next) {
  data = {chip_number: req.body.chip_number,
    aliases: req.body.aliases,
    resistance: req.body.resistance,
    unit_id: req.body.unit_id,
    tolerance: req.body.tolerance,
    power: req.body.power,
    number_resistors: req.body.number_resistors,
    package_type_id: req.body.package_type_id,
    component_sub_type_id: req.body.component_sub_type_id,
    pin_count: req.body.pin_count,
    datasheet: req.body.datasheet,
    description: req.body.description,
  }
  const package_types = await getPackageTypesForComponentType(5);
  const component_sub_types = await getComponentSubTypesForComponentType(5);
  const unit_list = await getPickListByName('Resistance');

  var pin=[];
  var sym = [];
  var descr = [];
  if (req.body["pin_0"] == '1') {
    for (var i = 0; i < req.body.pin_count; i++) {
        pin.push(req.body["pin_"+i]);
        sym.push(req.body["sym_"+i]);
        descr.push(req.body["descr_"+i]);
    }
  } else {
    pin.push(1);
    sym.push("CM");
    descr.push("Common");
    for (var i = 1; i < req.body.pin_count; i++) {
        pin.push(i+1);
        sym.push("R"+i);
        descr.push("Resistor "+i);
    }      
  }
  data['pin'] = pin;
  data['sym'] = sym;
  data['descr'] = descr;

  if (descr[req.body.pin_count-1]) {
    
    const resistor = await createResistorNetwork(data.chip_number, data.package_type_id, data.component_sub_type_id, data.description, data.pin_count, 
      data.resistance, data.unit_id, data.tolerance, data.power, data.number_resistors, data.datasheet);
    resistor_id = resistor.component_id;

    for (var i = 0; i < req.body.pin_count; i++) {
      await createPin(resistor_id, pin[i], sym[i], descr[i]);
    }

    aliases = data.aliases.split(',');
    for( const alias of aliases) {
      if (alias.length > 0) {
        await createAlias(resistor_id, alias.trim());
      }
    }

    res.redirect('/resistor_networks/'+resistor_id);
  } else {
    res.render('resistor_network/new', {title: 'New Resistor Network Definition', data: data, package_types: package_types, 
      component_sub_types: component_sub_types, unit_list: unit_list});
  }
});

router.post('/:id', async function( req, res, next) {
  const id = req.params.id;
  data = {chip_number: req.body.chip_number,
    aliases: req.body.aliases,
    resistance: req.body.resistance,
    unit_id: req.body.unit_id,
    tolerance: req.body.tolerance,
    power: req.body.power,
    number_resistors: req.body.number_resistors,
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

  const resistor = await updateResistorNetwork(id, data.chip_number, data.package_type_id, data.component_sub_type_id, data.description, data.pin_count, 
    data.resistance, data.unit_id, data.tolerance, data.power, data.number_resistors, data.datasheet);
  resistor_id =resistor.component_id;

  for (var i = 0; i < req.body.pin_count; i++) {
    await updatePin(pin_id[i], resistor_id, pin[i], sym[i], descr[i]);
  }

  await deleteAliases(resistor_id);

  aliases = data.aliases.split(',');
  for( const alias of aliases) {
    if (alias.length > 0) {
      await createAlias(resistor_id, alias.trim());
    }
  }

  res.redirect('/resistor_networks/'+id);
})
  
module.exports = router;
