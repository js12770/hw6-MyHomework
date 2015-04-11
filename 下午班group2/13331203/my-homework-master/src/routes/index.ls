require! {'express', User:'../models/user', Answer : '../models/answer' ,Assignment:'../models/assignment'}
router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

module.exports = (passport)->
  router.get '/', (req, res)!-> res.render 'index', message: req.flash 'message'

  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/home', failure-redirect: '/', failure-flash: true
  }

  router.get '/signup', (req, res)!-> res.render 'register'

  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: '/home', failure-redirect: '/signup', failure-flash: true
  }

  router.get '/homework', is-authenticated, (req, res)!->
    Assignment.find (err, collection1) !->
      res.render 'homework', user: req.user, collection : collection1


  router.get '/answer', is-authenticated, (req, res)!->
    Assignment.find  {Name : req.param 'item'}, (err, collection1) !->
      Answer.find (err2, collection2) !->
        res.render 'answer', user: req.user, content: collection1, anwers:collection2


  router.get '/home', is-authenticated, (req, res)!->
    Assignment.find (err, collection1) !->
      Answer.find (error, collection2)!->
        res.render 'home', user: req.user, collection : collection1, answer :collection2


  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'


  router.post '/publish',  (req, res)!->
    new-assignment= new Assignment {
      teacher : req.param 'teacher'
      deadline : req.param 'deadline'
      Content : req.param 'Content'
      Name : req.param 'Name'
    }
    new-assignment.save (error)->
      if error
        console.log "Error in saving assignment:", error
      else
        console.log "assignment publish success"
    res.redirect '/home'

  router.post '/submit',  (req, res)!->
    query = Answer.find().remove({ name :  req.param 'Name' , student : req.user.username })
    query.exec!
    new-answer = new Answer {
      student : req.user.username
      Content : req.param 'Content'
      Name : req.param 'Name'
    }
    new-answer.save (error)->
      if error
        console.log "Error in saving assignment:", error
      else
        console.log "assignment publish success"
    res.redirect '/answer?item='+req.param 'Name'



  router.post '/change',  (req, res)!->
    Assignment.update {Name : req.param 'Name' }, {$set: {
      teacher : req.param 'teacher',
      deadline : req.param 'deadline',
      Content : req.param 'Content'
    }}, (err, num, raw)->
      if err
        throw err
      else
        res.redirect '/answer?item='+req.param 'Name'
      res.redirect '/answer?item='+req.param 'Name'