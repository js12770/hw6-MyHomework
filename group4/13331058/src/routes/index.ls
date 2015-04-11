require! {'express', Requirement:'../models/requirement', Homework:'../models/homework'}
router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

get-time = ->
  time = ""
  now = new Date()
  year = now.getFullYear()
  time = time + year + '-'
  month = now.getMonth() + 1
  if month < 10
    time += '0'
  time = time + month + '-'
  day = now.getDate()
  if day < 10
    time += '0'
  time = time + day + '-'
  hours = now.getHours()
  if hours < 10
    time += '0'
  time = time + hours + ':'
  minutes = now.getMinutes()
  if minutes < 10
    time += '0'
  time = time + minutes
  return time


module.exports = (passport)->
  router.get '/', (req, res)!-> res.render 'index', message: req.flash 'message'

  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/home', failure-redirect: '/', failure-flash: true
  }

  router.get '/signup', (req, res)!-> res.render 'register', message: req.flash 'message'

  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: '/home', failure-redirect: '/signup', failure-flash: true
  }
  
  /* 主页 */
  router.get '/home', is-authenticated, (req, res)!-> 
    myDate = new Date()
    time = myDate.toLocaleString()
    res.render 'home', user: req.user, time: time

  /* 创建作业要求 */
  router.get '/create', is-authenticated, (req, res)!-> res.render 'create', user: req.user

  router.post '/create' (req, res) !->
    Requirement.find-one {Head : req.param 'Head'},(err, collection) ->
      if collection
        res.redirect '/create'
      else
        new-requirement = new Requirement {
          master  : req.user.username
          Head  : req.param 'Head'
          ddl  : req.param 'ddl'
          content  : req.param 'content'
        }
        new-requirement.save (error)->
          if error
            console.log "Error in saving requirement: ", error
          else
            console.log "Requirement publish success"
        res.redirect '/viewrequirement'

  /* 提交作业 */
  router.get '/submit/:title', is-authenticated, (req, res)!-> 
    Requirement.find-one {Head : req.param 'title'},(err, collection) ->
      Homework.find-one {student:req.user.username, title:req.param 'title'},(err, collection2) ->
        if collection2
          res.redirect '/update/' + req.param 'title'
        else
          temp = collection.ddl
          if temp > get-time!
            res.render 'submit', user: req.user, requirement : collection
          else
            myDate = new Date()
            time = myDate.toLocaleString()
            res.render 'illegal', requirement : collection, time : time

  router.post '/submit/:title' (req, res) !->
    blank = ""
    new-homework = new Homework {
      student  : req.user.username
      title  : req.param 'title'
      answer  : req.param 'answer'
      grade  : blank
    }
    new-homework.save (error)->
      if error
        console.log "Error in saving homework: ", error
      else
        console.log "Homework submit success"
    res.redirect '/viewhomework'
  
  /* 修改作业要求 */
  router.get '/modify/:title', is-authenticated, (req, res)!-> 
    Requirement.find-one {Head : req.param 'title'},(err, collection) ->
      temp = collection.ddl
      if temp > get-time!
        res.render 'modify', user: req.user, requirement : collection
      else
        myDate = new Date()
        time = myDate.toLocaleString()
        res.render 'illegal', requirement : collection, time : time

  router.post '/modify/:title' (req, res) !->
    Requirement.update { Head : req.param 'title' } , { $set:{content : req.param 'content'} }, (err, collection) ->
      res.redirect '/viewrequirement'

  /* 修改作业ddl */
  router.get '/changeddl/:title', is-authenticated, (req, res)!-> 
    Requirement.find-one {Head : req.param 'title'},(err, collection) ->
      res.render 'changeddl', user: req.user, requirement : collection

  router.post '/changeddl/:title' (req, res) !->
    Requirement.update { Head : req.param 'title' } , { $set:{ddl : req.param 'ddl'} }, (err, collection) ->
      res.redirect '/viewrequirement'
  
  /* 重复提交作业 */
  router.get '/update/:title', is-authenticated, (req, res)!-> 
    Homework.find-one {title : req.param 'title'},(err, collection) ->
      Requirement.find-one {Head : req.param 'title'},(err, collection2) ->
        temp = collection2.ddl
        if temp > get-time!
          res.render 'update', user: req.user, homework : collection
        else
          myDate = new Date()
          time = myDate.toLocaleString()
          res.render 'illegal', requirement : collection, time : time
      
  router.post '/update/:title' (req, res) !->
    Homework.update {student:req.user.username, title:req.param 'title'} , { $set:{answer : req.param 'answer'} }, (err, collection) ->
      res.redirect '/viewhomework'
  
  /* 批改作业 */
  router.get '/grade/:title', is-authenticated, (req, res)!-> 
    Homework.find-one {title : req.param 'title'},(err, collection) ->
      Requirement.find-one {Head : req.param 'title'},(err, collection2) ->
        temp = collection2.ddl
        if temp < get-time!
          res.render 'grade', user: req.user, homework : collection
        else
          myDate = new Date()
          time = myDate.toLocaleString()
          res.render 'illegal', requirement : collection2, time : time

  router.post '/grade/:title' (req, res) !->
    Homework.update { title : req.param 'title' } , { $set:{grade : req.param 'grade'} }, (err, collection) ->
      res.redirect '/viewhomework'

  router.get '/viewrequirement', is-authenticated, (req, res)!-> 
    Requirement.find (err, collection) ->
      res.render 'viewrequirement', user: req.user, collection: collection

  router.get '/viewhomework', is-authenticated, (req, res)!-> 
    Homework.find (err, collection) ->
      res.render 'viewhomework', user: req.user, collection: collection

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

