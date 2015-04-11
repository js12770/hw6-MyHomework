(function(){
  var User, bcryptNodejs, passportLocal, Homework, LocalStrategy;
  User = require('../models/user');
  bcryptNodejs = require('bcrypt-nodejs');
  passportLocal = require('passport-local');
  Homework = require('../models/homework');
  LocalStrategy = passportLocal.Strategy;
  module.exports = function(passport){
    passport.use('create', new LocalStrategy({
      passReqToCallback: true
    }, function(req, username, password, done){
      User.findOne({
        username: username
      }, function(error, user){
        var newHomework;
        newHomework = new Homework({
          username: username,
          deadline: req.param('deadline'),
          homework: req.param('homework'),
          course: req.param('course')
        });
        return newHomework.save;
      });
    }));
  };
}).call(this);
