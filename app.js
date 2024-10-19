var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
var componentsRouter = require('./routes/components');
var capacitorRouter = require('./routes/capacitors');
var capacitorNetworkRouter = require('./routes/capacitor-networks');
var chipsRouter = require('./routes/chips');
var crystalRouter = require('./routes/crystals');
var resistorRouter = require('./routes/resistors');
var resistorNetworkRouter = require('./routes/resistor_networks');
var socketRouter = require('./routes/sockets');
var inventoryRouter = require('./routes/inventory');
var projectsRouter = require('./routes/projects');
var manufacturerRouter = require('./routes/manufacturer');
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
app.use('/crystals', crystalRouter);
app.use('/resistors', resistorRouter);
app.use('/resistor_networks', resistorNetworkRouter);
app.use('/sockets', socketRouter);
app.use('/inventory', inventoryRouter);
app.use('/projects', projectsRouter);
app.use('/manufacturers', manufacturerRouter);
app.use('/component_types', componentTypesRouter);
app.use('/component_sub_types', componentSubTypeRouter);
app.use('/mounting_types', mountingTypesRouter);
app.use('/package_types', packageTypesRouter);
app.use('/location_types', locationTypesRouter);
app.use('/locations', locationsRouter);
app.use('/lists', listsRouters);
app.use('/list_entries', listEntriesRouter);

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
