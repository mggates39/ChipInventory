var express = require('express');
var router = express.Router();
const { getProjectList } = require('../database');


/* GET home page. */
router.get('/', async function(req, res, next) {
  const data = await getProjectList();
  res.render('project/list', { title: 'Projects', projects: data});
});

module.exports = router;
