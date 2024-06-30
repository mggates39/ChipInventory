var express = require('express');
const { getChips, getChip, getPins } = require('../database');
var router = express.Router();

/* GET chip list page. */
router.get('/', async function(req, res, next) {
    const chips = await getChips();
  res.render('chiplist', { title: 'Chip List', chips: chips });
});

/* GET chip detail page. */
router.get('/:id', async function(req, res, next) {
    const id = req.params.id
    const chip = await getChip(id);
    const pins = await getPins(id);
  res.render('chipdetail', { title: chip.chip_number, chip: chip, pins: pins });
});

module.exports = router;
