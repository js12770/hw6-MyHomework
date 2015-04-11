require! {'express', Homework:'../models/homework'}
router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

module.exports = (passport)->
  router.get '/', (req, res)!-> res.render 'index', message: req.flash 'message'

  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/tell', failure-redirect: '/', failure-flash: true
  }

  router.get '/signup', (req, res)!-> res.render 'register', message: req.flash 'message'

  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: '/tell', failure-redirect: '/signup', failure-flash: true
  }


  #route for tell teacher or student
  router.get '/tell', (req, res) !->
    if req.user.category == 'teacher'
      res.redirect '/teacher'
    else
      res.redirect '/student'

  router.get '/teacher', is-authenticated, (req, res)!-> res.redirect '/showhw'
  router.get '/student', is-authenticated, (req, res)!-> res.redirect '/unfinish'

  #router for base
  router.get '/signout', (req, res) !-> res.render 'index'

  #router for teacher
  router.get '/publish', is-authenticated, (req, res) !-> res.render 'publish', user:req.user

  router.get '/showhw', is-authenticated, (req, res) !->
    d = new Date()
    if d.getMonth! < 10 then month = '0' + (d.getMonth! + 1) else month = d.getMonth! + 1
    if d.getDate! < 10 then day = '0' + d.getDate! else day = d.getDate!
    if d.getHours! < 10 then hour = '0' + d.getHours! else hour = d.getHours!
    if d.getMinutes! < 10 then minute = '0' + d.getMinutes! else minute = d.getMinutes!
    nowtime = d.getFullYear! + '-' + month + '-' + day + ' ' + hour + ':' + minute;
    #create nowtime
    #nowtime = d.getFullYear! + '-' +(d.getMonth! + 1) + '-' + d.getDate! + ' ' + d.getHours! + ':' + d.getMinutes!
    console.log(nowtime)
    Homework.find {$and : [
      {createid : req.user._id},
      {ddl : {$gte: nowtime}}
      ]}, (error, homework) !->
        res.render 'showhw', user:req.user, hw:homework
  
  router.get '/correcthw', is-authenticated, (req, res) !->
    d = new Date()
    if d.getMonth! < 10 then month = '0' + (d.getMonth! + 1) else month = d.getMonth! + 1
    if d.getDate! < 10 then day = '0' + d.getDate! else day = d.getDate!
    if d.getHours! < 10 then hour = '0' + d.getHours! else hour = d.getHours!
    if d.getMinutes! < 10 then minute = '0' + d.getMinutes! else minute = d.getMinutes!
    nowtime = d.getFullYear! + '-' + month + '-' + day + ' ' + hour + ':' + minute;
    #create nowtime
    #tell the month
    #nowtime = d.getFullYear! + '-' +(d.getMonth! + 1) + '-' + d.getDate! + ' ' + d.getHours! + ':' + d.getMinutes!
    console.log(nowtime)
    Homework.find {$and : [
      {createid : req.user._id},
      {ddl : {$lte : nowtime}}
      ]}, (error, homework) !->
        res.render 'correcthw', user:req.user, hw:homework

  router.post '/publish', (req, res) !->
    new-hw = new Homework {
      createid: req.user._id
      coursename  : req.param 'coursename'
      createby : req.param 'createby'
      ddl : (req.param 'date') + ' ' + (req.param 'time')
      command : req.param 'command'
    }
    new-hw.save (error)->
      if error
        console.log "Error in publishing homework: ", error
        throw error
      else
        console.log "User publish homework success"
        res.redirect '/showhw'

  #end of route for teacher

  #router for student
  router.get '/unfinish', is-authenticated, (req, res) !->
    d = new Date()
    if d.getMonth! < 10 then month = '0' + (d.getMonth! + 1) else month = d.getMonth! + 1
    if d.getDate! < 10 then day = '0' + d.getDate! else day = d.getDate!
    if d.getHours! < 10 then hour = '0' + d.getHours! else hour = d.getHours!
    if d.getMinutes! < 10 then minute = '0' + d.getMinutes! else minute = d.getMinutes!
    nowtime = d.getFullYear! + '-' + month + '-' + day + ' ' + hour + ':' + minute;
    Homework.find {ddl : {$gte: nowtime}}, (error, homework) !->
        res.render 'student_unfinish', user:req.user, hw:homework

  router.get '/finish', is-authenticated, (req, res) !->
    d = new Date()
    if d.getMonth! < 10 then month = '0' + (d.getMonth! + 1) else month = d.getMonth! + 1
    if d.getDate! < 10 then day = '0' + d.getDate! else day = d.getDate!
    if d.getHours! < 10 then hour = '0' + d.getHours! else hour = d.getHours!
    if d.getMinutes! < 10 then minute = '0' + d.getMinutes! else minute = d.getMinutes!
    nowtime = d.getFullYear! + '-' + month + '-' + day + ' ' + hour + ':' + minute;
    Homework.find {ddl : {$lte: nowtime}}, (error, homework) !->
        res.render 'student_finish', user:req.user, hw:homework


  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'


