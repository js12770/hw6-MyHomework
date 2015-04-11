require! {User:'../models/user', 'bcrypt-nodejs', 'passport-local', Homework:'../models/homework'}

LocalStrategy = passport-local.Strategy

module.exports = (passport)!-> passport.use 'create',  new LocalStrategy pass-req-to-callback: true, (req, username, password, done)!->
  (error, user) <- User.find-one {username: username} 
  new-homework = new Homework {
    username  : username
    deadline  : req.param 'deadline'
    homework  : req.param 'homework'
    course    : req.param 'course'
  }
  new-homework.save