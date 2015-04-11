require! ['express']
require! {Homeworks:'../models/homework'}
router = express.Router! 
moment = require('moment')

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

  router.get '/teacher', is-authenticated, (req, res)!->
    if req.user.role is 'student'
      res.redirect '/'
    else
    #Homeworks.create req.user, {name:'miao', content:"miaomiao"}
      Homeworks.findAll {}, (error, result)->
        if error
          res.send error
        else
          res.render 'teacher', {user: req.user, hws: result, moment: moment}
      /*res.render 'teacher', user: req.user, hw: req.homework

  router.get '/blogs', (req, res)!->
    Blogs.findAll {'age':'Age'}, (error, result)->
      if error
        res.send error
      else
        res.render 'blogs', blogs: result
*/
  router.get '/createhomework', is-authenticated, (req, res)!-> res.render 'createhomework', user: req.user

  router.post '/createhomework', is-authenticated, (req, res)!->
    Homeworks.create req.user, {
      name : req.body.name,
      requirement : req.body.requirement,
      deadline : req.body.deadline
    }
    console.log req.body.deadline.to-string
    res.redirect '/teacher'

  router.get '/student', is-authenticated, (req, res)!->
    if req.user.role is 'teacher'
      res.redirect '/'
    else
      #Homeworks.create req.user, {name:'miao', content:"miaomiao"}
      Homeworks.findAll {}, (error, result)->
        if error
          res.send error
        else
          res.render 'teacher', {user: req.user, hws: result, moment: moment}