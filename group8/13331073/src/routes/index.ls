require! ['express']
require! {Homework:'../models/homework'}
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
  
  router.get '/hwpage', (req, res)!->
    Homework.find {}, (error, homeworks) ->
      res.render 'hwpage', user: req.user, homeworks: homeworks

  router.post '/posthw', (req, res)!->
    if req.user.isTeacher
      new-homework = new Homework {
        HomeworkTitle: req.param 'HomeworkTitle'
        HomeworkDeadline: req.param 'HomeworkDeadline'
        HomeworkRequirement: req.param 'HomeworkRequirement'
      }
      new-homework.save (error) ->
        if error
          console.log "Error in saving homework: ", error
          throw error
        else
          console.log "Homework post success"
          res.redirect '/hwpage'
    else
      res.redirect '/home'
      console.log "only teacher can create Homework"

  router.post '/changeDeadline', (req, res)!->
    if req.user.isTeacher
      Homework.findOne {HomeworkDeadline: req.param('HomeworkDeadline')}, (err, homework)->
        homework.HomeworkDeadline = new Date(req.param('HomeworkDeadline'))
        homework.save (error) ->
          if error
            console.log "Error in saving homework: ", error
            throw error
          else
            console.log "Homework post success"
            res.redirect '/hwpage'
    else
      res.redirect '/hwpage'
      console.log "only teacher can change Deadline"
      
  router.get '/hwpage', (req, res)!-> res.render 'hwpage', message: req.flash 'message'

  router.get '/changeDeadline', (req, res)!-> res.render 'changeDeadline', message: req.flash 'message'

  router.get '/home', is-authenticated, (req, res)!-> res.render 'home', user: req.user

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'
  
  router.get '/posthw', (req, res)!-> res.render 'posthw', message: req.flash 'message'