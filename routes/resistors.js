var express = require('express');
var router = express.Router();
const {  getResistor, getPins, getDipLeftPins, getDipRightPins, 
  getPllcLeftPins, getPllcRightPins, getPllcTopPins, getPllcBottomPins, 
  getQuadLeftPins, getQuadRightPins, getQuadTopPins, getQuadBottomPins,
  getSpecs, getNotes, getAliases, createAlias, deleteAliases, createResistor, updateResistor, createPin, updatePin,
  getInventoryByComponentList, getPackageTypesForComponentType, getComponentSubTypesForComponentType} = require('../database');
const {parse_symbol} = require('../utility');

/* GET new item page */
router.get('/new', async function(req, res, next) {
  data = {chip_number: '',
    aliases: '',
    package_type_id: '',
    pin_count: 2,
    component_sub_type_id: '',
    resistance: '',
    tolerance: '',
    power: '',
    datasheet: '',
    description: ''
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

  const package_types = await getPackageTypesForComponentType(4);
  const component_sub_types = await getComponentSubTypesForComponentType(4);

  res.render('resistor/new', {title: 'New Resistor Definition', data: data, package_types: package_types, component_sub_types: component_sub_types});
});
  
/* GET item page */
router.get('/:id', async function(req, res, nest) {
  const id = req.params.id;
  const data = await getResistor(id);
  const pins = await getPins(id);
  const dip_left_pins = await getDipLeftPins(id);
  const dip_right_pins = await getDipRightPins(id);
  const plcc_left_pins = await getPllcLeftPins(id);
  const plcc_right_pins = await getPllcRightPins(id);
  const plcc_top_pins = await getPllcTopPins(id);
  const plcc_bottom_pins = await getPllcBottomPins(id);
  const quad_left_pins = await getQuadLeftPins(id);
  const quad_right_pins = await getQuadRightPins(id);
  const quad_top_pins = await getQuadTopPins(id);
  const quad_bottom_pins = await getQuadBottomPins(id);
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
  top_pins = [];
  bottom_pins = [];
  if (data.package == 'PLCC') {
    i = 0;
    plcc_left_pins.forEach(function(pin) {
      if (pin.pin_number == 1) {
        bull = '&nbsp;&#9679;'
      } else {
        bull = ''
      }
      layout_pins.push(
        {'left_pin': pin.pin_number, 'bull': bull, 'right_pin': plcc_right_pins[i].pin_number, 
        'left_sym': parse_symbol(pin.pin_symbol), 'right_sym': parse_symbol(plcc_right_pins[i].pin_symbol),
      });
      i++;
    });

    plcc_top_pins.forEach(function(pin) {
      if (pin.pin_number == 1) {
        bull = '&#9679;&nbsp;'
      } else {
        bull = ''
      }
      top_pins.push({'pin': pin.pin_number, 'bull': bull, 'sym': parse_symbol(pin.pin_symbol)});
    });

    plcc_bottom_pins.forEach(function(pin) {
      if (pin.pin_number == 1) {
        bull = '&#9679;&nbsp;'
      } else {
        bull = ''
      }
      bottom_pins.push({'pin': pin.pin_number, 'bull': bull, 'sym': parse_symbol(pin.pin_symbol)});

    });
  } else if  ((data.package == 'QFN') || (data.package == 'QFP')) {
    i = 0;
    quad_left_pins.forEach(function(pin) {
      if (pin.pin_number == 1) {
        bull = '&#9679;'
      } else {
        bull = ''
      }
      layout_pins.push(
        {'left_pin': pin.pin_number, 'bull': bull, 'right_pin': quad_right_pins[i].pin_number, 
        'left_sym': parse_symbol(pin.pin_symbol), 'right_sym': parse_symbol(quad_right_pins[i].pin_symbol),
      });
      i++;
    });

    quad_top_pins.forEach(function(pin) {
      if (pin.pin_number == 1) {
        bull = '&#9679;&nbsp;'
      } else {
        bull = ''
      }
      top_pins.push({'pin': pin.pin_number, 'bull': bull, 'sym': parse_symbol(pin.pin_symbol)});
    });

    quad_bottom_pins.forEach(function(pin) {
      if (pin.pin_number == 1) {
        bull = '&#9679;&nbsp;'
      } else {
        bull = ''
      }
      bottom_pins.push({'pin': pin.pin_number, 'bull': bull, 'sym': parse_symbol(pin.pin_symbol)});

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

  res.render('resistor/detail', { title: data.chip_number + ' - ' + data.description, resistor: data, 
    pins: fixed_pins, layout_pins: layout_pins, top_pins: top_pins, bottom_pins: bottom_pins,
    specs: clean_specs, notes: notes, aliases: aliases, inventory: inventory });
});

/* GET Edit item page */
router.get('/edit/:id', async function(req, res, next) {
  const resistor_id = req.params.id;
  const resistor = await getResistor(resistor_id);
  const pins = await getPins(resistor_id);
  const aliases = await getAliases(resistor_id);
  const package_types = await getPackageTypesForComponentType(4);
  const component_sub_types = await getComponentSubTypesForComponentType(4);

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
    tolerance: resistor.tolerance,
    power: resistor.power,
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

  res.render('resistor/edit', {title: 'Edit Resistor Definition', data: data, package_types: package_types, component_sub_types: component_sub_types});
})
  
router.post('/new', async function( req, res, next) {
  data = {chip_number: req.body.chip_number,
    aliases: req.body.aliases,
    resistance: req.body.resistance,
    tolerance: req.body.tolerance,
    power: req.body.power,
    package_type_id: req.body.package_type_id,
    component_sub_type_id: req.body.component_sub_type_id,
    pin_count: req.body.pin_count,
    datasheet: req.body.datasheet,
    description: req.body.description,
  }
  const package_types = await getPackageTypesForComponentType(4);
  const component_sub_types = await getComponentSubTypesForComponentType(4);
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
    
    const resistor = await createResistor(data.chip_number, data.package_type_id, data.component_sub_type_id, data.description, data.pin_count, data.resistance, data.tolerance, data.power, data.datasheet);
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

    res.redirect('/resistors/'+resistor_id);
  } else {
    res.render('resistor/new', {title: 'New Resistor Definition', data: data, package_types: package_types, component_sub_types: component_sub_types});
  }
});

router.post('/:id', async function( req, res, next) {
  const id = req.params.id;
  data = {chip_number: req.body.chip_number,
    aliases: req.body.aliases,
    resistance: req.body.resistance,
    tolerance: req.body.tolerance,
    power: req.body.power,
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

  const resistor = await updateResistor(id, data.chip_number, data.package_type_id, data.component_sub_type_id, data.description, data.pin_count, data.resistance, data.tolerance, data.power, data.datasheet);
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

  res.redirect('/resistors/'+id);
})
  
module.exports = router;
