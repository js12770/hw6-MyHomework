require! {'express', Requirement:'../models/requirement', Homework:'../models/homework'}
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

  router.get '/create', is-authenticated, (req, res)!-> res.render 'create', user: req.user

  router.post '/create' (req, res) !->
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
    res.redirect '/home'
  /* 提交作业 */
  router.get '/submit/:title', is-authenticated, (req, res)!-> 
    Requirement.find-one {Head : req.param 'title'},(err, collection) ->
      res.render 'submit', user: req.user, requirement : collection

  router.post '/submit/:title' (req, res) !->
    new-homework = new Homework {
      student  : req.user.username
      title  : req.param 'title'
      answer  : req.param 'answer'
    }
    new-homework.save (error)->
      if error
        console.log "Error in saving homework: ", error
      else
        console.log "Homework submit success"
    res.redirect '/home'
  
  /* 修改作业要求 */
  router.get '/modify/:title', is-authenticated, (req, res)!-> 
    Requirement.find-one {Head : req.param 'title'},(err, collection) ->
      res.render 'modify', user: req.user, requirement : collection

  router.post '/modify/:title' (req, res) !->
    Requirement.update { Head : req.param 'title' } , { $set:{content : req.param 'content'} }, (err, collection) ->
      res.redirect '/home'
  
  /* 重复提交作业 */
  router.get '/update/:title', is-authenticated, (req, res)!-> 
    Homework.find-one {title : req.param 'title'},(err, collection) ->
      res.render 'update', user: req.user, homework : collection

  router.post '/update/:title' (req, res) !->
    Homework.update { title : req.param 'title' } , { $set:{answer : req.param 'answer'} }, (err, collection) ->
      res.redirect '/home'

  router.get '/viewrequirement', is-authenticated, (req, res)!-> 
    Requirement.find (err, collection) ->
      res.render 'viewrequirement', user: req.user, collection: collection

  router.get '/viewhomework', is-authenticated, (req, res)!-> 
    Homework.find (err, collection) ->
      res.render 'viewhomework', user: req.user, collection: collection

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

