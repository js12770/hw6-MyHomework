# require! ['express', "./../passport/publish_homework"]

require! {express:'express', work: "./../passport/publish_homework", Homework: "../models/homework"}

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
    Homework.find {}, (error, homeworks)!->
      if error
        res.redirect '/'
      else
        console.log homeworks
        res.render 'home', user: req.user, homeworks: homeworks

  router.post '/publish_homework', is-authenticated, (req, res)!->
    work req, res, -> res.redirect '/home'


  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

