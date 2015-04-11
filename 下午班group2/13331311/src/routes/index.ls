require! {'express', 'mongoose', Assignment:'../models/assignment', Homework:'../models/homework'}
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

  router.get '/home', is-authenticated, (req, res)!->
    if req.user.career is 'Teacher'
      Assignment.find {creater : req.user.username}, (err, assignment) ->
        if err
          return handleError err

        Homework.find {}, (err, homework) ->
          if err
            return handleError err

          res.render 'home', user: req.user, AssignmentList: assignment, HomeworkList: homework
    else
      Assignment.find {}, (err, assignment) ->
        if err
          return handleError err

        Homework.find {}, (err, homework) ->
          if err
            return handleError err

          res.render 'home', user: req.user, AssignmentList: assignment, HomeworkList: homework

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  /*
   * Create new assignment
   */

  router.get '/create', is-authenticated, (req, res)!-> res.render 'create', user: req.user

  router.post '/create', is-authenticated, (req, res) !->
    if not validDateTime req.param 'deadline'
      console.log "Invalid time"
      message = 'Invalid time'
      res.render 'create', message:message
      return

    new-assignment = new Assignment {
      assignmentname     : req.param 'name'
      creater   : req.user.username
      author  : req.user.firstName + ' ' + req.user.lastName
      content  : req.param 'content'
      deadline : req.param 'deadline'
    }
    new-assignment.save (error)->
      if error
        console.log "Error in saving assignment: ", error
        throw error
      else
        console.log "Assignment creates success"
        res.redirect '/home'

  /*
   * Modify current assignment
   */

  router.get '/modify/:assignmentid', is-authenticated, (req, res)!->
    id = new mongoose.Types.ObjectId req.param 'assignmentid'
    
    Assignment.findById id, (err, assignment) ->
      if err
        return handleError err

      res.render 'modify', user: req.user, Assignment: assignment

  router.post '/modify/:assignmentid', is-authenticated, (req, res) !->
    id = new mongoose.Types.ObjectId req.param 'assignmentid'
    
    Assignment.findById id, (err, assignment) ->
      if err
        return handleError err

      assignment.deadline = req.param 'deadline'
      assignment.save (error)->
        if error
          console.log "Error in modifing deadline: ", error
          throw error
        else
          console.log "Deadline modifies success"
          res.redirect '/home'

  /*
   * Submit current assignment
   */

  router.get '/submit/:assignmentid', is-authenticated, (req, res)!->
    res.render 'submit', user: req.user, id:req.param 'assignmentid'

  router.post '/submit/:assignmentid', is-authenticated, (req, res) !->
    Homework.findOneAndUpdate {upper : req.user.username, assignmentid: req.param 'assignmentid'},
      {
        assignmentid: req.param 'assignmentid'
        upper: req.user.username
        studentName: req.user.firstName + ' ' + req.user.lastName
        content: req.param 'content'
      },
      {upsert : true},
      (err, homework) ->
        if err
          console.log "Error in submitting homework: ", error
          throw error
        else
          console.log "Homework submits success"
          res.redirect '/home'

validDateTime = (str) ->              
  if str == ""
    return false;
  
  str = str.replace(/-/g, "/");
  d = new Date str
  if (isNaN(d))
    return false;
  arr = str.split "/"

  return (parseInt arr[0], 10 == d.getFullYear!) && (parseInt arr[1], 10 == d.getMonth() + 1) && (parseInt arr[2], 10 == d.getDate!)