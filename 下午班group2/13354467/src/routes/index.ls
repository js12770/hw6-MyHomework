require! ['express']
require! {User:'../models/user', Homework:'../models/homework', Studenthomework:'../models/studenthomework', 'bcrypt-nodejs', 'passport-local'}
router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

module.exports = (passport)->
  router.get '/', (req, res)!-> res.render 'index', message: req.flash 'message'

  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/home', failure-redirect: '/', failure-flash: true
  }

  router.get '/signup', (req, res)!-> res.render 'register', message: req.flash 'message'

  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: '/home', failure-redirect: '/signup', failure-flash: true
  }

  router.get '/home', is-authenticated, (req, res)!->
    if req.user.role is 'teacher'
      Homework.find {teacher: req.user.username}, (error, homeworks)!->
        res.render 'home-t', user: req.user, homeworks: homeworks
    else
      Homework.find (error, homeworks)!->
        res.render 'home-s', user: req.user, homeworks: homeworks

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'


  router.post '/assign', is-authenticated, (req, res)!->
    new-homework = new Homework {
      homeworkid     :  (Date.parse Date!) % 10000000000 /1000
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
    res.redirect '/home'

  router.get '/commit/:homeworkid', is-authenticated, (req, res)!->
    (error, homework) <- Homework.find-one {homeworkid : req.params.homeworkid} 
    return (console.log "Error in signup: ", error ; done error) if error

    (error, shomework) <- Studenthomework.find-one {homeworkid : req.params.homeworkid, student : req.user.username} 
    return (console.log "Error in signup: ", error ; done error) if error

    res.render 'commit', user: req.user, homework: homework, shomework: shomework

  router.post '/commit/:homeworkid', is-authenticated, (req, res)!->
    (error, shomework) <- Studenthomework.find-one {homeworkid : req.params.homeworkid, student : req.user.username} 
    return (console.log "Error in signup: ", error ; done error) if error

    if shomework
      shomework.content = req.param 'content'
      shomework.save!

    else
      new-stuenthomework = new Studenthomework {
        homeworkid     : req.params.homeworkid
        student: req.user.username
        score: '-'
        content: req.param 'content'
      } 
      new-stuenthomework.save!

    res.redirect '/home'

  router.get '/modify/:homeworkid', is-authenticated, (req, res)!->
    (error, homework) <- Homework.find-one {homeworkid : req.params.homeworkid}
    res.render 'modify', user: req.user, homework: homework

  router.post '/modify/:homeworkid', is-authenticated, (req, res)!->
    (error, homework) <- Homework.find-one {homeworkid: req.params.homeworkid} 
    return (console.log "Error in signup: ", error ; done error) if error

    homework.require = req.param 'require'
    homework.ddl =  new Date(req.param 'ddl')
    homework.save!
    res.redirect '/home'

  router.get '/check/:homeworkid', is-authenticated, (req, res)!->
    (error, shomework) <- Studenthomework.find {homeworkid : req.params.homeworkid}
    (error, homework) <- Homework.find-one {homeworkid : req.params.homeworkid}
    res.render 'check', user: req.user, homework: homework, shomework: shomework

  router.post '/check/:homeworkid/:student', is-authenticated, (req, res)!->
    (error, shomework) <- Studenthomework.find-one {homeworkid: req.params.homeworkid, student : req.params.student}

    shomework.score = req.param 'score'
    shomework.save!

    res.redirect '/check/'+req.params.homeworkid

  router.get '/details/:homeworkid', is-authenticated, (req, res)!->
    (error, shomework) <- Studenthomework.find-one {homeworkid : req.params.homeworkid, student : req.user.username}
    (error, homework) <- Homework.find-one {homeworkid : req.params.homeworkid}
    res.render 'details', user: req.user, homework: homework, shomework: shomework

  router.get '/remove/:homeworkid', is-authenticated, (req, res)!->
    (error) <- Homework.remove { homeworkid : req.params.homeworkid }
    res.redirect '/home'