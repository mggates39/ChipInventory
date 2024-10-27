var express = require('express');
var importRouter = express.Router();
const yaml = require('js-yaml');
const fs = require('node:fs/promises');
const path = require('path');
const { searchComponents, createChip, updateChip, createPin, createAlias, createNote, createSpec, deleteComponentRelated, lookupPackageType, lookupComponentSubType } = require('../database');
  
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

async function import_chip(name, data) {
    const component_type_id = 1;
    const package_type = await lookupPackageType(component_type_id, data.package);
    const component_sub_type = await lookupComponentSubType(component_type_id, data.family);

    const components = await searchComponents(name, 'p', component_type_id);
    var chip_id = 0;

    if (components) {
        chip_id = components[0].id;
        await deleteComponentRelated(chip_id);
        await updateChip(chip_id, name, data.family, data.pincount, package_type.id, component_sub_type.id, data.datasheet, data.description);
    } else {
        const chip = await createChip(name, data.family, data.pincount, package_type.id, component_sub_type.id, data.datasheet, data.description);
        chip_id = chip.component_id;    
    }
  
    var pins = data.pins;
    for (const pin of pins) {
        await createPin(chip_id, pin.num, pin.sym, pin.desc);
    }

    aliases = data.aliases;
    if (typeof(aliases) == 'object') {
        for( const alias of aliases) {
            if (alias.length > 0) {
                await createAlias(chip_id, alias.trim());
            }
        }
    }

    notes = data.notes;
    if (typeof(notes) == 'object') {
        for( const note of notes) {
            await createNote(chip_id, note.trim());
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
            await createSpec(chip_id, spec.param, value_list, spec.unit);
        }
    }
    return chip_id;
}

/* GET home page. */
importRouter.get('/', async function(req, res, next) {
    const data = {
        name: '',
        yaml_file: ''
    };
    res.render('imports/file_import', { title: 'Import', data: data});
  });

/* GET home page with a file name to load. */
importRouter.get('/:file_name', async function(req, res, next) {
    const filename = req.params.file_name;
    var file = await get_file("./upload/" + filename);
    const name = path.parse(filename).name;
    const data = {
        name: name,
        yaml_file: file
    };
    res.render('imports/file_import', { title: 'Import', data: data});
  });

importRouter.post('/new', async function(req, res, next) {
    const data = req.body.yaml_file;
    const name = req.body.name;
    try {
        const doc = yaml.load(data);
        console.log(name);
        console.log(doc);
        chip_id = await import_chip(name, doc);
        res.redirect('/chips/'+chip_id);
      } catch (e) {
        console.log(e);
      }
});

  module.exports = importRouter;
