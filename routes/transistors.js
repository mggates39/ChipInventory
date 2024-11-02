var express = require('express');
const { getTransistor, createTransistor, updateTransistor, getPins, createPin, updatePin, 
  getDipLeftPins, getDipRightPins, getSipPins,
  getPllcLeftPins, getPllcRightPins, getPllcTopPins, getPllcBottomPins,
  getQuadLeftPins, getQuadRightPins, getQuadTopPins, getQuadBottomPins,
  getSpecs, getNotes, getInventoryByComponentList, getPackageTypesForComponentType, 
  getComponentSubTypesForComponentType, getComponentType, 
  getAliases, createAlias, deleteAliases } = require('../database');
const {parse_symbol} = require('../utility');
var router = express.Router();

router.get('/edit/:id', async function(req,res,next) {
  const transistor_id = req.params.id;
  const component_type_id = 7;

  const data = await getTransistor(transistor_id);
  const pins = await getPins(transistor_id);
  const aliases = await getAliases(transistor_id);
  const package_types = await getPackageTypesForComponentType(component_type_id);
  const component_sub_types = await getComponentSubTypesForComponentType(component_type_id);

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

  res.render('transistor/edit', {title: 'Edit Transistor Definition', data: data, package_types: package_types, component_sub_types: component_sub_types});
})

/* GET new transistor entry page */
router.get('/new', async function(req, res, next) {
  const component_type_id = 7;
  const component_type = await getComponentType(component_type_id);
  const package_types = await getPackageTypesForComponentType(component_type_id);
  const component_sub_types = await getComponentSubTypesForComponentType(component_type_id);

   data = {chip_number: '',
    aliases: '',
    package_type_id: '',
    component_sub_type_id: '',
    pin_count: '',
    datasheet: '',
    description: '',
    component_name: component_type.decscription,
    table_name: component_type.table_name,
  };

 res.render('transistor/new', {title: 'New Transistor Definition', data: data, package_types: package_types, component_sub_types: component_sub_types});
});

router.post('/new', async function(req, res) {
  const component_type_id = 7;
  const component_type = await getComponentType(component_type_id);
  const package_types = await getPackageTypesForComponentType(component_type_id);
  const component_sub_types = await getComponentSubTypesForComponentType(component_type_id);

  data = {chip_number: req.body.chip_number,
    aliases: req.body.aliases,
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
    const transistor = await createTransistor(data.chip_number, data.pin_count, data.package_type_id, data.component_sub_type_id, data.datasheet, data.description);
    transistor_id = transistor.component_id;

    for (var i = 0; i < req.body.pin_count; i++) {
      await createPin(transistor_id, pin[i], sym[i], descr[i]);
    }

    aliases = data.aliases.split(',');
    for( const alias of aliases) {
      if (alias.length > 0) {
        await createAlias(transistor_id, alias.trim());
      }
    }

    res.redirect('/transistors/'+transistor_id);
  } else {
    res.render('transistor/new', {title: 'New Transistor Definition', data: data, package_types: package_types, component_sub_types: component_sub_types});
  }
});

router.post('/:id', async function(req, res) {
  const id = req.params.id;
  data = {chip_number: req.body.chip_number,
    aliases: req.body.aliases,
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

  const transistor = await updateTransistor(id, data.chip_number, data.pin_count, data.package_type_id, data.component_sub_type_id, data.datasheet, data.description);
  transistor_id = transistor.component_id;

  for (var i = 0; i < req.body.pin_count; i++) {
    await updatePin(pin_id[i], transistor_id, pin[i], sym[i], descr[i]);
  }

  await deleteAliases(transistor_id);

  aliases = data.aliases.split(',');
  for( const alias of aliases) {
    if (alias.length > 0) {
      await createAlias(transistor_id, alias.trim());
    }
  }

  res.redirect('/transistors/'+id);
});

/* GET transistor detail page. */
router.get('/:id', async function(req, res, next) {
    const id = req.params.id;
    const transistor = await getTransistor(id);
    const pins = await getPins(id);
    const dip_left_pins = await getDipLeftPins(id);
    const dip_right_pins = await getDipRightPins(id);
    const sip_pins = await getSipPins(id);
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

    if (transistor.package == 'SIP') {
      if (transistor.pin_count > 12) {
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
  
    } else if (transistor.package == 'PLCC') {
      if (transistor.pin_count > 40) {
        iswide = 'dpindiagramwide';
      }
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
    } else if ((transistor.package == 'QFN') || (transistor.package == 'QFP')) {
      if (transistor.pin_count > 40) {
        iswide = 'dpindiagramwide';
      }
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
  
    clean_notes = [];
    notes.forEach(function(note) {
      clean_notes.push(
        {id: note.id, note: parse_symbol(note.note)}
      )
    })

    res.render('transistor/detail', { title: transistor.chip_number + ' - ' + transistor.description, data: transistor, 
      pins: fixed_pins, layout_pins: layout_pins, top_pins: top_pins, bottom_pins: bottom_pins,
      specs: clean_specs, notes: clean_notes, aliases: aliases, inventory: inventory });
});
  
module.exports = router;
