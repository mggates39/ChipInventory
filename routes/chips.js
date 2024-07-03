var express = require('express');
const { getChips, getChip, getPins, getLeftPins, getRightPins, getSpecs, getNotes } = require('../database');
var router = express.Router();

/* GET chip list page. */
router.get('/', async function(req, res, next) {
    const chips = await getChips();
  res.render('chiplist', { title: 'Chip Master File', chips: chips });
});

/* GET chip detail page. */
router.get('/:id', async function(req, res, next) {
    const id = req.params.id;
    const chip = await getChip(id);
    const pins = await getPins(id);
    const left_pins = await getLeftPins(id);
    const right_pins = await getRightPins(id);
    const specs = await getSpecs(id);
    const notes = await getNotes(id);

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
    i = 0;
    left_pins.forEach(function(pin) {
      if ( i == 0) {
        bull = '&nbsp;&bull;'
      } else {
        bull = ''
      }
      layout_pins.push(
        {'left_pin': pin.pin_number, 'bull': bull, 'right_pin': right_pins[i].pin_number, 
        'left_sym': parse_symbol(pin.pin_symbol), 'right_sym': parse_symbol(right_pins[i].pin_symbol)});
      i++;
    });

    clean_specs = [];
    specs.forEach(function(spec) {
      clean_specs.push(
        {parameter: parse_symbol(spec.parameter), unit: spec.unit, value: spec.value}
      )
    })

    res.render('chipdetail', { title: chip.chip_number + '-' + chip.description, chip: chip, pins: fixed_pins, layout_pins: layout_pins, specs: clean_specs, notes: notes });
});

function parse_symbol(symbol)
{
  // process __ for subscripts
  let newsym = '';
  if (symbol.includes('__')){
    let seen = 0
    for (let i = 0; i < symbol.length; i++) {
      if (symbol[i] == '_') {
        seen++;
        if (seen == 2) {
          newsym += '<sub>';
        }
      } else if ((symbol[i] == '/' || symbol[i] == ' ') && seen == 2) {
        newsym += '</sub>';
        seen = 0;
        newsym += symbol[i];
      } else {
        newsym += symbol[i]
      }
    }
    
    if (seen == 2) {
      newsym += '</sub>';
      seen = 0;
  ``}
  } else {
    newsym = symbol;
  }

  // Process ~ for negation
  if (newsym.includes('~')) {
    let negsym = ''
    let found = false
    for (let i = 0; i < newsym.length; i++) {
      if (newsym[i] == '~') {
        found = !found;
        if (found) {
          negsym += "<span class='neg'>"
        } else {
          negsym += '</span>'
        }
      } else {
        negsym += newsym[i];
      }
    }
    if (found) {
      negsym += "</span>";
    }
    newsym = negsym;
  }
  return newsym
}
module.exports = router;
