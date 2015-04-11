require! {User:'../models/user', Homework:'../models/homework', 'express'}

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

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  router.get '/homework/:id?', is-authenticated, (req, res, next) !-> 
    if req.param 'id'
      (error, homework) <- Homework.find-by-id req.param 'id'
      return (console.log "Error in homework: ", error ; done error) if error
      console.log 'homework page: find homework', homework
      res.render 'homework', homework: homework, user: req.user
    else
      (error, homework) <- Homework.find
      return (console.log "Error in homework: ", error ; done error) if error
      console.log 'homework page: find homework', homework
      res.render 'homeworks', homework: homework, user: req.user

  router.get '/addhomework', is-authenticated, (req, res, next) !-> 
    res.render 'addhomework', user: req.user

  router.post '/addhomework', is-authenticated, (req, res, next) !-> 
    new-homework = new Homework {
      title     : req.param 'title'
      deadline  : req.param 'deadline'
      teacher   : req.user._id
      answer    : []
    }
    new-homework.save (error)->
      if error
        console.log "Error in saving homework: ", error
        throw error
      else
        console.log "Homework save success: ", new-homework
        done null, new-homework
    User.update {_id: req.user._id}, {$push:problem:{title: new-homework.title, id: new-homework._id}}, (err) ->
      if err
        console.log 'error when update user.'
      else
        console.log  'update user success'

    res.redirect '/home'

  router.get '/anwser/:id', is-authenticated, (req, res, next) !->
    (error, homework) <- Homework.find-by-id req.param 'id'
    return (console.log "Error in homework: ", error ; done error) if error
    console.log 'anwser page: find homework', homework
    res.render 'anwser', homework: homework, user: req.user

  router.post '/anwser/:id', is-authenticated, (req, res, next) !->
    (error, homework) <- Homework.find-by-id req.param 'id'
    return (console.log "Error in homework: ", error ; done error) if error
    Homework.update {_id: homework._id}, {$push:anwser:{name: req.user.username, id: req.user._id, anwser: req.param 'anwser'}}, (err) ->
      if err
        console.log 'error when update problem.'
      else
        console.log  'update problem success'
    User.update {_id: req.user._id}, {$push:problem:{id: homework._id, title: homework.title, anwser: req.param 'anwser'}}, (err) ->
      if err
        console.log 'error when update user.'
      else
        console.log  'update user success'

    res.redirect '/home'
