require! {User:'../models/user', Homework:'../models/homework', Requirement:'../models/requirement','express'}
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
    if req.user.actor == 'teacher'
      Requirement.find (tid: req.user._id),(err, homework) !->
        console.log homework.length
        res.render 'home',
          user: req.user,
          homework: homework
    else if req.user.actor == 'student'
      Requirement.find (err, homework) !->
        console.log homework.length
        res.render 'home',
          user: req.user,
          homework: homework

  router.post '/home/addHw', (req, res)!->
    username = req.param 'user'
    console.log 'addHw initial'
    User.find-one {username: username} (err, user) !->
      newHw = new Requirement {
        tid : user._id
        requires : req.param 'requires'
        deadline : req.param 'deadline'
      }
      newHw.save (error)->
        if error
          console.log "Error in saving requirement: ", error
          throw error
        else
          console.log newHw.tid
          console.log "Requirement add success"

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

