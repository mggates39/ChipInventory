var express = require('express');
var router = express.Router();
const {  getResistor, getPins, getDipLeftPins, getDipRightPins, 
  getSpecs, getNotes, getAliases, createAlias, deleteAliases, createResistor, updateResistor, createPin, updatePin,
  getInventoryByComponentList, getPackageTypesForComponentType, getComponentSubTypesForComponentType,
  getPickListByName, getListEntry, getComponentType, getComponentTypeList } = require('../database');
const {parse_symbol} = require('../utility');

function getResistorBands(resistance, unit_modifier, tolerance) {
  const colorCodes = [
    "black", "brown", "red", "orange", "yellow", 
    "green", "blue", "violet", "grey", "white",
    "gold", "silver", "none"
  ];

  let resistanceStr = resistance.toString();
  let multiplier = Math.pow(10, unit_modifier);

  let resistanceValue = parseFloat(resistanceStr) * multiplier;
  const significantDigits = resistanceValue.toString().split('.')[0];

  let wholeNumber = significantDigits[0];

  // Handle decimal values
  if (significantDigits.length > 1) {
    wholeNumber += significantDigits[1]; 
    wholeNumber = parseInt(wholeNumber);
  }

  // Calculate multiplier for band
  multiplier = 1;
  while (resistanceValue >= 100) {
    resistanceValue /= 10;
    multiplier *= 10;
  }

  let bands = [];
  
  // First two bands (significant digits)
  for (let i = 0; i < 2; i++) {
    bands.push(colorCodes[parseInt(wholeNumber.toString()[i])]);
  }

  // Third band (multiplier)
  let multiplierExponent = Math.log10(multiplier);
  bands.push(colorCodes[multiplierExponent]);

  bands.push(colorCodes[12]);  // Blank band for spacing

  // Fourth band (tolerance)
  switch (tolerance) {
    case 1:
      bands.push(colorCodes[1]);
      break;
    case 2:
      bands.push(colorCodes[2]);
      break;
    case 0.5:
      bands.push(colorCodes[5]);
      break;
    case 0.25:
      bands.push(colorCodes[6]);
      break;
    case 0.1:
      bands.push(colorCodes[7]);
      break;
    case 5:
      bands.push(colorCodes[10]);
      break;
    case 10:
      bands.push(colorCodes[11]);
      break;
    default:
      bands.push(colorCodes[12]);
  }

  return bands;
}


/* GET new item page */
router.get('/new', async function(req, res, next) {
  const component_type_id = 4;
  const component_type = await getComponentType(component_type_id);
  const package_types = await getPackageTypesForComponentType(component_type_id);
  const component_sub_types = await getComponentSubTypesForComponentType(component_type_id);
  const unit_list = await getPickListByName('Resistance');

  data = {chip_number: '',
    aliases: '',
    package_type_id: '',
    pin_count: 2,
    component_sub_type_id: '',
    resistance: '',
    unit_id: 6, 
    tolerance: '',
    power: '',
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

  res.render('resistor/new', {title: 'New Resistor Definition', data: data, package_types: package_types, 
    component_sub_types: component_sub_types, unit_list: unit_list});
});
  
/* GET item page */
router.get('/:id', async function(req, res, nest) {
  const id = req.params.id;
  const data = await getResistor(id);
  const pins = await getPins(id);
  const dip_left_pins = await getDipLeftPins(id);
  const dip_right_pins = await getDipRightPins(id);
  const specs = await getSpecs(id);
  const notes = await getNotes(id);
  const inventory = await getInventoryByComponentList(id);
  const aliases = await getAliases(id);
  const component_types = await getComponentTypeList();
  const component_type_id = data.component_type_id;
  const units = await getListEntry(data.unit_id);

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
  bands = getResistorBands(data.resistance, units.modifier_value, data.tolerance) ;
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

  res.render('resistor/detail', { title: data.chip_number + ' - ' + data.description, data: data, 
    pins: fixed_pins, layout_pins: layout_pins, top_pins: bands,
    specs: clean_specs, notes: clean_notes, aliases: aliases, inventory: inventory,
    component_types: component_types, component_type_id: component_type_id });
});

/* GET Edit item page */
router.get('/edit/:id', async function(req, res, next) {
  const resistor_id = req.params.id;
  const data = await getResistor(resistor_id);
  const pins = await getPins(resistor_id);
  const aliases = await getAliases(resistor_id);
  const package_types = await getPackageTypesForComponentType(4);
  const component_sub_types = await getComponentSubTypesForComponentType(4);
  const unit_list = await getPickListByName('Resistance');

  aliasList = "";
  sep = "";
  aliases.forEach(function(alias) {
    aliasList += (sep + alias.alias_chip_number);
    sep = ", ";
  })
  
  data['aliases'] = aliasList;

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

  res.render('resistor/edit', {title: 'Edit Resistor Definition', data: data, package_types: package_types, 
    component_sub_types: component_sub_types, unit_list: unit_list});
})
  
router.post('/new', async function( req, res, next) {
  const component_type_id = 4;
  const component_type = await getComponentType(component_type_id);
  const package_types = await getPackageTypesForComponentType(component_type_id);
  const component_sub_types = await getComponentSubTypesForComponentType(component_type_id);
  const unit_list = await getPickListByName('Resistance');

  data = {chip_number: req.body.chip_number,
    aliases: req.body.aliases,
    resistance: req.body.resistance,
    unit_id: req.body.unit_id, 
    tolerance: req.body.tolerance,
    power: req.body.power,
    package_type_id: req.body.package_type_id,
    component_sub_type_id: req.body.component_sub_type_id,
    pin_count: req.body.pin_count,
    datasheet: req.body.datasheet,
    description: req.body.description,
    component_name: component_type.decscription,
    table_name: component_type.table_name,
  }

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
    
    const resistor = await createResistor(data.chip_number, data.package_type_id, data.component_sub_type_id, data.description, data.pin_count, 
      data.resistance, data.unit_id, data.tolerance, data.power, data.datasheet);
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
    res.render('resistor/new', {title: 'New Resistor Definition', data: data, package_types: package_types, 
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

  const resistor = await updateResistor(id, data.chip_number, data.package_type_id, data.component_sub_type_id, data.description, data.pin_count, 
    data.resistance, data.unit_id, data.tolerance, data.power, data.datasheet);
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
