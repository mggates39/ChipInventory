var express = require('express');
var router = express.Router();
const yaml = require('js-yaml');
const fs = require('node:fs/promises');
const path = require('path');
const { searchComponents, createChip, updateChip, createCapacitor, updateCapacitor, createCapacitorNetwork, updateCapacitorNetwork,
    createResistor, updateResistor, createResistorNetwork, updateResistorNetwork, createDiode, updateDiode, createFuse, updateFuse,
    createSocket, updateSocket, createConnector, updateConnector, createCrystal, updateCrystal, createTransistor, updateTransistor, 
    lookupComponentType, lookupPickListEntryByName, 
    createPin, createAlias, createNote, createSpec, deleteComponentRelated, lookupPackageType, lookupComponentSubType } = require('../database');
  
// Read in a given file from the upload directory
async function get_file(file_name) {
    try {
        const data = await fs.readFile(file_name, { encoding: 'utf8' });
        return data;
    } catch (err) {
        console.log(err);
        return '';
    }
}
async function get_files_in_directory(dir) {
    try {
      const files = await fs.readdir(dir);
      return files;
    } catch (err) {
      console.error('Error reading directory:', err);
    }
  }
  
async function createNewComponent(component_name, data, package_type, component_type, component_sub_type) {
    var component_id = 0;
    if (component_type.name == 'IC') {
        const chip = await createChip(component_name, data.family, data.pincount, package_type.id, component_sub_type.id, data.datasheet, data.description);
        component_id = chip.component_id;

    } else if (component_type.name == 'Cap') {
        const capUnit = await lookupPickListEntryByName('Capacitance', data.units);
        const capacitor = await createCapacitor(component_name, package_type.id, component_sub_type.id, data.description, data.pincount, 
            data.capacitance, capUnit.id, data.working_voltage, data.tolerance, data.datasheet);
        component_id = capacitor.component_id;

    } else if (component_type.name == 'CN') {
        const capUnit = await lookupPickListEntryByName('Capacitance', data.units);
        const capacitor = await createCapacitorNetwork(component_name, package_type.id, component_sub_type.id, data.description, data.pincount, 
            data.capacitance, capUnit.id, data.working_voltage, data.tolerance, data/number_capacitors, data.datasheet);
        component_id = capacitor.component_id;

    } else if (component_type.name == 'Res') {
        const resUnit = await lookupPickListEntryByName('Resistance', data.units);
        const resistor = await createResistor(component_name, package_type.id, component_sub_type.id, data.description, data.pincount, 
            data.resistance, resUnit.id, data.tolerance, data.power, data.datasheet);
            component_id = resistor.component_id;

    } else if (component_type.name == 'RN') {
        const resUnit = await lookupPickListEntryByName('Resistance', data.units);
        const resistor = await createResistorNetwork(component_name, package_type.id, component_sub_type.id, data.description, data.pincount, 
            data.resistance, resUnit.id, data.tolerance, data.power, data.number_resistors, data.datasheet);
            component_id = resistor.component_id;

    } else if (component_type.name == "Diode") {
        const fvUnits = await lookupPickListEntryByName('Voltages', data.forward_units);
        const rvUnits = await lookupPickListEntryByName('Voltages', data.reverse_units);
        const lightColor = await lookupPickListEntryByName('LEDColor', data.light_color);
        const lensColor = await lookupPickListEntryByName('LensColor', data.lens_color);
        const diode = await createDiode(component_name, data.pincount, package_type.id, component_sub_type.id, data.description, 
            data.forward_voltage, fvUnits.id, data.reverse_voltage, rvUnits.id, lightColor.id, lensColor.id, data.datasheet);
        component_id = diode.component_id;
      
    } else if (component_type.name == "Fuse") {
        const ratingUnits = await lookupPickListEntryByName('FuseRating', data.rating_units);
        const voltages = await lookupPickListEntryByName('Voltages', data.voltage_units);
        const fuse = await createFuse(component_name, data.pincount, package_type.id, component_sub_type.id, 
            data.rating, ratingUnits.id, data.voltage, voltages.id, data.datasheet, data.description);
        component_id = fuse.component_id;
      
    } else if (component_type.name == "Socket") {
        const socket = await createSocket(component_name, data.pincount, package_type.id, component_sub_type.id, data.datasheet, data.description);
        component_id = socket.component_id;
                
    } else if (component_type.name == "Jack") {
        const jack = await createConnector(component_type.id, component_name, data.pincount, package_type.id, component_sub_type.id, data.datasheet, data.description);
        component_id = jack.component_id;
                
    } else if (component_type.name == "Plug") {
        const plug = await createConnector(component_type.id, component_name, data.pincount, package_type.id, component_sub_type.id, data.datasheet, data.description);
        component_id = plug.component_id;
                
    } else if (component_type.name == "Xtal") {
        const units = await lookupPickListEntryByName('Frequency', data.units);
        const crystal = createCrystal(component_name, data.frequency, units.id, data.pincount, package_type.id, component_sub_type.id, data.datasheet, data.description);
        component_id = crystal.component_id;

    } else if (component_type.name == "Transistor") {
        const usage = await lookupPickListEntryByName('TransistorUsage', data.usage);
        const power_units = await lookupPickListEntryByName('Power', data.power_units);
        const threshold_units = await lookupPickListEntryByName('Voltages', data.threshold_units);
        const transistor = await createTransistor(component_name, data.description, data.pincount, package_type.id, component_sub_type.id, 
            usage.id, data.power_rating, power_units.id, data.threshold, threshold_units.id, data.datasheet);
        component_id = transistor.component_id;

    }
    return component_id;
}

