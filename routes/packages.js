var express = require('express');
var router = express.Router();
const { getPackageTypeList, getPackageType, getComponentTypesForPackageType} = require('../database');

/* GET list page. */
router.get('/', async function(req, res, next) {
    const data = await getPackageTypeList();
    res.render('package_type/list', { title: 'Package Types', package_types: data });
});

/* GET item page */
router.get('/:id', async function(req, res, nest) {
    const id = req.params.id;
    const data = await getPackageType(id);
    const comps = await getComponentTypesForPackageType(id);
    res.render('package_type/detail', {title: 'Package Type', package_type: data, component_types: comps});
});

module.exports = router;
