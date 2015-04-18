var express = require('express');
var http = require('http');
var path = require('path');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var mongoose = require('mongoose');
var passport = require('passport');
var expressSession = require('express-session');
var logger = require('morgan');
var flash = require('connect-flash');
var favicon = require('static-favicon');
var app = express();
var server = http.createServer(app);
var dbUrl = 'mongodb://localhost/ExpressJS-HW6';

mongoose.connect(dbUrl);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(favicon());
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded());
app.use(cookieParser());
app.use(express['static'](path.join(__dirname, 'public')));
app.use(expressSession({
  secret: 'mySecretKey'
}));
app.use(passport.initialize());
app.use(passport.session());
app.use(flash());
var initPassport = require('./passport/init');
initPassport(passport);
var routes = require('./routes/index')(passport);
app.use('/', routes);
app.use(function(req, res, next){
  var err;
  err = new Error('Not Found');
  err.status = 404;
  return next(err);
});

if (app.get('env') === 'development') {
  app.use(function(err, req, res, next){
    res.status(err.status || 500);
    return res.render('error', {
      message: err.message,
      error: err
    });
  });
}

exports = module.exports = server;
exports.use = function(){
  return app.use.apply(app, arguments);
};