async function updateExistingComponent(component_id, component_name, data, package_type, component_type, component_sub_type) {
    if (component_type.name == 'IC') {
        await updateChip(component_id, component_name, data.family, data.pincount, package_type.id, component_sub_type.id, data.datasheet, data.description);
        
    } else if (component_type.name == 'Cap') {
        const capUnit = await lookupPickListEntryByName('Capacitance', data.units);
        await updateCapacitor(component_id, component_name, package_type.id, component_sub_type.id, data.description, data.pincount, 
            data.capacitance, capUnit.id, data.working_voltage, data.tolerance, data.datasheet);

    } else if (component_type.name == 'Cap') {
        const capUnit = await lookupPickListEntryByName('Capacitance', data.units);
        await updateCapacitorNetwork(component_id, component_name, package_type.id, component_sub_type.id, data.description, data.pincount, 
            data.capacitance, capUnit.id, data.working_voltage, data.tolerance, data.number_capacitors, data.datasheet);

    } else if (component_type.name == 'Res') {
        const resUnit = await lookupPickListEntryByName('Resistance', data.units);
        await updateResistor(component_id, component_name, package_type.id, component_sub_type.id, data.description, data.pincount, 
            data.resistance, resUnit.id, data.tolerance, data.power, data.datasheet);

    } else if (component_type.name == 'RN') {
        const resUnit = await lookupPickListEntryByName('Resistance', data.units);
        await updateResistorNetwork(component_id, component_name, package_type.id, component_sub_type.id, data.description, data.pincount, 
            data.resistance, resUnit.id, data.tolerance, data.power, data.number_resistors, data.datasheet);

    } else if (component_type.name == "Diode") {
        const fvUnits = await lookupPickListEntryByName('Voltages', data.forward_units);
        const rvUnits = await lookupPickListEntryByName('Voltages', data.reverse_units);
        const lightColor = await lookupPickListEntryByName('LEDColor', data.light_color);
        const lensColor = await lookupPickListEntryByName('LensColor', data.lens_color);
        await updateDiode(component_id, component_name, data.pincount, package_type.id, component_sub_type.id, data.description, 
            data.forward_voltage, fvUnits.id, data.reverse_voltage, rvUnits.id, lightColor.id, lensColor.id, data.datasheet);

    } else if (component_type.name == "Fuse") {
        const ratingUnits = await lookupPickListEntryByName('FuseRating', data.rating_units);
        const voltages = await lookupPickListEntryByName('Voltages', data.voltage_units);
        await updateFuse(component_id, component_name, data.pincount, package_type.id, component_sub_type.id, 
            data.rating, ratingUnits.id, data.voltage, voltages.id, data.datasheet, data.description);

    } else if (component_type.name == "Socket") {
        await updateSocket(component_id, component_name, data.pincount, package_type.id, component_sub_type.id, data.datasheet, data.description);
                
    } else if (component_type.name == "Jack") {
        await updateConnector(component_id, component_type.id, component_name, data.pincount, package_type.id, component_sub_type.id, data.datasheet, data.description);
                
    } else if (component_type.name == "Plug") {
        await updateConnector(component_id, component_type.id, component_name, data.pincount, package_type.id, component_sub_type.id, data.datasheet, data.description);

    } else if (component_type.name == "Xtal") {
        const units = await lookupPickListEntryByName('Frequency', data.units);
        await updateCrystal(component_id, component_name, data.frequency, units.id, data.pincount, package_type.id, component_sub_type.id, data.datasheet, data.description);

    } else if (component_type.name == "Transistor") {
        const usage = await lookupPickListEntryByName('TransistorUsage', data.usage);
        const power_units = await lookupPickListEntryByName('Power', data.power_units);
        const threshold_units = await lookupPickListEntryByName('Voltages', data.threshold_units);
        await updateTransistor(component_id, component_name, data.description, data.pincount, package_type.id, component_sub_type.id, 
            usage.id, data.power_rating, power_units.id, data.threshold, threshold_units.id, data.datasheet);

    }
}

