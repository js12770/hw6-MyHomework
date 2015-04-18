var User, bcryptNodejs, passportLocal, LocalStrategy, isValidPassword;
User = require('../models/user');
bcryptNodejs = require('bcrypt-nodejs');
passportLocal = require('passport-local');
LocalStrategy = passportLocal.Strategy;
isValidPassword = function(user, password){
  return bcryptNodejs.compareSync(password, user.password);
};
module.exports = function(passport){
  passport.use('login', new LocalStrategy({
    passReqToCallback: true
  }, function(req, username, password, done){
    User.findOne({
      username: username
    }, function(error, user){
      var msg;
      if (error) {
        return console.log("Error in login: ", error), done(error);
      }
      if (!user) {
        console.log(msg = "Can't find user: " + username + "!\n");
        return done(null, false, req.flash('message', msg));
      } else if (!isValidPassword(user, password)) {
        console.log(msg = "Invalid password!\n");
        return done(null, false, req.flash('message', msg));
      } else if ((req.param('identity') !== user.identity) || (req.param('lesson') !== user.lesson)) {
        if (req.param('identity') !== user.identity) {
          console.log(msg1 = 'Invalid identity!\n');
        } else {msg1 = "";}
        if (req.param('lesson') !== user.lesson) {
          console.log(msg2 = 'Invalid lesson!\n');
        } else {msg2 = "";}
        return done(null, false, req.flash('message', msg1 + msg2));
      } else {
        return done(null, user);
      }
    });
  }));
};
