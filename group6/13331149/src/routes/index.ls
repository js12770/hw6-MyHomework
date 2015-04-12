require! ['express']
require! {Homework:'../models/homework'}
require! {Assignment:'../models/assignment'}
router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

upload-homework = (req, res, next)!->
  query-old-homework = {student: req.user.username, week: req.param 'week'}
  new-homework-data = {
    content: req.param 'content'
    week: req.param 'week'
    student: req.user.username
    date: new Date()
  }
  Homework.find-one query-old-homework, (err, homework)!->
    if homework
      Homework.update query-old-homework, new-homework-data, (err, homework)!->
        console.log "Homework update success", new-homework
        show-homework req, res
    else
      new-homework = new Homework new-homework-data
      new-homework.save (error)->
        if error
          console.log "Error in submit homework", error
          throw error
        else
          console.log "Homework submit success", new-homework
          show-homework req, res

show-homework = (req, res, next)!->
  if req.user.identity == 'teacher'
    query-homework-condition = {}
  else if req.user.identity == 'student'
    query-homework-condition = {student: req.user.username}

  Homework.find query-homework-condition .sort {'week':'asc'} .exec (err, homeworks)!-> 
    res.render 'homework', {
      user: req.user, homeworks: homeworks
    }

getdate = (month, day)-> date = new Date '2014', month, day

upload-assignment = (req, res, next)!->
  month = req.param 'month'
  day = req.param 'day'
  date = getdate month, day
  query-old-assignment = {week: req.param 'week'}
  new-assignment-data = {
    content: req.param 'content'
    week: req.param 'week'
    deadline: date
  }
  Assignment.find-one query-old-assignment, (err, assignment)!->
    if assignment
      Assignment.update query-old-assignment, new-assignment-data, (err, assignment)!->
        console.log "Assignment update success"
        show-assignment req, res
    else
      new-assignment = new Assignment new-assignment-data
      new-assignment.save (error)->
        if error
          console.log "Error in submit assignment", error
          throw error
        else
          console.log "Assignment submit success", new-assignment
          show-assignment req, res

show-assignment = (req, res, next)!->
  Assignment.find {}, (err, assignments)!-> 
    console.log assignments
    res.render 'assignment', {
      user: req.user, assignments: assignments
    }

Scoring = (req, res, next)!->
  week = req.param 'week'
  student = req.param 'student'
  score = req.param 'score'
  Homework.update {week: week, student: student}, {score: score}, (err, homework)!->
    if homework
        console.log "Homework scoring success"
        show-homework req, res
    else
      console.log "Homework scoring fail"
      show-homework req, res

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

  router.get '/assignment', is-authenticated, (req, res)!-> show-assignment req, res

  router.post '/assignment', is-authenticated, (req, res)!-> upload-assignment req, res

  router.get '/homework', is-authenticated, (req, res)!-> show-homework req, res

  router.post '/homework', is-authenticated, (req, res)!-> upload-homework req, res

  router.post '/homework/score', is-authenticated, (req, res)!-> Scoring req, res

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'
