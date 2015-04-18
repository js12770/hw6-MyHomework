require! {'express', Task: '../models/task', Submission: '../models/submission'}
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

  router.get '/homework', is-authenticated, (req, res)!-> 
    Task.find (err, tasklist) !->
      if err then return handle-error err
      if req.user.identity is 'teacher'
        res.render 'tasktea', {tasklist : tasklist}
      else
        res.render 'taskstu', {tasklist : tasklist}

  router.get '/create', is-authenticated, (req, res)!-> res.render 'create'

  router.post '/create', is-authenticated, (req, res)!->
    new-task = new Task {
      name: req.param 'taskname'
      startdate: req.param 'start-date'
      deadline: req.param 'dead-line'
      detail: req.param 'detail'
    }
    new-task.save (error)->
      if error
        console.log "Error in saving task: ", error
        throw error
      else
        res.redirect '/homework'
  
  router.get '/^\/submission\/(.*)/', is-authenticated, (req, res)!->
    Submission.find {student:req.user.username} (err, sublist) !->
      if err then return handle-error err
      res.render 'submission', sublist : sublist


  router.get '/upload', is-authenticated, (req, res)!-> res.render 'upload'

  router.post '/upload', is-authenticated, (req, res)!->
    new-sub = new Submission {
      detail: req.param 'detail'
      task: req.param 'hwname'
      student: req.user.username
      handdate: new Date!
      grade:'no score'
    }
    new-sub.save (error)->
      if error
        console.log "Error in saving submission: ", error
        throw error
      else
        res.redirect '/homework'

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

