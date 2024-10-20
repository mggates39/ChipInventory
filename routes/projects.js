var express = require('express');
var router = express.Router();
const { getProjectList, getProject, createProject, updateProject, getProjectItemsForProject, 
  getInventory, getComponentList, getInventoryList, createProjectItem, getPickListByName } = require('../database');


/* GET home page. */
router.get('/', async function(req, res, next) {
  const data = await getProjectList();
  res.render('project/list', { title: 'Projects', projects: data});
});

// Start a new Project
router.get('/new', async function(req, res, next) {
  const data = {
    name: '',
    description: '',
    status_id: 9
  };
  const status_list = await getPickListByName('ProjectStatus');
  res.render('project/new', {title: 'Project', project: data, status_list: status_list});
});

/* GET item page */
router.get('/:id', async function(req, res, next) {
  const id = req.params.id;
  const data = await getProject(id);
  const project_items = await getProjectItemsForProject(id);
  const component_list = await getComponentList();
  const inventory_list = await getInventoryList();
  res.render('project/detail', {title: 'Project', project: data, project_items: project_items, 
    component_list: component_list, inventory_list: inventory_list });
});
  
/* GET Edit item page */
router.get('/edit/:id', async function(req, res, next) {
  const id = req.params.id;
  const data = await getProject(id);
  const status_list = await getPickListByName('ProjectStatus');
  res.render('project/edit', {title: 'Project', project: data, status_list: status_list});
})

router.post('/new', async function( req, res, next) {
  const project = await createProject(req.body.name, req.body.description, req.body.status_id);
  const id = project.id
  res.redirect('/projects/'+id);
});

/* POST existing item update */
router.post('/:id', async function( req, res, next) {
  const id = req.params.id;
  await updateProject(id, req.body.name, req.body.description, req.body.status_id);
  res.redirect('/projects/'+id);
})

router.post('/:id/newitem/', async function(req, res, next) {
  const id = req.params.id;
  const inventory_id = req.body.inventory_id;
  const qty_needed = req.body.qty_needed;
  var qty_available = 0;
  var qty_to_order = 0;
  if (inventory_id) {
    const inv = await getInventory(inventory_id);
    if (inv.quantity > qty_needed){
      qty_available = qty_needed;
    } else {
      qty_available = inv.quantity;
      qty_to_order = qty_needed - qty_available;
    }
    // TODO: remove it from inventory quantity on hand
  }
  await createProjectItem(id, req.body.number, req.body.component_id, qty_needed, inventory_id, qty_available, qty_to_order);
  res.redirect('/projects/'+id);
});


module.exports = router;
