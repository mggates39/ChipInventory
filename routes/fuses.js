var express = require('express');
const { getFuse, createFuse, updateFuse, getPins, createPin, updatePin, 
  getDipLeftPins, getDipRightPins, getSipPins,
  getSpecs, getNotes, getInventoryByComponentList, getPackageTypesForComponentType, 
  getComponentSubTypesForComponentType,
  getAliases, createAlias, deleteAliases, 
  getPickListByName} = require('../database');
const {parse_symbol} = require('../utility');
var router = express.Router();

router.get('/edit/:id', async function(req,res,next) {
  const fuse_id = req.params.id;

  const fuse = await getFuse(fuse_id);
  const pins = await getPins(fuse_id);
  const aliases = await getAliases(fuse_id);
  const package_types = await getPackageTypesForComponentType(13);
  const component_sub_types = await getComponentSubTypesForComponentType(13);
  const rating_units = await getPickListByName('FuseRating');
  const voltage_units = await getPickListByName('Voltages');

  aliasList = "";
  sep = "";
  aliases.forEach(function(alias) {
    aliasList += (sep + alias.alias_fuse_number);
    sep = ", ";
  })
  
  data = {
    id: fuse_id,
    fuse_number: fuse.chip_number,
    aliases: aliasList,
    package_type_id: fuse.package_type_id,
    component_sub_type_id: fuse.component_sub_type_id,
    pin_count: fuse.pin_count,
    rating: fuse.rating,
    rating_unit_id: fuse.rating_unit_id,
    voltage: fuse.voltage,
    voltage_unit_id: fuse.voltage_unit_id,
    datasheet: fuse.datasheet,
    description: fuse.description,
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

  res.render('fuse/edit', {title: 'Edit Fuse Definition', data: data, package_types: package_types, 
    component_sub_types: component_sub_types, rating_units: rating_units, voltage_units: voltage_units});
})

/* GET new fuse entry page */
router.get('/new', async function(req, res, next) {
  data = {fuse_number: '',
    aliases: '',
    package_type_id: '',
    component_sub_type_id: '',
    pin_count: 2,
    rating: '',
    rating_unit_id: '',
    voltage: '',
    voltage_unit_id: '',
    datasheet: '',
    description: ''
  }
  const package_types = await getPackageTypesForComponentType(13);
  const component_sub_types = await getComponentSubTypesForComponentType(13);
  const rating_units = await getPickListByName('FuseRating');
  const voltage_units = await getPickListByName('Voltages');

  res.render('fuse/new', {title: 'New Fuse Definition', data: data, package_types: package_types, 
    component_sub_types: component_sub_types, rating_units: rating_units, voltage_units: voltage_units});
});

router.post('/new', async function(req, res) {
  data = {fuse_number: req.body.fuse_number,
    aliases: req.body.aliases,
    package_type_id: req.body.package_type_id,
    component_sub_type_id: req.body.component_sub_type_id,
    pin_count: req.body.pin_count,
    rating: req.body.rating,
    rating_unit_id: req.body.rating_unit_id,
    voltage: req.body.voltage,
    voltage_unit_id: req.body.voltage_unit_id,
    datasheet: req.body.datasheet,
    description: req.body.description,
  }
  const package_types = await getPackageTypesForComponentType(13);
  const component_sub_types = await getComponentSubTypesForComponentType(13);
  const rating_units = await getPickListByName('FuseRating');
  const voltage_units = await getPickListByName('Voltages');

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
    for (var i = 0; i < req.body.pin_count; i++) {
        pin.push(i+1);
        sym.push("P");
        descr.push("Pin");
    }      
  }
  data['pin'] = pin;
  data['sym'] = sym;
  data['descr'] = descr;

  if (descr[req.body.pin_count-1]) {
    const fuse = await createFuse(data.fuse_number, data.pin_count, data.package_type_id, data.component_sub_type_id, 
      data.rating, data.rating_unit_id, data.voltage, data.voltage_unit_id, data.datasheet, data.description);
    fuse_id = fuse.component_id;

    for (var i = 0; i < req.body.pin_count; i++) {
      await createPin(fuse_id, pin[i], sym[i], descr[i]);
    }

    aliases = data.aliases.split(',');
    for( const alias of aliases) {
      if (alias.length > 0) {
        await createAlias(fuse_id, alias.trim());
      }
    }

    res.redirect('/fuses/'+fuse_id);
  } else {
    res.render('fuse/new', {title: 'New Fuse Definition', data: data, package_types: package_types, 
      component_sub_types: component_sub_types, rating_units: rating_units, voltage_units: voltage_units});
  }
});

router.post('/:id', async function(req, res) {
  const id = req.params.id;
  data = {fuse_number: req.body.fuse_number,
    aliases: req.body.aliases,
    package_type_id: req.body.package_type_id,
    component_sub_type_id: req.body.component_sub_type_id,
    pin_count: req.body.pin_count,
    rating: req.body.rating,
    rating_unit_id: req.body.rating_unit_id,
    voltage: req.body.voltage,
    voltage_unit_id: req.body.voltage_unit_id,
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

  const fuse = await updateFuse(id, data.fuse_number, data.pin_count, data.package_type_id, data.component_sub_type_id, 
    data.rating, data.rating_unit_id, data.voltage, data.voltage_unit_id, data.datasheet, data.description);
  fuse_id = fuse.component_id;

  for (var i = 0; i < req.body.pin_count; i++) {
    await updatePin(pin_id[i], fuse_id, pin[i], sym[i], descr[i]);
  }

  await deleteAliases(fuse_id);

  aliases = data.aliases.split(',');
  for( const alias of aliases) {
    if (alias.length > 0) {
      await createAlias(fuse_id, alias.trim());
    }
  }

  res.redirect('/fuses/'+id);
});

/* GET fuse detail page. */
router.get('/:id', async function(req, res, next) {
    const id = req.params.id;
    const fuse = await getFuse(id);
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
    top_pins = [];
    bottom_pins = [];

    if ((fuse.package == 'Radial') || (fuse.package == 'SIP')) {
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

    res.render('fuse/detail', { title: fuse.chip_number + ' - ' + fuse.description, fuse: fuse, 
      pins: fixed_pins, layout_pins: layout_pins, 
      specs: clean_specs, notes: clean_notes, aliases: aliases, inventory: inventory });
});
  
module.exports = router;
