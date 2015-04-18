require! {'express', Assignment: '../models/assignment', Homework: '../models/homework'}
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

  router.get '/assignment', is-authenticated, (req, res)!->
    if req.user.role is 'teacher'
      then
        Assignment.find {}, (err, docs)!->
          res.render 'assignment', user: req.user, assignment: docs
    # else
    #   Assignment.find-by-id
    # console.log 'there is  ', Assignment.count {}, (err, docs)!-> console.log err if err

  router.get '/assignment/*', is-authenticated, (req, res)!->
    ass-id = req.url.substr 12
    Assignment.find-by-id ass-id, (err, docs)!->
      res.render 'detail', user: req.user, assignment: docs

  router.get '/homework', is-authenticated, (req, res)!->
    Assignment.find {}, (err, docs)!->
      res.render 'homework', user:req.user, assignment:docs

  router.get '/homework/*', is-authenticated, (req, res)!->
    if req.user.role is 'student'
      ass-id = req.url.substr 10
      Assignment.find-by-id ass-id, (err, docs)!->
        Homework.find {assignment-id: docs._id, student-name: req.user.first-name} (err, hws)!->
          console.log "this student's homework: ", hws
          res.render 'detail', user:req.user, assignment:docs, homework: hws

  router.post '/assignment', is-authenticated, (req, res)!->
    ass = req.body.assignment
    new-assignment = new Assignment {
      ass-name: ass.name
      description: ass.description
      deadline: ass.deadline
      teacher-name: req.user.first-name
    }
    new-assignment.save (err)!->
      if err
        console.log err
      Assignment.find {}, (err, docs)!->
        res.render 'assignment', user: req.user, assignment: docs

  router.post '/homework/*', is-authenticated, (req, res)!->
    hw = req.body.homework
    ass-id = req.url.substr 10
    new-hw = new Homework {
      assignment-id: ass-id
      content: hw.description
      student-name: req.user.first-name
      grade: '-'
    }
    new-hw.save (err, ass-id)!->
      if (err)
        console.log err
      Assignment.find {}, (err, docs)!->
        res.render 'homework', user: req.user, assignment: docs

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

