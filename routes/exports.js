var express = require('express');
var router = express.Router();
const yaml = require('js-yaml');
const fs = require('node:fs/promises');
const { getComponentListByType, getChip, getPins, getSpecs, getNotes, getAliases } = require('../database');
  

/* GET home page. */
router.get('/', async function(req, res, next) {
    const compnent_type_id = 1;
    const chips = await getComponentListByType(compnent_type_id);
    const data = {
        file_name: '',
        chip_number: '',
        chip_id: '',
        yaml_file: ''
    };
    res.render('export/file_export', { title: 'Export selected chip', data: data, chips: chips});
});

router.post('/', async function(req, res, next) {
    const compnent_type_id = 1;
    const chips = await getComponentListByType(compnent_type_id);
    const id = req.body.chip_id;

    const chip = await getChip(id);
    const pins = await getPins(id);
    const specs = await getSpecs(id);
    const notes = await getNotes(id);
    const aliases = await getAliases(id);

    file_name = "/files/" + chip.chip_number.toUpperCase(); + ".yaml"
    chip_data = {
        name: chip.chip_number,
        description: chip.description,
        package: chip.package,
        pincount: chip.pin_count,
        family: chip.family,
        datasheet: chip.datasheet
    };

    if (aliases.length) {
        alias_list = [];
        for(const alias of aliases) {
            alias_list.push(alias.alias_chip_number)
        }
        chip_data['aliases'] = alias_list;
    }

    pin_list = [];
    for (const pin of pins) {
        pin_list.push({num: pin.pin_number, sym: pin.pin_symbol, desc: pin.pin_description})
    }
    chip_data['pins'] = pin_list;

    if (notes.length) {
        note_list = []
        for (const note of notes) {
            note_list.push(note.note);
        }
        chip_data['notes'] = note_list;
    }

    if (specs.length) {
        spec_list = [];
        for( const spec of specs) {
            if (spec.value.includes("<br />")) {
                value = spec.value.split('<br />');
            } else {
                value = spec.value;
            }
            spec_list.push({param: spec.parameter, val: value, unit: spec.unit})
        }
        chip_data['specs'] = spec_list
    }

    yaml_data = yaml.dump(chip_data, {lineWidth: -1, flowLevel: 3});
    await fs.writeFile("./public/"+file_name, yaml_data);


    const data = {
        file_name: file_name,
        chip_number: chip.chip_number.toUpperCase(),
        chip_id: id,
        yaml_file: yaml_data
    };
    res.render('export/file_export', { title: 'Export selected chip', data: data, chips: chips});
});

module.exports = router;
