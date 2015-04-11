(function(){
  var User, bcryptNodejs, passportLocal, Course, LocalStrategy, isValidPassword;
  User = require('../models/user');
  bcryptNodejs = require('bcrypt-nodejs');
  passportLocal = require('passport-local');
  Course = require('../models/course');
  LocalStrategy = passportLocal.Strategy;
  isValidPassword = function(user, password){
    return bcryptNodejs.compareSync(password, user.password);
  };
  module.exports = function(req){};
}).call(this);
