require! {'express', Homework: '../models/homework', Submission: '../models/submission'}
router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

get-my-date = !->
  now = new Date!
  year = now.getFullYear!
  console.log year
  mon = now.getMonth!+1
  day = now.getDate!
  hr = now.getHours!
  min = now.getMinutes!
  if mon < 10
    mon = '0'+ mon.toString!
  if day < 10
    day = '0'+day.toString!
  if hr < 10
    hr = '0'+hr.toString!
  if min < 10
    min = '0'+min.toString!
  nowstr = year.toString!+'/'+mon+'/'+day+' '+hr+':'+min
  return nowstr


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
    now = get-my-date!
    Homework.find (err, hwlist) !->
      if err then return handle-error err
      res.render 'homework', {hwlist : hwlist, user: req.user, now:now}

  router.get /^\/homework\/(.*)/, is-authenticated, (req, res)!-> 
    #if req.user.identity is 'teacher'

    hw-id = req.params[0]
    now = get-my-date!
    Homework.find-by-id hw-id, (err, hw) !->
      if err then return handle-error err
      Submission.find-one {studentName: req.user.username, homeworkId:hw._id}, (error, sub)!->
        if error then return handle-error error
        res.render 'detail', {hw : hw, user: req.user, sub : sub, now : now}
        console.log sub

  router.get '/create', is-authenticated, (req, res)!-> res.render 'create', user: req.user

  router.post '/create', is-authenticated, (req, res)!->
    Homework.find {_id: req.param 'hwid'}, (err, hw) !->
      if err then return handle-error err
      if hw.length != 0
        console.log hw
        console.log req.param 'startdate'
        Homework.update {_id : req.param 'hwid'}, {$set:{name: req.param('name'), startDate: req.param('startdate'), deadLine: req.param('deadline'), description: req.param('description')}}, (err) !->
          if err then return handle-error err
          res.redirect '/homework'
      else
        console.log 'comedown'
        new-homework = new Homework {
          name: req.param 'name'
          startDate: req.param 'startdate'
          deadLine: req.param 'deadline'
          description: req.param 'description'
          teacherName: req.user.username
        }
        new-homework.save (err)->
          if err then return handle-error err
          Homework.find-by-id new-homework, (err)!->
            if err then return handle-error err
            res.redirect '/homework'

  router.post '/submission', is-authenticated, (req, res)!-> 
    Submission.find {studentName:req.user.username, homeworkId:req.param 'id'}, (err, sub) !->
      if err then return handle-error err
      if sub.length != 0
        console.log 'what?'
        Submission.update {studentName: req.user.username, homeworkId: req.param 'id'}, {$set:{content: req.param 'content'}}, (err) !->
          if err then return handle-error err
          res.redirect '/modify'
      else
        console.log req.param 'hwddl'
        new-sub = new Submission {
          homeworkId: req.param 'id'
          content: req.param 'content'
          homeworkName: req.param 'hwname'
          homeworkDeadline : req.param 'hwddl'
          studentName: req.user.username
          uploadDate: get-my-date!
        }
        new-sub.save (err)->
          if err then return handle-error err
          Submission.find-by-id new-sub, (err)!->
            if err then return handle-error err
            res.redirect '/modify'

  router.post '/modify', is-authenticated, (req, res)!->
    if req.user.identity == 'teacher'
      Submission.update {_id:req.param 'sub_id'}, {$set:{grade: +req.param 'grade'}}, (err) !->
        res.redirect '/modify'

  router.get '/modify', is-authenticated, (req, res)!-> 
  #if req.user.identity is 'teacher'
    Submission.find (err, sublist) !->
      if err then return handle-error err
      res.render 'modify', {sublist : sublist, user: req.user}

  router.get /^\/modify\/(.*)/, is-authenticated, (req, res)!-> 
    #if req.user.identity is 'teacher'
    now = get-my-date!
    sub-id = req.params[0]
    Submission.find-by-id sub-id, (err, sub) !->
      if err then return handle-error err
      res.render 'submission', {sub : sub, user: req.user, now : now}

  router.get '/my-submissions', is-authenticated, (req, res)!-> 
  #if req.user.identity is 'teacher'
    Submission.find {studentName:req.user.username} (err, sublist) !->
      if err then return handle-error err
      res.render 'modify', {sublist : sublist, user: req.user}

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

