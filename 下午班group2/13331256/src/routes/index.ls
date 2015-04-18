require! {User:'../models/user', Homework:'../models/homework', 'express', moment, 'mongoose'}

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
      return (console.log "Error in finding homework: ", error ; done error) if error
      console.log 'homework page: find homework', homework
      res.render 'homework', homework: homework, user: req.user
    else
      (error, homework) <- Homework.find
      return (console.log "Error in homework: ", error ; done error) if error
      console.log 'all homework page: find homework', homework
      res.render 'homeworks', homework: homework, user: req.user

  router.get '/homework/:pid/:sid', is-authenticated, (req, res, next) !-> 
    (error, homework) <- Homework.find-by-id req.param 'pid'
    return (console.log "Error in finding homework: ", error ; done error) if error
    console.log 'homework page: find homework', homework
    res.render 'assess', homework: homework, user: req.user, sid: req.param 'sid'

  router.post '/homework/:pid/:sid', is-authenticated, (req, res, next) !-> 
    Homework.update {_id: mongoose.Types.ObjectId(req.param 'pid'), anwser: {$elemMatch: {id: mongoose.Types.ObjectId(req.param 'sid')}}}, {$set: {"anwser.$.assess": req.param 'assess'}}, {new: true}, (err) ->
      if err
        console.log 'homework update: error when update problem.', err
      else
        console.log  'homework update: update problem success'

    User.update {_id: mongoose.Types.ObjectId(req.param 'sid'), problem: {$elemMatch: {id: mongoose.Types.ObjectId(req.param 'pid')}}}, {$set: {"problem.$.assess": req.param 'assess'}}, {new: true}, (err) ->
      if err
        console.log 'homework update: error when update problem.', err
      else
        console.log  'homework update: update problem success'
    res.redirect '/home'

  router.get '/addhomework', is-authenticated, (req, res, next) !-> 
    res.render 'addhomework', user: req.user

  router.post '/addhomework', is-authenticated, (req, res, next) !-> 
    new-homework = new Homework {
      title       : req.param 'title'
      deadline    : req.param 'deadline'
      teacher     : req.user._id
      description : req.param 'description'
      answer      : []
    }
    new-homework.save (error)->
      if error
        console.log "Error in adding homework: ", error
        throw error
      else
        console.log "Add homework save success: ", new-homework
        done null, new-homework
    User.update {_id: req.user._id}, {$push:problem:{title: new-homework.title, id: new-homework._id}}, (err) ->
      if err
        console.log 'Add homework; error when update user.'
      else
        console.log  'Add homework; update user success'

    res.redirect '/home'

  router.get '/anwser/:id', is-authenticated, (req, res, next) !->
    (error, homework) <- Homework.find-by-id req.param 'id'
    return (console.log "Error in homework: ", error ; done error) if error
    console.log 'Anwser page: find homework', homework
    res.render 'anwser', homework: homework, user: req.user

  router.post '/anwser/:id', is-authenticated, (req, res, next) !->
    (error, homework) <- Homework.find-by-id req.param 'id'
    return (console.log "Error in homework: ", error ; done error) if error
    Homework.update {_id: homework._id}, {$push:anwser:{name: req.user.username, id: req.user._id, anwser: req.param 'anwser'}}, (err) ->
      if err
        console.log 'Answer: error when update problem.'
      else
        console.log  'Answer: update problem success'
    User.update {_id: req.user._id}, {$push:problem:{id: homework._id, title: homework.title, anwser: req.param 'anwser'}}, (err) ->
      if err
        console.log 'Answer: error when update user.'
      else
        console.log  'Answer: update user success'

    res.redirect '/home'

  router.post '/anwserupdate/:id', is-authenticated, (req, res, next) !->

    Homework.update {_id: mongoose.Types.ObjectId(req.param 'id'), anwser: {$elemMatch: {id: req.user._id}}}, {$set: {"anwser.$.anwser": req.param 'anwser'}}, {new: true}, (err) ->
      if err
        console.log 'Answerupdate: error when update problem.', err
      else
        console.log  'Answerupdate: update problem success'

    User.update {_id: req.user._id, problem: {$elemMatch: {id: mongoose.Types.ObjectId(req.param 'id')}}}, {$set: {"problem.$.anwser": req.param 'anwser'}}, {new: true}, (err) ->
      if err
        console.log 'Answerupdate: error when update user.', err
      else
        console.log  'Answerupdate: update user success'

    res.redirect '/home'

  router.get '/changetime/:id', is-authenticated, (req, res, next) !->
    (error, homework) <- Homework.find-by-id req.param 'id'
    return (console.log "Changetime page: Error in finding homework: ", error ; done error) if error
    console.log 'changetime page: find homework', homework
    res.render 'change', homework: homework, user: req.user

  router.post '/changetime/:id', is-authenticated, (req, res, next) !->
    (error, homework) <- Homework.find-by-id req.param 'id'
    return (console.log "Changetime page: Error in finding homework: ", error ; done error) if error
    Homework.update {_id: homework._id}, {deadline: req.param 'deadline', description: req.param 'description'}, (err) ->
      if err
        console.log 'changetime page: error when update problem.'
      else
        console.log  'changetime page: update problem success'
    
    res.redirect '/home'

