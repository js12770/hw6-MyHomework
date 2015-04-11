(function(){
  var login, signup, user, create;
  login = require('./login');
  signup = require('./signup');
  user = require('../models/user');
  create = require('./create');
  module.exports = function(passport){
    passport.serializeUser(function(user, done){
      console.log('serialize user: ', user);
      return done(null, user._id);
    });
    passport.deserializeUser(function(id, done){
      return user.findById(id, function(error, user){
        console.log('deserialize user: ', user);
        done(error, user);
      });
    });
    login(passport);
    return signup(passport);
  };
}).call(this);
