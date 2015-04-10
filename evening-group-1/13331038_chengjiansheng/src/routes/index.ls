require! ['express']
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

  router.get '/homework', is-authenticated, (req, res)!-> res.render 'homework', user: req.user

  router.get '/create', is-authenticated, (req, res)!-> res.render 'create', user: req.user

  router.post '/create', is-authenticated, (req, res)!->
    new-assignment = new Assignment {
      name: req.param 'name'
      startDate: string-to-date req.param 'startDate'
      deadline: string-to-date req.param 'deadline'
      teacherName: req.user.name
    }
    new-assignment.save (err)->
      if err then return handle-error err
      Assignment.find-by-id new-assignment, (err)!->
        if err then return handle-error err
        res.redirect '/'

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

