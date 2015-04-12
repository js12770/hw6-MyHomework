require! {User:'../models/user', 'bcrypt-nodejs', 'passport-local'}
LocalStrategy = passport-local.Strategy

is-valid-password = (user, password)-> bcrypt-nodejs.compare-sync password, user.password

module.exports = (passport)!-> passport.use 'login',  new LocalStrategy pass-req-to-callback: true, (req, username, password, done)!->
  (error, user) <- User.find-one {username: username} 
  return (console.log "Error in login: ", error ; done error) if error

  if not user
    console.log msg = "找不到用户: #{username}"
    done null, false, req.flash 'message', msg
  else if not is-valid-password user, password
    console.log msg = "无效的密码"
    done null, false, req.flash 'message', msg
  else
    done null, user, req.flash 'message', "登陆成功"