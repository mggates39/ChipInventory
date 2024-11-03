var express = require('express');
var router = express.Router();
const yaml = require('js-yaml');
const fs = require('node:fs/promises');
const { getComponentTypeList, searchComponents, getComponent, getPins, getSpecs, getNotes, getAliases,
    getChip, getCapacitor, getCapacitorNetwork, getResistor, getResistorNetwork, getCrystal, getConnector, getSocket, 
    getDiode, getFuse, getTransistor } = require('../database');


async function export_chip(component_id) {
    const component = await getComponent(component_id);
    const pins = await getPins(component_id);
    const specs = await getSpecs(component_id);
    const notes = await getNotes(component_id);
    const aliases = await getAliases(component_id);

    var chip_number = component.name;

    let file_name = "/files/" + chip_number.toUpperCase().replace(/[^0-9a-z]/gi, '') + ".yaml";

    component_data = {
        type: component.type,
        subtype: component.sub_type,
        name: component.name,
        description: component.description,
        package: component.package,
        pincount: component.pin_count,
    };

    if (component.type == 'IC') {
        const chip = await getChip(component_id);
        component_data['family'] = chip.family;
        component_data['datasheet'] = chip.datasheet;
    }

    if (component.type == 'Cap') {
        const cap = await getCapacitor(component_id);
        component_data['capacitance'] = cap.capacitance;
        component_data['units'] = cap.unit_label;
        component_data['working_voltage'] = cap.working_voltage;       
        component_data['tolerance'] = cap.tolerance;
        component_data['datasheet'] = cap.datasheet;
    }

    if (component.type == 'CN') {
        const cap = await getCapacitorNetwork(component_id);
        component_data['capacitance'] = cap.capacitance;
        component_data['units'] = cap.unit_label;
        component_data['working_voltage'] = cap.working_voltage;       
        component_data['tolerance'] = cap.tolerance;
        component_data['number_capacitors'] = cap.number_capacitors;
        component_data['datasheet'] = cap.datasheet;
    }

    if (component.type == 'Res') {
        const res = await getResistor(component_id);
        component_data['resistance'] = res.resistance;
        component_data['units'] = res.unit_label;
        component_data['power'] = res.power;       
        component_data['tolerance'] = res.tolerance;
        component_data['datasheet'] = res.datasheet;
    }

    if (component.type == 'RN') {
        const res = await getResistorNetwork(component_id);
        component_data['resistance'] = res.resistance;
        component_data['units'] = res.unit_label;
        component_data['power'] = res.power;       
        component_data['tolerance'] = res.tolerance;
        component_data['number_resistors'] = res.number_resistors;
        component_data['datasheet'] = res.datasheet;
    }

    if (component.type == 'Jack') {
        const xtal = await getConnector(component_id);
        component_data['datasheet'] = xtal.datasheet;
    }

    if (component.type == 'Plug') {
        const xtal = await getConnector(component_id);
        component_data['datasheet'] = xtal.datasheet;
    }

    if (component.type == 'Socket') {
        const xtal = await getSocket(component_id);
        component_data['datasheet'] = xtal.datasheet;
    }

    if (component.type == 'Xtal') {
        const xtal = await getCrystal(component_id);
        component_data['frequency'] = xtal.frequency;
        component_data['units'] = xtal.units;
        component_data['datasheet'] = xtal.datasheet;
    }

    if (component.type == 'Diode') {
        const xtal = await getDiode(component_id);
        component_data['forward_voltage'] = xtal.forward_voltage;
        component_data['forward_units'] = xtal.forward_units;
        component_data['reverse_voltage'] = xtal.reverse_voltage;
        if (xtal.reverse_units) {
            component_data['reverse_units'] = xtal.reverse_units;
        }
        component_data['light_color'] = xtal.light_color;
        component_data['lens_color'] = xtal.lens_color;
        component_data['datasheet'] = xtal.datasheet;
    }

    if (component.type == 'Fuse') {
        const fuse = await getFuse(component_id);
        component_data['rating'] = fuse.rating;
        component_data['rating_units'] = fuse.rating_units;
        component_data['voltage'] = fuse.voltage;
        component_data['voltage_units'] = fuse.voltage_units;
        component_data['datasheet'] = fuse.datasheet;
    }

    if (component.type == 'Transistor') {
        const transistor = await getTransistor(component_id);
        component_data['usage'] = transistor.usages;
        component_data['power_rating'] = transistor.power_rating;
        component_data['power_units'] = transistor.power_units;
        component_data['threshold'] = transistor.threshold;
        component_data['threshold_units'] = transistor.threshold_units;
        component_data['datasheet'] = transistor.datasheet;
    }

    if (aliases.length) {
        alias_list = [];
        for(const alias of aliases) {
            alias_list.push(alias.alias_chip_number)
        }
        component_data['aliases'] = alias_list;
    }

    pin_list = [];
    for (const pin of pins) {
        pin_list.push({num: pin.pin_number, sym: pin.pin_symbol, desc: pin.pin_description})
    }
    component_data['pins'] = pin_list;

    if (notes.length) {
        note_list = []
        for (const note of notes) {
            note_list.push(note.note);
        }
        component_data['notes'] = note_list;
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
        component_data['specs'] = spec_list
    }

    yaml_data = yaml.dump(component_data, {lineWidth: -1, flowLevel: 3});
    await fs.writeFile("./public/"+file_name, yaml_data);
    return [file_name, chip_number, yaml_data];
}

/* GET home page. */
router.get('/', async function(req, res, next) {
    const component_type_id = 0;
    const chips = await searchComponents('', 'p', component_type_id);
    const component_types = await getComponentTypeList();

    const data = {
        file_name: '',
        chip_number: '',
        component_id: '',
        component_type_id: component_type_id,
        yaml_file: ''
    };
    res.render('export/file_export', { title: 'Export selected component', data: data, chips: chips, component_types: component_types});
});

/* GET all export. */
router.get('/all', async function(req, res, next) {
    var component_type_id = req.query.component_type_id;
    if (typeof component_type_id == 'undefined') {
        component_type_id = 0;
    }
    
    const chips = await searchComponents('', 'p', component_type_id);
    const component_types = await getComponentTypeList();

    for( chip of chips) {
        await export_chip(chip.id);
    }

    const data = {
        file_name: '',
        chip_number: '',
        component_id: '',
        component_type_id: component_type_id,
        yaml_file: ''
    };
    res.render('export/file_export', { title: 'Export selected component', data: data, chips: chips, component_types: component_types});
});

router.post('/', async function(req, res, next) {
    const component_type_id = req.body.component_type_id;
    const chips = await searchComponents('', 'p', component_type_id);
    const component_types = await getComponentTypeList();

    const id = req.body.component_id;

    const [file_name, chip_number, yaml_data] = await export_chip(id);

    const data = {
        file_name: file_name,
        chip_number: chip_number.toUpperCase(),
        component_id: id,
        component_type_id: component_type_id,
        yaml_file: yaml_data
    };
    res.render('export/file_export', { title: 'Export selected component', data: data, chips: chips, component_types: component_types});
});

module.exports = router;
