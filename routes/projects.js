var express = require('express');
var projectsRouter = express.Router();
const fs = require("fs");
const { parse } = require("csv-parse");
const { getProjectList, getProject, createProject, updateProject, getProjectItemsForProject, 
  getInventory, getComponentList, getInventoryList, createProjectItem, getPickListByName,
  createProjectBomItem, updateProjectBomItem, getUnprocessedProjectBomItemsForProject, getInventoryByComponentList } = require('../database');


/* GET home page. */
projectsRouter.get('/', async function(req, res, next) {
  const data = await getProjectList();
  res.render('project/list', { title: 'Projects', projects: data});
});

// Start a new Project
projectsRouter.get('/new', async function(req, res, next) {
  const data = {
    name: '',
    description: '',
    status_id: 15,
    quantity_to_build: 1
  };
  const status_list = await getPickListByName('ProjectStatus');
  res.render('project/new', {title: 'Project', project: data, status_list: status_list});
});

/* GET item page */
projectsRouter.get('/:id', async function(req, res, next) {
  const id = req.params.id;
  const data = await getProject(id);
  const project_items = await getProjectItemsForProject(id);
  const component_list = await getComponentList();
  const inventory_list = await getInventoryList();
  const project_bom = await getUnprocessedProjectBomItemsForProject(id);
  res.render('project/detail', {title: 'Project', project: data, project_items: project_items, project_bom: project_bom,
    component_list: component_list, inventory_list: inventory_list });
});
  
/* GET Edit item page */
projectsRouter.get('/edit/:id', async function(req, res, next) {
  const id = req.params.id;
  const data = await getProject(id);
  const status_list = await getPickListByName('ProjectStatus');
  res.render('project/edit', {title: 'Project', project: data, status_list: status_list});
})

projectsRouter.post('/new', async function( req, res, next) {
  const project = await createProject(req.body.name, req.body.description, req.body.status_id, req.body.quantity_to_build);
  const id = project.id
  res.redirect('/projects/'+id);
});

/* POST existing item update */
projectsRouter.post('/:id', async function( req, res, next) {
  const id = req.params.id;
  await updateProject(id, req.body.name, req.body.description, req.body.status_id, req.body.quantity_to_build);
  res.redirect('/projects/'+id);
})

projectsRouter.post('/:id/newitem/', async function(req, res, next) {
  const project_id = req.params.id;
  const project = await getProject(project_id);
  var inventory_id = req.body.inventory_id;
  const qty_needed = req.body.qty_needed;
  const total_qty = qty_needed * project.quantity_to_build;
  var qty_available = 0;
  var qty_to_order = 0;
  if (inventory_id) {
    const inv = await getInventory(inventory_id);
    if (inv.quantity > total_qty){
      qty_available = total_qty;
    } else {
      qty_available = inv.quantity;
      qty_to_order = total_qty - qty_available;
    }
    // TODO: remove it from inventory quantity on hand
  } else {
    inventory_id = null;
    qty_to_order = total_qty;
  }
  await createProjectItem(project_id, req.body.number, req.body.part_number, req.body.component_id, qty_needed, total_qty, inventory_id, qty_available, qty_to_order);
  res.redirect('/projects/'+id);
});

projectsRouter.post('/:id/bomitem/', async function(req, res, next) {
  const project_id = req.params.id;
  const project_bom_id = req.body.id;
  var inventory_id = req.body.inventory_id;
  const qty_needed = req.body.qty_needed;
  var component_id = req.body.component_id;
  if (component_id == '') {
    component_id = null;
  }
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
  } else {
    inventory_id = null;
    qty_to_order = qty_needed;
  }
  await createProjectItem(project_id, req.body.number, req.body.part_number, component_id, qty_needed, inventory_id, qty_available, qty_to_order);
  await updateProjectBomItem(project_bom_id, project_id, req.body.number, req.body.reference, qty_needed, req.body.part_number, 1);
  res.redirect('/projects/'+project_id);
});

projectsRouter.get('/inv_comp/:id', async function(req, res, next) {
  const id = req.params.id;
  const inventory_list = await getInventoryByComponentList(id);
  res.send(inventory_list);
});

async function loadBomIntoDatabase(project_id, filename) {
  fs.createReadStream("./upload/" + filename)
  .pipe(parse({ delimiter: ",", from_line: 2 }))
  .on("data", function (row) {
    line = {
      number: row[0],
      reference: row[1],
      quantity: row[2],
      part_number: row[3]
    }
    createProjectBomItem(project_id, line.number, line.reference, line.quantity, line.part_number)
  });
}

module.exports = {projectsRouter, loadBomIntoDatabase};
