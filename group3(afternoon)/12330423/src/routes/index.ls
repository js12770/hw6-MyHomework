require! ['express']
require! {Class: '../models/class'}
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

  router.get '/CreateNewClass', is-authenticated, (req, res)!-> res.render 'createNewClass', user: req.user
  router.post '/CreateNewClass', is-authenticated, (req, res)!->
    (error, class_) <- Class.find-one {className: req.param 'classname'}
    return (console.log 'Error in add new class: ', error ; done error) if error
    return (console.log 'Class already exists!') if class_
    return (console.log 'You are not a teacher!') if req.user.isStudent

    new-class = new Class {
      className: req.param 'classname'
      time: req.param 'time'
      teacher: req.user.username
    }
    new-class.save (error) ->
      if error
        console.log 'Falied to save new class: ', error
        throw error
      else
        console.log 'Create new class successfully!'
        res.redirect '/home'

  router.get '/AllClasses', is-authenticated, (req, res)!->
    (error, class_) <- Class.find {teacher: req.user.username}
    console.log class_
    res.render 'allClasses', user: req.user, classes: class_
