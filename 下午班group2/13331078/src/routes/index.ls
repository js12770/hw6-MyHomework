require! {'express', Homework:'../models/homework', Announcement:'../models/announcement'}
router = express.Router! 
db = require './db-arrangement'

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

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  router.get '/home', is-authenticated, db.find-all-announcements-at-home

  router.get '/hw-produce', is-authenticated, (req, res)!-> res.render 'homework-produce', user: req.user

  router.post '/hw-produce', is-authenticated, db.create-new-homework-return-to-view

  router.get '/hw-view', is-authenticated, db.find-all-homework-at-view
  
  router.get '/question/*', is-authenticated, db.find-pointed-homework-and-find-latest-answer

  router.post '/hw-answer', is-authenticated, db.create-or-update-latest-announcement-return-to-home

  router.get '/hw-modify/*/*', is-authenticated, db.find-pointed-homework-ready-to-modify
  
  router.post '/hw-content-modify', is-authenticated, db.update-homework-content-return-to-view

  router.post '/hw-ddl-modify', is-authenticated, db.update-homework-ddl-return-to-view

  router.get '/hw-check/*', is-authenticated, db.find-all-annoucements-of-pointed-homework-at-check

  router.get '/hw-grade/*/*', is-authenticated, db.find-pointed-announcement-at-grade
  
  router.post '/hw-grade/*/*', is-authenticated, db.update-announcement-grade-return-to-check