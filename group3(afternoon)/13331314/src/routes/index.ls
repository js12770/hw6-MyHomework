require! {'express', Requirement:'../models/requirement', Homework:'../models/homework'}
router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

module.exports = (passport)->
  router.get '/', (req, res)!-> res.render 'index', message: req.flash 'message'

  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/home', failure-redirect: '/', failure-flash: true
  }

  router.get '/signup', (req, res)!-> res.render 'register', message: req.flash 'message'

  router.get '/home', is-authenticated, (req, res)!->
      Requirement.find (err, collection) ->
        res.render 'home', user: req.user, requirements : collection

  router.get '/homework', is-authenticated, (req, res)!->
      Requirement.find-one {_id : req.param 'hid'}, (err, collection) ->
        res.render 'homeworkDetail', user : req.user, homework : collection

  router.get '/publish', is-authenticated, (req,res)!->
    res.render 'publish', user: req.user

  router.get '/update', is-authenticated, (req, res)!->
    todelete = req.param 'opertion'
    if todelete == 'delete'
      Requirement.remove {_id : req.param 'hid'}, (err, collection)->
        res.redirect '/management'
    id = req.param 'hid'
    Requirement.find-one {_id : id}, (err, collection) ->
      res.render 'update', user: req.user, requirement : collection

  router.post '/update', is-authenticated, (req,res)!->
    requirement = req.param 'requirement'
    requirement = requirement.replace(/\r\n/g,"<br>") 
    Requirement.update { _id : req.param 'hid' } , { $set:{requirement: requirement}}, (err, collection) ->
      res.redirect '/management'

  router.post '/publish', is-authenticated, (req, res)!->
    requirement = req.param 'requirement';
    requirement = requirement.replace(/\r\n/g,"<br>") 
    new-publish = new Requirement {
        teacher: req.user.username
        question: req.param 'question'
        requirement: requirement
        course: req.param 'course'
        deadline: req.param 'deadline'
    }
    new-publish.save (error)->
      if error
        console.log "Error index saving requirement: ", error
      else
        console.log "Requirement publish success"
        res.redirect '/home'

  router.get '/management', is-authenticated, (req,res)!->
    Requirement.find (err, collection) ->
      res.render 'manage', user : req.user, requirements : collection

  router.post '/submit', is-authenticated, (req, res)!->
    Homework.find-one {hid : req.param 'hid', username : req.user.username}, (err, collection) ->
      console.log collection 
      if collection == null
        new-homework = new Homework {
          hid: req.param 'hid'
          username: req.user.username
          answer: req.param 'submit'
          score: 'Not yet graded'
        }
        new-homework.save (error)->
          if error
            console.log "Error index saving requirement: ", error
          else
            console.log "Requirement publish success"
            res.redirect '/home'
      else
        Homework.update { _id : req.param 'hid' } , { $set:{answer: req.param 'submit'}}, (err, collection) ->
          res.redirect '/home'

  router.get '/grade' , is-authenticated, (req, res)!->
    Homework.find (err, collection) ->
      res.render 'grade', user: req.user, homeworks : collection

  router.get '/gradedetail' , is-authenticated, (req, res)!->
      Homework.find-one {_id : req.param 'hid'}, (err, collection1) ->
        Requirement.find-one {_id : collection1.hid} (err, collection2)->
          res.render 'gradeDetail', user : req.user, homework : collection1, requirement : collection2

  router.post '/gradedetail', is-authenticated, (req,res)!->
    Homework.update { _id : req.param 'hid' } , { $set:{grade: req.param 'grade'}}, (err, collection) ->
      res.redirect 'grade'

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'