async function import_component(name, data) {
    var component_type = {id: 1, name: 'IC', table_name: 'chips'};
    var package_type = {id: 1, name: 'DIP'};
    var component_sub_type = { id: null};

    if (data.type) {
        component_type = await lookupComponentType(data.type);
    }
    var component_type_id = component_type.id;

    if (data.package) {
        package_type = await lookupPackageType(component_type_id, data.package);
    }
 
    if (data.subtype) {
        component_sub_type = await lookupComponentSubType(component_type_id, data.subtype);
    } else if (data.family) {
        component_sub_type = await lookupComponentSubType(component_type_id, data.family);
    }

    var component_id = 0;
    var chip_number = name;

    if (data.name) {
        chip_number = data.name;
    }
    const components = await searchComponents(chip_number, 'p', component_type_id);
 
    if (components[0]) {
        component_id = components[0].id;
        await deleteComponentRelated(component_id);
        await updateExistingComponent(component_id, chip_number, data, package_type, component_type, component_sub_type);
    } else {
        component_id = await createNewComponent(chip_number, data, package_type, component_type, component_sub_type);
    }
  
    var pins = data.pins;
    for (const pin of pins) {
        var symbol = pin.sym;
        await createPin(component_id, pin.num, symbol, pin.desc);
    }

    aliases = data.aliases;
    if (typeof(aliases) == 'object') {
        for( const alias of aliases) {
            if (alias.length > 0) {
                await createAlias(component_id, alias.trim());
            }
        }
    }

    notes = data.notes;
    if (typeof(notes) == 'object') {
        for( const note of notes) {
            await createNote(component_id, note.trim());
        }
    }

    specs = data.specs;
    if (typeof(specs) == 'object') {
        for( const spec of specs) {
            var values = spec.val;
            var value_list = '';
            if (typeof(values) == 'object') {
                value_list = values.join('<br />')
            } else {
                value_list = values;
            }
            await createSpec(component_id, spec.param, value_list, spec.unit);
        }
    }
    return [component_type.table_name, component_id];
}

/* GET home page. */
router.get('/', async function(req, res, next) {
    const data = {
        name: '',
        yaml_file: ''
    };
    res.render('import/file_import', { title: 'Import', data: data});
  });

/* GET load all the files in the YAML folder */
router.get('/all', async function(req, res, next) {
    var dirname = './YAML/';

    files = await get_files_in_directory(dirname);
    files.forEach(async (file) => {
        const name = path.parse(file).name;
        var data = await get_file(dirname + file);
        try {
            const doc = yaml.load(data);
            [table_name, component_id] = await import_component(name, doc);
            console.log(file + ' loaded as '+table_name+' - '+component_id);
          } catch (e) {
            console.log(e);
          }
    });

    const data = {
        name: '',
        yaml_file: ''
    };
    res.render('import/file_import', { title: 'Import', data: data});
  });

/* GET home page with a file name to load. */
router.get('/:file_name', async function(req, res, next) {
    const filename = req.params.file_name;
    var file = await get_file("./upload/" + filename);
    const name = path.parse(filename).name;
    const data = {
        name: name,
        yaml_file: file
    };
    res.render('import/file_import', { title: 'Import', data: data});
  });

router.post('/new', async function(req, res, next) {
    const data = req.body.yaml_file;
    const name = req.body.name;
    try {
        const doc = yaml.load(data);
        [table_name, component_id] = await import_component(name, doc);
        res.redirect('/'+table_name+'/'+component_id);
      } catch (e) {
        console.log(e);
      }
});

module.exports = router;
