(function(){
  var User, bcryptNodejs, passportLocal, LocalStrategy, hash;
  User = require('../models/user');
  bcryptNodejs = require('bcrypt-nodejs');
  passportLocal = require('passport-local');
  LocalStrategy = passportLocal.Strategy;
  hash = function(password){
    return bcryptNodejs.hashSync(password, bcryptNodejs.genSaltSync(10), null);
  };
  module.exports = function(passport){
    passport.use('signup', new LocalStrategy({
      passReqToCallback: true
    }, function(req, username, password, done){
      User.findOne({
        username: username
      }, function(error, user){
        var msg, isTeacher, newUser;
        if (error) {
          return console.log("Error in signup: ", error), done(error);
        }
        if (user) {
          console.log(msg = "User: " + username + " already exists");
          return done(null, false, req.flash('message', msg));
        } else if (req.param('id') !== 'teacher' && req.param('id') !== 'student') {
          console.log(msg = "Invalid id");
          return done(null, false, req.flash('message', msg));
        } else {
          isTeacher = req.param('id') === 'teacher' ? true : false;
          newUser = new User({
            isTeacher: isTeacher,
            username: username,
            password: hash(password),
            email: req.param('email'),
            firstName: req.param('firstName'),
            lastName: req.param('lastName')
          });
          return newUser.save(function(error){
            if (error) {
              console.log("Error in saving user: ", error);
              throw error;
            } else {
              console.log("User registration success");
              return done(null, newUser);
            }
          });
        }
      });
    }));
  };
}).call(this);
