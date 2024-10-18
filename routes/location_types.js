var express = require('express');
var router = express.Router();
const {getLocationTypeList, getLocationType, createLocationType, updateLocationType} = require('../database');

/* GET home page. */
router.get('/', async function(req, res, next) {
  const data = await getLocationTypeList();
  res.render('location_type/list', { title: 'Location Types', location_types: data });
});

// GET new location type page
router.get('/new', async function(req, res, next) {
  const data = {name: '',
    description: '',
    tag: ''
  };
  res.render('location_type/new', {title: 'Location Type', location_type: data});
})

/* GET item page */
router.get('/:id', async function(req, res, next) {
  const id = req.params.id;
  const data = await getLocationType(id);
  res.render('location_type/detail', {title: 'Location Type', location_type: data});
});

router.get('/edit/:id', async function(req, res, next) {
  const id = req.params.id;
  const data = await getLocationType(id);
  res.render('location_type/edit', {title: 'Location Type', location_type: data});
})

router.post('/new', async function( req, res, next) {
  const location_type = await createLocationType(req.body.name, req.body.description, req.body.tag);
  const id = location_type.id
  res.redirect('/location_types/'+id);
});

router.post('/:id', async function( req, res, next) {
  const id = req.params.id;
  await updateLocationType(id, req.body.name, req.body.description, req.body.tag);
  res.redirect('/location_types/'+id);
})

module.exports = router;
