<<<<<<< HEAD:group6/13331276/src/routes/index.ls
require! ['express']
=======
require! {'express', Requirement:'../models/requirement'}
>>>>>>> 8e87d8047ea9b60158d5b4011b64802f4e8a21e3:Group9/13331136/src/routes/index.ls
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

  # router.get '/home', is-authenticated, (req, res)!-> res.render 'home', user: req.user

<<<<<<< HEAD:group6/13331276/src/routes/index.ls
  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

=======
  router.get '/home', is-authenticated, (req, res)!->
    Requirement.find (error, requirement)->
      res.render 'home', requirement: requirement, user: req.user


  router.post '/home', (req, res)!->
    new-requirement = new Requirement {
      teacher  : req.user.username
      title    : req.param 'title'
      deadline : req.param 'deadline'
      text     : req.param 'text'
    }
    new-requirement.save (error)->
      if error
        console.log "Error in saving requirement: ", error
      else
        console.log "Requirement adjunction success"
        done null, new-requirement

  router.get '/submit/:title', is-authenticated, (req, res)!->
    Requirement.find-one {title : req.param 'title'}, (error, title)->
      res.render 'submit', user: req.user, title: title
  


  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'
>>>>>>> 8e87d8047ea9b60158d5b4011b64802f4e8a21e3:Group9/13331136/src/routes/index.ls
