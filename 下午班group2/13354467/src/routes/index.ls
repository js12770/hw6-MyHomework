require! ['express']
require! {User:'../models/user', Homework:'../models/homework', Studenthomework:'../models/studenthomework', 'bcrypt-nodejs', 'passport-local'}
router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

module.exports = (passport)->
  router.get '/', (req, res)!-> res.render 'index', message: req.flash 'message'

  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/account', failure-redirect: '/', failure-flash: true
  }

  router.get '/signup', (req, res)!-> res.render 'register', message: req.flash 'message'

  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: '/home', failure-redirect: '/signup', failure-flash: true
  }

  router.get '/home', is-authenticated, (req, res)!-> res.render 'home', user: req.user

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  router.get '/account', is-authenticated, (req, res)!->
    (error, homework) <- Homework.find {}
    return (console.log "Error in signup: ", error ; done error) if error
    (error, studenthomework) <- Studenthomework.find {}
    return (console.log "Error in signup: ", error ; done error) if error
    res.render 'account', user: req.user, homeworks: homework, studenthomework: studenthomework

  router.get '/account', is-authenticated, (req, res)!->
    if req.user.role == 'teacher'
      (error, homework) <- Homework.find {}
      return (console.log "Error in signup: ", error ; done error) if error
      (error, studenthomework) <- Studenthomework.find {}
      return (console.log "Error in signup: ", error ; done error) if error
      res.render 'account', user: req.user, homeworks: homework, studenthomework: studenthomework
    else
      (error, studenthomework) <- Studenthomework.find {}
      return (console.log "Error in signup: ", error ; done error) if error
      (error, studenthomework) <- Studenthomework.find {student : req.user.username}
      return (console.log "Error in signup: ", error ; done error) if error
    res.render 'account', user: req.user, homeworks: homework, studenthomework: studenthomework


  router.post '/assign', is-authenticated, (req, res)!->
    (error, homework) <- Homework.find-one {homeworkid : req.homeworkid} 
    return (console.log "Error in signup: ", error ; done error) if error

    if homework
      done null, false, req.flash 'message', msg
    else
      new-homework = new Homework {
        homeworkid     : req.param 'homeworkid'
        require: req.param 'require'
        ddl: new Date(req.param 'ddl')
        teacher: req.user.username
      } 
      new-homework.save (error)->
        if error
          console.log "Error in saving homework: ", error
          throw error
        else
          console.log "Homework registration success"
          done null, new-homwork
    res.redirect '/account'

  router.post '/commit', is-authenticated, (req, res)!->
    new-stuenthomework = new Studenthomework {
      homeworkid     : req.param 'homeworkid'
      student: req.user.username
      content: req.param 'content'
    } 
    new-stuenthomework.save!
    res.redirect '/account'