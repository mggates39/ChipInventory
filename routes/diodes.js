var express = require('express');
var router = express.Router();
const {  getDiode, getPins, getDipLeftPins, getDipRightPins, getSipPins,
  getSpecs, getNotes, getAliases, createAlias, deleteAliases, createDiode, updateDiode, createPin, updatePin,
  getInventoryByComponentList, getPackageTypesForComponentType, getComponentSubTypesForComponentType,
  getPickListByName} = require('../database');
const {parse_symbol} = require('../utility');

/* GET new item page */
router.get('/new', async function(req, res, next) {
  data = {chip_number: '',
    aliases: '',
    package_type_id: '',
    pin_count: '',
    component_sub_type_id: '',
    forward_voltage: '',
    forward_unit_id: 1,
    reverse_voltage: '',
    reverse_unit_id: 1,
    light_color_id: '',
    lens_color_id: '',
    datasheet: '',
    description: ''
  };

  const package_types = await getPackageTypesForComponentType(6);
  const component_sub_types = await getComponentSubTypesForComponentType(6);
  const unit_list = await getPickListByName('DiodeVoltage');
  const light_colors = await getPickListByName('LEDColor');
  const lens_colors = await getPickListByName('LensColor');

  res.render('diode/new', {title: 'New Diode Definition', data: data, package_types: package_types, 
    component_sub_types: component_sub_types, unit_list: unit_list, light_colors: light_colors, lens_colors: lens_colors});
});
  
/* GET item page */
router.get('/:id', async function(req, res, nest) {
  const id = req.params.id;
  const data = await getDiode(id);
  const pins = await getPins(id);
  const dip_left_pins = await getDipLeftPins(id);
  const dip_right_pins = await getDipRightPins(id);
  const sip_pins = await getSipPins(id);
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

  res.render('diode/detail', { title: data.chip_number + ' - ' + data.description, diode: data, 
    pins: fixed_pins, layout_pins: layout_pins, 
    specs: clean_specs, notes: notes, aliases: aliases, inventory: inventory });
});

/* GET Edit item page */
router.get('/edit/:id', async function(req, res, next) {
  const diode_id = req.params.id;
  const diode = await getDiode(diode_id);
  const pins = await getPins(diode_id);
  const aliases = await getAliases(diode_id);
  const package_types = await getPackageTypesForComponentType(6);
  const component_sub_types = await getComponentSubTypesForComponentType(6);
  const unit_list = await getPickListByName('DiodeVoltage');
  const light_colors = await getPickListByName('LEDColor');
  const lens_colors = await getPickListByName('LensColor');

  aliasList = "";
  sep = "";
  aliases.forEach(function(alias) {
    aliasList += (sep + alias.alias_chip_number);
    sep = ", ";
  })
  
  data = {
    component_id: diode_id,
    chip_number: diode.chip_number,
    aliases: aliasList,
    package_type_id: diode.package_type_id,
    pin_count: diode.pin_count,
    component_sub_type_id: diode.component_sub_type_id,
    forward_voltage: diode.forward_voltage,
    forward_unit_id: diode.forward_unit_id,
    reverse_voltage: diode.reverse_voltage,
    reverse_unit_id: diode.reverse_unit_id,
    light_color_id: diode.light_color_id,
    lens_color_id: diode.lens_color_id,
    datasheet: diode.datasheet,
    description: diode.description,
  };

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

  res.render('diode/edit', {title: 'Edit Diode Definition', data: data, package_types: package_types, 
    component_sub_types: component_sub_types, unit_list: unit_list, light_colors: light_colors, lens_colors: lens_colors});
})
  
router.post('/new', async function( req, res, next) {
  data = {chip_number: req.body.chip_number,
    aliases: req.body.aliases,
    package_type_id: req.body.package_type_id,
    component_sub_type_id: req.body.component_sub_type_id,
    pin_count: req.body.pin_count,
    forward_voltage: req.body.forward_voltage,
    forward_unit_id: req.body.forward_unit_id,
    reverse_voltage: req.body.reverse_voltage,
    reverse_unit_id: req.body.reverse_unit_id,
    light_color_id: req.body.light_color_id,
    lens_color_id: req.body.lens_color_id,
    datasheet: req.body.datasheet,
    description: req.body.description,
  }

  const package_types = await getPackageTypesForComponentType(6);
  const component_sub_types = await getComponentSubTypesForComponentType(6);
  const unit_list = await getPickListByName('DiodeVoltage');
  const light_colors = await getPickListByName('LEDColor');
  const lens_colors = await getPickListByName('LensColor');

  let pin_count = 2;
  light_colors.forEach(function(color) {
    if (color.id == data.light_color_id) {
      pin_count = color.modifier_value;
    }
  })

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
    data.pin_count = pin_count;
    if (pin_count == 2) {
      pin.push(1);
      sym.push('A+');
      descr.push('Anode');
      pin.push(2);
      sym.push('C-');
      descr.push('Cathode');
    }
  }     

  data['pin'] = pin;
  data['sym'] = sym;
  data['descr'] = descr;
  if (descr[req.body.pin_count-1]) {
    const diode = await createDiode(data.chip_number, data.pin_count, data.package_type_id, data.component_sub_type_id, data.description, 
      data.forward_voltage, data.forward_unit_id, data.reverse_voltage, data.reverse_unit_id, data.light_color_id, data.lens_color_id, data.datasheet);
    diode_id = diode.component_id;

    for (var i = 0; i < req.body.pin_count; i++) {
      await createPin(diode_id, pin[i], sym[i], descr[i]);
    }

    aliases = data.aliases.split(',');
    for( const alias of aliases) {
      if (alias.length > 0) {
        await createAlias(diode_id, alias.trim());
      }
    }

    res.redirect('/diodes/'+diode_id);
  } else {
      res.render('diode/new', {title: 'New Diode Definition', data: data, package_types: package_types, 
        component_sub_types: component_sub_types, unit_list: unit_list, light_colors: light_colors, lens_colors: lens_colors});
    }
});

router.post('/:id', async function( req, res, next) {
  const id = req.params.id;
  data = {chip_number: req.body.chip_number,
    aliases: req.body.aliases,
    package_type_id: req.body.package_type_id,
    component_sub_type_id: req.body.component_sub_type_id,
    pin_count: req.body.pin_count,
    forward_voltage: req.body.forward_voltage,
    forward_unit_id: req.body.forward_unit_id,
    reverse_voltage: req.body.reverse_voltage,
    reverse_unit_id: req.body.reverse_unit_id,
    light_color_id: req.body.light_color_id,
    lens_color_id: req.body.lens_color_id,
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

  const diode = await updateDiode(id, data.chip_number, data.pin_count, data.package_type_id, data.component_sub_type_id, data.description, 
    data.forward_voltage, data.forward_unit_id, data.reverse_voltage, data.reverse_unit_id, data.light_color_id, data.lens_color_id, data.datasheet);
  diode_id =diode.component_id;

  for (var i = 0; i < req.body.pin_count; i++) {
    await updatePin(pin_id[i], diode_id, pin[i], sym[i], descr[i]);
  }

  await deleteAliases(diode_id);

  aliases = data.aliases.split(',');
  for( const alias of aliases) {
    if (alias.length > 0) {
      await createAlias(diode_id, alias.trim());
    }
  }

  res.redirect('/diodes/'+id);
})
  
module.exports = router;
