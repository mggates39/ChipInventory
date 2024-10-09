var express = require('express');
const { getChip, createChip, updateChip, getPins, createPin, updatePin, 
  getDipLeftPins, getDipRightPins, 
  getPllcLeftPins, getPllcRightPins, getPllcTopPins, getPllcBottomPins,
  getQuadLeftPins, getQuadRightPins, getQuadTopPins, getQuadBottomPins,
  getSpecs, getNotes, getInventoryByComponentList, getPackageTypesForComponentType, getComponentTypeList,
  getAliases, createAlias, deleteAliases } = require('../database');
const {parse_symbol} = require('../utility');
var router = express.Router();

router.get('/edit/:id', async function(req,res,next) {
  const chip_id = req.params.id;

  const chip = await getChip(chip_id);
  const pins = await getPins(chip_id);
  const aliases = await getAliases(chip_id);
  const package_types = await getPackageTypesForComponentType(1);

  aliasList = "";
  sep = "";
  aliases.forEach(function(alias) {
    aliasList += (sep + alias.alias_chip_number);
    sep = ", ";
  })
  
  data = {
    id: chip_id,
    chip_number: chip.chip_number,
    aliases: aliasList,
    family: chip.family,
    package_type_id: chip.package_type_id,
    pin_count: chip.pin_count,
    datasheet: chip.datasheet,
    description: chip.description,
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

  res.render('chip/edit', {title: 'Edit Chip Definition', data: data, package_types: package_types});
})

/* GET new chip entry page */
router.get('/new', async function(req, res, next) {
  data = {chip_number: '',
    aliases: '',
    family: '',
    package_type_id: '',
    pin_count: '',
    datasheet: '',
    description: ''
  }
  const package_types = await getPackageTypesForComponentType(1);

  res.render('chip/new', {title: 'New Chip Definition', data: data, package_types: package_types});
});

router.post('/new', async function(req, res) {
  data = {chip_number: req.body.chip_number,
    aliases: req.body.aliases,
    family: req.body.family,
    package_type_id: req.body.package_type_id,
    pin_count: req.body.pin_count,
    datasheet: req.body.datasheet,
    description: req.body.description,
  }
  const package_types = await getPackageTypesForComponentType(1);
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
    const chip = await createChip(data.chip_number, data.family, data.pin_count, data.package_type_id, data.datasheet, data.description);
    chip_id = chip.id;

    for (var i = 0; i < req.body.pin_count; i++) {
      await createPin(chip_id, pin[i], sym[i], descr[i]);
    }

    aliases = data.aliases.split(',');
    for( const alias of aliases) {
      if (alias.length > 0) {
        await createAlias(chip_id, alias.trim());
      }
    }

    res.redirect('/chips/'+chip_id);
  } else {
    res.render('chip/new', {title: 'New Chip Definition', data: data, package_types: package_types});
  }
});

router.post('/:id', async function(req, res) {
  const id = req.params.id;
  data = {chip_number: req.body.chip_number,
    aliases: req.body.aliases,
    family: req.body.family,
    package_type_id: req.body.package_type_id,
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

  const chip = await updateChip(id, data.chip_number, data.family, data.pin_count, data.package_type_id, data.datasheet, data.description);
  chip_id = chip.id;

  for (var i = 0; i < req.body.pin_count; i++) {
    await updatePin(pin_id[i], chip_id, pin[i], sym[i], descr[i]);
  }

  await deleteAliases(chip_id);

  aliases = data.aliases.split(',');
  for( const alias of aliases) {
    if (alias.length > 0) {
      await createAlias(chip_id, alias.trim());
    }
  }

  res.redirect('/chips/'+id);
});

/* GET chip detail page. */
router.get('/:id', async function(req, res, next) {
    const id = req.params.id;
    const chip = await getChip(id);
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
    if (chip.package == 'PLCC') {
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
    } else if  ((chip.package == 'QFN') || (chip.package == 'QFP')) {
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

    res.render('chip/detail', { title: chip.chip_number + ' - ' + chip.description, chip: chip, 
      pins: fixed_pins, layout_pins: layout_pins, top_pins: top_pins, bottom_pins: bottom_pins,
      specs: clean_specs, notes: notes, aliases: aliases, inventory: inventory });
});

module.exports = router;
