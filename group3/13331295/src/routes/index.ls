require! {'express', User:'../models/user', Homework:'../models/homework'}
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
    if req.user.identity is 'Teacher'
      res.render 'home_for_teacher', user: req.user
    else
      res.render 'home_for_student', user: req.user

  router.get '/create_homework', is-authenticated, (req, res)!-> res.render 'create_homework'

  router.post '/create_homework', is-authenticated, (req, res)!->
    date = req.param 'homework-deadline-date'
    time = req.param 'homework-deadline-time'
    deadline = date + ' ' + time
    new-homework = new Homework {
      teacherName: req.user.username
      homeworkName: req.param 'new-homework'
      homeworkDemand: req.param 'new-homework-demand'
      homeworkDeadline: deadline
    }
    new-homework.save (error)->
      if error
        console.log "Error in creating homework: ", error
        throw error
      else
        console.log "Create homework success"
        res.redirect '/home'

  router.get '/view_all_homework', is-authenticated, (req, res)!->
    Homework.find {teacherName: req.user.username}, (error, all_homework) !->
      res.render 'view_all_homework', homeworks: all_homework

  router.get '/homework-list', is-authenticated, (req, res)!->
    Homework.find (error, all_homework) !->
      res.render 'homework-list', homeworks: all_homework

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'
