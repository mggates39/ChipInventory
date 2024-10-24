var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
const upload = require('./upload');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
var componentsRouter = require('./routes/components');
var capacitorRouter = require('./routes/capacitors');
var capacitorNetworkRouter = require('./routes/capacitor-networks');
var chipsRouter = require('./routes/chips');
var connectorJackRouter = require('./routes/connector_jacks');
var connectorPlugRouter = require('./routes/connector_plugs');
var crystalRouter = require('./routes/crystals');
var diodeRouter = require('./routes/diodes');
var resistorRouter = require('./routes/resistors');
var resistorNetworkRouter = require('./routes/resistor_networks');
var socketRouter = require('./routes/sockets');
var inventoryRouter = require('./routes/inventory');
var {projectsRouter, loadBomIntoDatabase} = require('./routes/projects');
var projectItemsRouter = require('./routes/project_items');
var manufacturerRouter = require('./routes/manufacturer');
var manufacturerCodesRouter = require('./routes/manufacturer_codes');
var componentTypesRouter = require('./routes/component_types');
var componentSubTypeRouter = require('./routes/component_sub_types');
var mountingTypesRouter = require('./routes/mounting_types');
var packageTypesRouter = require('./routes/package_types');
var locationTypesRouter = require('./routes/location_types');
var locationsRouter = require('./routes/locations');
var listsRouters = require('./routes/lists');
var listEntriesRouter = require('./routes/list_entries');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);
app.use('/components', componentsRouter);
app.use('/capacitors', capacitorRouter);
app.use('/capacitor_networks', capacitorNetworkRouter);
app.use('/chips', chipsRouter);
app.use('/connector_jacks', connectorJackRouter);
app.use('/connector_plugs', connectorPlugRouter);
app.use('/crystals', crystalRouter);
app.use('/diodes', diodeRouter);
app.use('/resistors', resistorRouter);
app.use('/resistor_networks', resistorNetworkRouter);
app.use('/sockets', socketRouter);
app.use('/inventory', inventoryRouter);
app.use('/projects', projectsRouter);
app.use('/project_items', projectItemsRouter);
app.use('/manufacturers', manufacturerRouter);
app.use('/manufacturer_codes', manufacturerCodesRouter);
app.use('/component_types', componentTypesRouter);
app.use('/component_sub_types', componentSubTypeRouter);
app.use('/mounting_types', mountingTypesRouter);
app.use('/package_types', packageTypesRouter);
app.use('/location_types', locationTypesRouter);
app.use('/locations', locationsRouter);
app.use('/lists', listsRouters);
app.use('/list_entries', listEntriesRouter);

// Set up a route for file uploads

app.post("/projects/:id/upload", async function (req, res, next) {
  // Use Multer middleware to handle file upload
  upload(req, res, async function (err) {
      if (err) {
          // Handle errors during file upload
          res.send(err);
      } else {
          // Success message after a successful upload
          const project_id = req.params.id;
          await loadBomIntoDatabase(project_id, req.file.originalname);
          res.redirect('/projects/'+project_id);
      }
  });
});

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
