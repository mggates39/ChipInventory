var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
var chipsRouter = require('./routes/chips');
var inventoryRouter = require('./routes/inventory');
var projectsRouter = require('./routes/projects');
var manufacturerRouter = require('./routes/manufacturer');
var componentTypesRouter = require('./routes/component_types');
var mountingTypesRouter = require('./routes/mounting_types');
var packageTypesRouter = require('./routes/package_types');

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
app.use('/chips', chipsRouter);
app.use('/inventory', inventoryRouter);
app.use('/projects', projectsRouter);
app.use('/manufacturers', manufacturerRouter);
app.use('/component_types', componentTypesRouter);
app.use('/mounting_types', mountingTypesRouter);
app.use('/package_types', packageTypesRouter);

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
