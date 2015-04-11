require! {'express', Homework: '../models/homework', Submission: '../models/submission'}
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
    #if req.user.identity is 'teacher'
    Homework.find (err, hwlist) !->
      if err then return handle-error err
      res.render 'homework', {hwlist : hwlist, user: req.user}

  router.get /^\/homework\/(.*)/, is-authenticated, (req, res)!-> 
    #if req.user.identity is 'teacher'
    hw-id = req.params[0]
    Homework.find-by-id hw-id, (err, hw) !->
      if err then return handle-error err
      res.render 'detail', {hw : hw, user: req.user}

  router.get '/create', is-authenticated, (req, res)!-> res.render 'create', user: req.user

  router.post '/create', is-authenticated, (req, res)!->
    new-homework = new Homework {
      name: req.param 'name'
      startDate: req.param 'startdate'
      deadLine: req.param 'deadline'
      description: req.param 'description'
      teacherName: req.user.username
    }
    new-homework.save (err)->
      if err then return handle-error err
      console.log 'hello'
      Homework.find-by-id new-homework, (err)!->
        if err then return handle-error err
        console.log 'redirect'
        res.redirect '/homework'

  router.post '/submission', is-authenticated, (req, res)!-> 
    new-sub = new Submission {
      homeworkId: req.param 'id'
      content: req.param 'content'
      homeworkName: req.param 'hwname'
      studentName: req.user.username
      uploadDate: new Date!
    }
    new-sub.save (err)->
      if err then return handle-error err
      console.log 'hello'
      Submission.find-by-id new-sub, (err)!->
        if err then return handle-error err
        console.log 'redirect'
        res.redirect '/homework'

  router.post '/modify', is-authenticated, (req, res)!->
    Submission.update {_id:req.param 'sub_id'}, {$set:{grade: +req.param 'grade'}}, (err) !->
      res.redirect '/modify'

  router.get '/modify', is-authenticated, (req, res)!-> 
  #if req.user.identity is 'teacher'
    Submission.find (err, sublist) !->
      if err then return handle-error err
      res.render 'modify', {sublist : sublist, user: req.user}

  router.get /^\/modify\/(.*)/, is-authenticated, (req, res)!-> 
    #if req.user.identity is 'teacher'
    sub-id = req.params[0]
    Submission.find-by-id sub-id, (err, sub) !->
      if err then return handle-error err
      res.render 'submission', {sub : sub, user: req.user}

  router.get '/my-submissions', is-authenticated, (req, res)!-> 
  #if req.user.identity is 'teacher'
    Submission.find {studentName:req.user.username} (err, sublist) !->
      if err then return handle-error err
      res.render 'modify', {sublist : sublist, user: req.user}

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

