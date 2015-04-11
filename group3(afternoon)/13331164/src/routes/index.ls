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
      teacher  : req.user.username
      name  : req.param 'name'
      deadline  : req.param 'deadline'
      content  : req.param 'content'
    }
    new-requirement.save (error)->
      if error
        console.log "Error in saving requirement: ", error
      else
        console.log "Requirement publish success"
    res.redirect '/home'

  router.get '/submit/:name', is-authenticated, (req, res)!-> 
    Requirement.find-one {name : req.param 'name'},(err, collection) ->
      res.render 'submit', user: req.user, myrequirement : collection

  router.post '/submit/:name' (req, res) !->
    console.log 'myfindbegan'
    Homework.find {'name' : (req.param 'name'), 'student': (req.user.username)},(err, collection) ->
      console.log 'my23232' collection
      if collection.length == 0
        new-homework = new Homework {
            student  : req.user.username
            name  : req.param 'name'
            answer  : req.param 'answer'
        }
        new-homework.save (error)->
          if error
            console.log "Error in saving homework: ", error
          else
            console.log "Homework submit success"
        res.redirect '/home'
      else
        console.log 'my!!!!!' req.user.username
        console.log req.param 'name'
        console.log req.param 'answer'
        Homework.find-one {'name' : (req.param 'name'), 'student': (req.user.username)},(err, collection) ->
          console.log  collection
          conditions = {name : collection.name}
          update     = {$set : {answer : req.param 'answer'}}
          options    = {upsert : true}
          Homework.update conditions, update, options, (error) !->
            if error
              console.log "Error in saving homework: ", error
            else
              console.log "Homework submit success"
          res.redirect '/viewhomework'

    

      

  router.get '/viewrequirement', is-authenticated, (req, res)!-> 
    Requirement.find (err, collection) ->
      res.render 'viewrequirement', user: req.user, collection: collection

  router.get '/viewhomework', is-authenticated, (req, res)!-> 
    Homework.find (err, collection) ->
      res.render 'viewhomework', user: req.user, collection: collection

  router.get '/changedl/:name', is-authenticated, (req, res)!-> 
    Requirement.find-one {name : req.param 'name'},(err, collection) ->
      res.render 'changedl', user: req.user, myrequirement : collection

  router.post '/changedl/:name' (req, res) !->
    Requirement.find-one {name : req.param 'name'},(err, collection) ->
      console.log "shit", collection
      conditions = {name : collection.name}
      update     = {$set : {deadline : req.param 'deadline'}}
      options    = {upsert : true}
      Requirement.update conditions, update, options, (error) !->
        if error
          console.log "Error in saving homework: ", error
        else
          console.log collection
          console.log "Homework submit success"
    res.redirect '/viewrequirement'
  

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

