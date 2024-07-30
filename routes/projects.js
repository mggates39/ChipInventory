var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('project/list', { title: 'Projects'});
});

module.exports = router;
