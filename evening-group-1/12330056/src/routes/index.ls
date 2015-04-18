require! ['express']
require! {Homework:'../models/homework'}
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

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  router.get '/home', is-authenticated, (req, res)!->
    if req.user.isTeacher
        Homework.find {author: req.user.username, isQuestion: true}, (err, assignments)->
            Homework.find {isQuestion: false}, (err, submissions)->
                res.render 'home', user: req.user, assignments: assignments, submissions: submissions
    else
        Homework.find {isQuestion: true}, (err, assignments)->
            Homework.find {author: req.user.username, isQuestion: false}, (err, submissions)->
                res.render 'home', user: req.user, assignments: assignments, submissions: submissions

  router.post '/assign', is-authenticated, (req, res)!->
    if !req.user.isTeacher
      console.log msg = "Permission deny"
      res.render 'home', user: req.user, message: msg
    else
        Homework.count {isQuestion: true}, (err, count)->
            new-homework = new Homework {
                id: count
                content: req.param 'content'
                author: req.user.username
                deadline: new Date(req.param('deadline'))
                isQuestion: true
            }
            new-homework.save (error)->
              if error
                console.log "Error during assigning homework ", error
                throw error
              else
                console.log msg = "Assign successfully"
                res.redirect '/home'

  router.post '/updateDeadline', is-authenticated, (req, res)!->
    if !req.user.isTeacher
      console.log msg = "Permission deny"
      res.render 'home', user: req.user, message: msg
    else
        Homework.findOne {id: parseInt(req.param('assignId')), author: req.user.username, isQuestion:true}, (err, assignment)->
            if !assignment
                console.log msg = "Invalid Id or permission deny"
                res.render 'home', user: req.user, message: msg
            else
                assignment.deadline = new Date(req.param('deadline'))
                assignment.save (error)->
                  if error
                    console.log "Error during updating deadline ", error
                    throw error
                  else
                    console.log msg = "Update successfully"
                    res.redirect '/home'

  router.post '/submit', is-authenticated, (req, res)->
    if req.user.isTeacher
      console.log msg = "Permission deny"
      res.render 'home', user: req.user, message: msg
    else
        Homework.findOne {id: parseInt(req.param('assignId')), isQuestion:true}, (err, homework)->
            if !homework
                console.log msg = "Invalid id"
                res.render 'home', user: req.user, message: msg
            else
                if homework.deadline > new Date()
                    console.log "Ready to submit"
                    Homework.findOneAndUpdate {id: parseInt(req.param('assignId')), author: req.user.username, isQuestion: false}, {
                        id: parseInt(req.param 'assignId')
                        content: req.param('content')
                        author: req.user.username
                        isQuestion: false
                    }, {upsert: true}, (err, submission) ->
                            if err
                                console.log "Error during submiting homework: ", error
                            throw error
                    console.log msg = "Submit successfully"
                    res.redirect '/home'
                else
                        console.log msg = "Deadline passed"
                        res.render 'home', user: req.user, message: msg

  router.post '/grade', is-authenticated, (req, res)!->
    if !req.user.isTeacher
      console.log msg = "Permission deny"
      res.render 'home', user: req.user, message: msg
    else
        Homework.findOne {id: parseInt(req.param('assignId')), author: req.user.username, isQuestion:true }, (err, homework)->
            if !homework
                console.log msg = "Invalid id or permission deny" 
                res.render 'home', user: req.user, message: msg
            else if homework.deadline < new Date()
                Homework.findOne {id: parseInt(req.param('assignId')), author: req.param('studentName'), isQuestion: false}, (err, submission)->
                    if !submission
                        console.log msg = "Invalid id or student name"
                        res.render 'home', user: req.user, message: msg
                    else
                        submission.score = parseInt req.param('score')
                        submission.save !->
                            res.redirect '/home'
            else
                console.log msg = "Deadline hasn't passed"
                res.render 'home', user: req.user, message: msg
