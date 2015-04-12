require! {'express', User:'../models/user', Assignment:'../models/assignment'}
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

  router.get '/home', is-authenticated, (req, res)!-> res.render 'home', user: req.user

  router.get '/signout', (req, res)!->
    req.logout!
    res.redirect '/'

  router.get '/create_hw', is-authenticated, (req, res)!-> res.render 'publish'

  router.post '/create_hw', is-authenticated, (req, res)!->
    new-assignment = new Assignment {
      detail : req.param 'detail'
      deadline : req.param 'deadline'
    }
    new-assignment.save (error)->
      if error
        console.log "Error in publishing: ", error
        throw error
      else
        console.log "Publishing success"
        res.redirect '/home'

  router.get '/submit_hw', is-authenticated, (req, res)!-> res.render 'submit'

  router.post '/submit_hw', is-authenticated, (req, res)!->

  router.get '/listAllAssignments', is-authenticated, (req, res)!->
    Assignment.find (error, all_assignments) !->
      res.render 'allAssignments', assignments: all_assignments