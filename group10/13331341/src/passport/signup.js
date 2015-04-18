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
      var msg, newUser;
      if (error) {
        return console.log("Error in signup: ", error), done(error);
      }
      if (user) {
        console.log(msg = "User: " + username + " already exists");
        return done(null, false, req.flash('message', msg));
      } else if ((req.param('identity') != 'Teacher') && (req.param('identity') != 'Student') ||
        (req.param('lesson') != 'SE-385') && (req.param('lesson') != 'SE-386')){
        if ((req.param('identity') != 'Teacher') && (req.param('identity') != 'Student')) {
          console.log(msg1 = "Invalid Identity!\n");
        } else {msg1 = "";}
        if ((req.param('lessson') != 'SE-386') && (req.param('lesson') != 'SE-385')) {
          console.log(msg2 = "Invalid Lesson!\n");
        } else {msg2 = "";}
        return done(null, false, req.flash('message', msg1 + msg2));
      } else {
        newUser = new User({
          username: username,
          password: hash(password),
          email: req.param('email'),
          firstName: req.param('firstName'),
          lastName: req.param('lastName'),
          identity: req.param('identity'),
          lesson: req.param('lesson')
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

