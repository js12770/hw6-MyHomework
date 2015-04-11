require! ['express']
router = express.Router! 

allAssignments = require 'mongoose' .model 'Assignment'

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
    allAssignments.find  (err, docs)!->
      res.render 'home', user: req.user, assignment: docs


  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

