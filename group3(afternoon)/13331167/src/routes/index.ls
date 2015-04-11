require! {'express', Assignment:'../models/assignment', Homework: '../models/homework'}
router = express.Router! 
_ = require 'underscore'

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

  router.get '/home', is-authenticated, (req, res)!->
    if req.user.role is 'student'
      role = '同学'
    else if req.user.role is 'teacher'
      role = '老师'
    Assignment.fetch (err, assignments)!->
      if err
        console.log err
      res.render 'home', {
        user: req.user
        assignments: assignments
        role: role
      }

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  router.get '/create', is-authenticated, (req, res)!-> 
    res.render 'create', user: req.user

  router.get '/assignment/:id', is-authenticated, (req, res)!->
    id = req.params.id
    if req.user.role is 'teacher'
      Assignment.findById id,(err, assignment)!->
        Homework.findByAssignment assignment._id,(err, homeworks)!->
          res.render 'teacher', {
            user: req.user
            assignment: assignment
            homeworks: homeworks
          }
    if req.user.role is 'student'
      Assignment.findById id,(err, assignment)!->
        Homework.findByAssignmentAndStudent assignment._id,req.user._id,(err, homework)!->
          res.render 'student', {
            user: req.user
            assignment: assignment
            homework: homework
          }

  router.post '/assignment/new', is-authenticated, (req, res)!->
    id = req.body.assignment._id
    assignmentObj = req.body.assignment
    if id isnt undefined
      Assignment.findById id, (err, assignment)!->
        if err 
          console.log err

        _assignment = _.extend assignment, assignmentObj
        _assignment.save (err, assignment)!->
          if err 
            console.log err
          res.redirect '/assignment/' + assignment._id
    else
      _assignment = new Assignment {
        name: assignmentObj.name,
        description: assignmentObj.description,
        deadline: assignmentObj.deadline,
        teacher: req.user.firstName,
      }
      _assignment.save (err, assignment)!->
          if err 
            console.log err
          res.redirect '/assignment/' + assignment._id

  router.get '/assignment/update/:id' is-authenticated, (req, res)!->
    id = req.params.id
    if (id)
      Assignment.findById id,(err, assignment)!->
        res.render 'edit_assignment', {
          user: req.user
          assignment: assignment
        }

  router.post '/homework/new', is-authenticated, (req, res)!->
    id = req.body.homework._id
    assignment_id = req.body.assignment._id
    student_id = req.user._id
    student_name = req.user.firstName
    homeworkObj = req.body.homework
    if id isnt undefined
      Homework.findById id, (err, homework)!->
        if err
          console.log err

        _homework = _.extend homework, homeworkObj
        _homework.save (err, homework)!->
          if err
            console.log err
          res.redirect '/assignment/' + assignment_id
    else
      _homework = new Homework {
        assignment_id: assignment_id
        student_id: student_id
        student_name: student_name
        content: homeworkObj.content
      }
      _homework.save (err)!->
        if err
          console.log err
        res.redirect '/assignment/' + assignment_id

  router.get '/homework/update/:id' is-authenticated, (req, res)!->
    id = req.params.id
    if (id)
      Homework.findById id,(err, homework)!->
        res.render 'edit_homework', {
          user: req.user
          homework: homework
        }

  router.post '/homework/grade' is-authenticated, (req, res)!->
    id = req.body.homework._id
    assignment_id = req.body.assignment._id
    grade = req.body.homework.grade
    if (id)
      Homework.findById id,(err, homework)!->
        homework.grade = grade
        homework.save (err, homework)!->
          if err
            console.log err
          res.redirect '/assignment/' + assignment_id
