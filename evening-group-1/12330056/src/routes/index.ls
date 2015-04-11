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
    Homework.find {isQuestion: true}, (err, assignments)->
        if req.user.isTeacher
            Homework.find {isQuestion: false}, (err, submissions)->
                res.render 'home', user: req.user, assignments: assignments, submissions: submissions
        else
            Homework.find {author: req.user.username}, (err, submissions)->
                res.render 'home', user: req.user, assignments: assignments, submissions: submissions

  router.post '/assign', is-authenticated, (req, res)!->
    if !req.user.isTeacher
      console.log msg = "Only teacher has the permission to assign"
      res.render 'home', user: req.user, message: msg
    else
        Homework.count {}, (err, count)->
            new-homework = new Homework {
                id: count
                content: req.param 'content'
                author: req.user.username
                deadline: new Date(req.param('deadline'))
                isQuestion: true
            }
            new-homework.save (error)->
              if error
                console.log "Error during saving homework: ", error
                throw error
              else
                console.log msg = "Assign successfully"
                res.redirect '/home'

  router.post '/changedeadline', is-authenticated, (req, res)!->
    if !req.user.isTeacher
      console.log msg = "Only teacher has the permission to change deadline"
      res.render 'home', user: req.user, message: msg
    else
        Homework.findOne {id: req.param('assignId')}, (err, assignment)->
            if !assignment
                console.log msg = "Invalid Id"
                res.render 'home', user: req.user, message: msg
            else
                assignment.deadline = new Date(req.param('deadline'))
                assignment.save (error)->
                  if error
                    console.log "Error during changing deadline: ", error
                    throw error
                  else
                    console.log msg = "Modify successfully"
                    res.redirect '/home'

  router.post '/submit', is-authenticated, (req, res)->
    if req.user.isTeacher
      console.log msg = "Only student has permission to submit"
      res.render 'home', user: req.user, message: msg
    else
        Homework.findOne {id: req.param('assignId')}, (err, homework)->
            if !homework
                console.log msg = "invalid id"
                res.render 'home', user: req.user, message: msg
            else
                if homework.deadline > new Date()
                    Homework.count {}, (err, count)->
                        new-homework = new Homework {
                            id: parseInt(req.param('assignId')) * -1
                            content: req.param 'content'
                            author: req.user.username
                            isQuestion: false
                        }
                        new-homework.save (error)->
                            if error
                                console.log "Error in saving hw: ", error
                                throw error
                            else
                                console.log msg = "Submit successfully"
                                res.redirect '/home'
                else
                    console.log msg = "Deadline passed"
                    res.render 'home', user: req.user, message: msg

  router.post '/grade', is-authenticated, (req, res)!->
    if !req.user.isTeacher
      console.log msg = "Only teacher has the permission to grade"
      res.render 'home', user: req.user, message: msg
    else
        Homework.findOne {id: parseInt(req.param('assignId')) * -1}, (err, homework)->
            if homework.deadline < new Date()
                Homework.findOne {id: req.param('assignId'), author: req.param('studentName')}, (err, homework)->
                    if !homework
                        console.log msg = "Invalid id or student name"
                        res.render 'home', user: req.user, message: msg
                    else
                        homework.score = parseInt req.param('score')
                        homework.save !->
                            res.redirect '/home'
            else
                console.log msg = "Deadline hasn't passed"
                res.render 'home', user: req.user, message: msg
