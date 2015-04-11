require! ['express']
require! {User:'../models/user', Problem:'../models/problem', Homework:'../models/homework'}

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
  router.get '/publish', is-authenticated, (req, res)!-> res.render 'publish', user: req.user

  router.post '/publish' (req, res) !->
    new-problem = new Problem {
      teacher  : req.user.username
      title : req.param 'title'
      ddl  : req.param 'ddl'
      content  : req.param 'content'
    }
    new-problem.save (error)->
      if error
        console.log "Error in saving requirement: ", error
      else
        console.log "Requirement publish success"
    res.redirect '/home'
  router.get '/home', is-authenticated, (req, res)!-> res.render 'home', user: req.user


  router.get '/submit/:title', is-authenticated, (req, res)!->
    Problem.find-one {title : req.param 'title'},(err, collection) ->
      res.render 'submit', user: req.user, problem : collection

  router.post '/submit/:title' (req, res) !->
    if req.user.identity == 'S'
      new-homework = new Homework {
        student  : req.user.username
        title  : req.param 'title'
        content : req.param 'content'
      }
      new-homework.save (error)->
        if error
          console.log "Error in saving homework: ", error
        else
          console.log "Homework submit success"
    else
        Problem.update {title: req.param 'title'},{$set: {content: req.param 'content'}},(err, num, raw)->
          if err
            throw err
          else
            res.redirect '/problems'
    res.redirect '/problems'

  router.get '/problems', is-authenticated, (req, res)!-> 
    Problem.find (err, collection) ->
      res.render 'problems', user: req.user, collection: collection


  router.get '/homeworks', is-authenticated, (req, res)!->
    if req.user.identity == 'T'
      Homework.find (err, collection) ->
        res.render 'homeworks', user: req.user, collection: collection
    else
      Homework.find {student: req.user.username}, (err, collection) ->
        res.render 'homeworks', user: req.user, collection: collection

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

