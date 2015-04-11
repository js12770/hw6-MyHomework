require! ['express']
require! {Homework:'../models/homework'}
require! {HW: '../models/hw' }
router = express.Router!
is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

module.exports = (passport)->
  router.get '/', (req, res)!-> res.render 'index', message: req.flash 'message'

  router.get '/student', is-authenticated, (req, res)!->res.render 'student',user: req.user

  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/home', failure-redirect: '/', failure-flash: true
  }

  router.get '/teacher', is-authenticated, (req, res)!->res.render 'teacher',user: req.user

  router.get '/student', is-authenticated, (req, res)!->res.render 'teacher',user: req.user

  router.get '/profile', is-authenticated, (req, res)!->res.render 'profile',user: req.user

  router.get '/create', is-authenticated, (req, res)!->res.render 'create',user: req.user
  
  router.get '/signup', (req, res)!-> res.render 'register', message: req.flash 'message'

  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: '/home', failure-redirect: '/signup', failure-flash: true
  }

  router.get '/home', is-authenticated, (req, res)!-> res.render 'home', user: req.user

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  router.post '/create', is-authenticated, (req,res)!->
    new-homework = new Homework {
      deadline  : req.param 'deadline'
      homework  : req.param 'homework'
      course    : req.param 'course'
      detail    : req.param 'detail'
      author    : req.param 'author'
    }
    new-homework.save (error)->
      if error
        console.log "Error in saving user: ", error
        throw error
      else
        console.log "User registration success"
        res.redirect '/home'

  router.get '/homework', is-authenticated, (req, res)!->
    value = req.query
    hw = value['id']
    Homework.find-one { _id:hw } (err, result)->
      res.render 'change',user:req.user, homework:result

  router.get '/submit', is-authenticated, (req, res)!->
    value = req.query
    hw = value['id']
    Homework.find-one {homework:hw} (err, result)->
      res.render 'submit',user:req.user, homework:result

  router.post '/homework', is-authenticated, (req,res)!->
    Homework.findOneAndUpdate {homework:req.param 'homework'},{$set:{deadline:req.param 'deadline'}}
    Homework.findOneAndUpdate {homework:req.param 'homework'},{$set:{detail:req.param 'detail'}}
    res.redirect '/history'


  router.get '/history', is-authenticated, (req,res)!->
    history = new Date()
    year = history.getFullYear!
    month = history.getMonth!+1
    if month < 10
      month = '0'+month.toString!
    day = history.getDate!
    if day < 10
      day = '0'+day.toString!
    date = year+'-'+month+'-'+day
    Homework.find (err, result)->
      res.render 'history',user:req.user, homework: result, date:date

  router.post '/submit', is-authenticated, (req,res)!->
    new-homework = new HW {
      deadline  : req.param 'deadline'
      homework  : req.param 'homework'
      course    : req.param 'course'
      detail    : req.param 'detail'
      student    : req.param 'student'
      content   : req.param 'content'
      grade     : 0
    }
    new-homework.save (error)->
      if error
        console.log "Error in saving user: ", error
        throw error
      else
        console.log "User registration success"
        res.redirect '/home'

  router.get '/stu_homework', is-authenticated, (req,res)!->
    HW.find (err, result)->
      res.render 'hw',user:req.user, homework: result

  router.get '/my_homework', is-authenticated, (req,res)!->
    history = new Date()
    year = history.getFullYear!
    month = history.getMonth!+1
    if month < 10
      month = '0'+month.toString!
    day = history.getDate!
    if day < 10
      day = '0'+day.toString!
    date = year+'-'+month+'-'+day
    HW.find {student: req.user.username} (err, result)->
      res.render 'hw',user:req.user, homework: result, date:date


  router.get '/change', is-authenticated, (req, res)!->
    value = req.query
    hw = value['id']
    HW.find-one {_id:hw} (err, result)->
      res.render 'homework',user:req.user, homework:result

  router.get '/outofdate', is-authenticated, (req, res)!->
    value = req.query
    hw = value['id']
    HW.find-one {_id:hw} (err, result)->
      res.render 'outofdate',user:req.user, homework:result

  router.post '/change', is-authenticated, (req,res)!->
    HW.findOneAndUpdate {_update:req.param 'id'},{$set:{content:req.param 'content'}}
    res.redirect '/my_homework'

  router.get '/view', is-authenticated, (req, res)!->
    value = req.query
    hw = value['id']
    HW.find-one {_id:hw} (err, result)->
      res.render 'view',user:req.user, homework:result

  router.post '/view', is-authenticated, (req,res)!->
    HW.findOneAndUpdate {_id: req.param 'id'}, {$set:{grade:req.param 'grade'}}
    res.redirect '/stu_homework'

  router.get '/resubmit', is-authenticated, (req, res)!->
    history = new Date()
    year = history.getFullYear!
    month = history.getMonth!+1
    if month < 10
      month = '0'+month.toString!
    day = history.getDate!
    if day < 10
      day = '0'+day.toString!
    date = year+'-'+month+'-'+day
    value = req.query
    hw = value['id']
    HW.find-one {_id:hw} (err, result)->
      res.render 'view',user:req.user, homework:result, date:date

  router.post '/resubmit', is-authenticated, (req,res)!->
    HW.findOneAndUpdate {_id:req.param 'id'}, {$set:{content:req.param 'content'}}
    res.redirect '/my_homework'