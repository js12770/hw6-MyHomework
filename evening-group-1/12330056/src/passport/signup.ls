require! {User:'../models/user', 'bcrypt-nodejs', 'passport-local'}
LocalStrategy = passport-local.Strategy

hash = (password)-> bcrypt-nodejs.hash-sync password, (bcrypt-nodejs.gen-salt-sync 10), null

module.exports = (passport)!-> passport.use 'signup',  new LocalStrategy pass-req-to-callback: true, (req, username, password, done)!->
  (error, user) <- User.find-one {username: username} 
  return (console.log "Error in signup: ", error ; done error) if error

  role = req.param("isTeacher")
  if user
    console.log msg = "User: #{username} already exists"
    done null, false, req.flash 'message', msg
  else if role isnt 't' and role isnt 's' and role isnt 'T' and role isnt 'S'
    console.log msg = "Invalid Role"
    done null, false, req.flash 'message', msg
  else
    isTeacher = role is "t" or role is 'T'
    new-user = new User {
      isTeacher : isTeacher
      username  : username
      password  : hash password
      email     : req.param 'email'
      firstName : req.param 'firstName'
      lastName  : req.param 'lastName'
    } 
    new-user.save (error)->
      if error
        console.log "Error during saving user: ", error
        throw error
      else
        console.log "User registration success"
        done null, new-user 
