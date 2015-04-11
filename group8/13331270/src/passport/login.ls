require! {'bcrypt-nodejs', 'passport-local', User: '../models/user'}
LocalStrategy = passport-local.Strategy

is-valid-password = (user, password)-> bcrypt-nodejs.compare-sync password, user.password

module.exports = (passport)!-> passport.use 'login',  new LocalStrategy pass-req-to-callback: true, (req, username, password, done)!->
  User.find-one {username: username, role: req.param 'role'}, (error, user)!->
    return (console.log "Error in login: ", error ; done error) if error

    if not user
      console.log msg = "Can't find user: #{username}, or the role of #{username} is not correct!"
      done null, false, req.flash 'message', msg
    else if not is-valid-password user, password
      console.log msg = "Invalid password"
      done null, false, req.flash 'message', msg
    else
      done null, user