require! ['express']
require! {Assignment:'../models/assignment'}
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

  router.get '/home', is-authenticated, (req, res)!-> res.render 'home', user: req.user

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'


  router.get '/homeworklist', is-authenticated, (req, res) !->
    Assignment.find (error, allassi)!->
      if error
        console.log 'can not find assignment'
      else
        res.render 'homeworklist', user: req.user, allassignment: allassi

  router.get '/addassignment', is-authenticated, (req, res)!-> res.render 'addassignment', user: req.user

  router.post '/addassignment', is-authenticated, (req, res)!->
    new-assignment = new Assignment {
      title             : req.param 'title'
      deadline          : req.param 'deadline'
      details           : req.param 'details'
      author            : req.user.username
    } 
    new-assignment.save (error)->
      if error
        console.log "Error in saving assignment: ", error
        throw error
      else
        console.log "Assignment registration success", new-assignment
        res.redirect '/homeworklist'

  router.get '/assignment_details', is-authenticated, (req, res)!->
    id = req.param 'id'
    Assignment.find-by-id id, (error, assi)!->
      if error
        console.log 'error in finding id:', id
      else
        if req.user.identity is 'student'
          Homework.find-one {assignmentId: id, author: req.user.username}, (error, homew)!-> 
            if error
              console.log 'error in finding id:', id
            else
              res.render 'homework_details', user: req.user, assignment: assi, homeworks: homew
        else if req.user.identity is 'teacher'
          Homework.find {assignmentId: id}, (error, homew)!-> 
            if error
              console.log 'error in finding id:', id
            else
              console.log homew
              res.render 'assignment_details', user: req.user, assignment: assi, homeworks: homew
  
  router.post '/change/:_id', is-authenticated, (req, res) !->
    new_deadline = req.param 'deadline'
    new_details = req.param 'details'
    id = req.params._id
    if new_deadline != ''
      Assignment.update {_id:id}, {$set: {deadline: new_deadline}}, {safe:true}, (error,bars) !->
        if error
          console.log 'error in finding id:', id
        else
          res.send 'true'
    else if new_details != ''
      Assignment.update {_id:id}, {$set: {details: new_details}}, {safe:true}, (error,bars) !->
        if error
          console.log 'error in finding id:', id
        else
          res.send 'true'
    res.redirect '/homeworklist'

  router.get '/student_upload', is-authenticated, (req, res)!->
    id = req.param 'id'
    Assignment.find-by-id id, (error, assi)!->
      if error
        console.log 'error in finding id:', id
      else if req.user.identity is 'student'
          Homework.find {assignmentId: id}, (error, homew)!-> 
            if error
              console.log 'error in finding id:', id
            else
              res.render 'student_upload', user: req.user, assignment: assi, homeworks: homew

  router.post '/student_upload', is-authenticated, (req, res)!->
    id = ""+req.param 'id'
    Homework.find-one {author: req.user.username, assignmentId: id}, (error, homew)!-> 
      if error
        console.log "Error in saving homework: ", error
      else
        if !!homew
          title = req.param 'title'
          Homework.update {author: req.user.username, assignmentId: id}, {$set: {title: title , details: req.param 'details'}}, {safe:true}, (error, bars) !->
            if error
              console.log 'error in finding id:', id
            else
              res.redirect '/student_upload?id='+req.param 'id'
        else
          new-homework = new Homework {
            title             : req.param 'title'
            assignmentId      : id
            time              : Date! - 'GMT+0800 (中国标准时间)'
            details           : req.param 'details'
            author            : req.user.username
            score             : '/'
          }
          new-homework.save (error)->
            if error
              console.log "Error in saving homework: ", error
              throw error
            else
              console.log "Assignment registration success", new-homework
              res.redirect '/student_upload?id='+req.param 'id'

  router.get '/my_homework', is-authenticated, (req, res)!->
    id = req.param 'id'
    console.log 'fuck'+id
    Assignment.find-by-id id, (error, assi)!->
      if error
        console.log 'error in finding id:', id
      else if req.user.identity is 'student'
          Homework.find-one {assignmentId: id, author: req.user.username}, (error, homew)!-> 
            if error
              console.log 'error in finding id:', id
            else
              console.log homew
              res.render 'my_homework', user: req.user, assignment: assi, homeworks: homew

  router.get '/student_homework', is-authenticated, (req, res)!->
    id = req.param 'id'
    console.log 'fuck'+id
    Assignment.find-by-id id, (error, assi)!->
      if error
        console.log 'error in finding id:', id
      else if req.user.identity is 'teacher'
          Homework.find-one {assignmentId: id}, (error, homew)!-> 
            if error
              console.log 'error in finding id:', id
            else
              console.log homew
              res.render 'student_homework', user: req.user, assignment: assi, homeworks: homew

  router.post '/student_homework', is-authenticated, (req, res)!->
    id = req.param 'id'
    console.log 'fuck'+id
    Assignment.find-by-id id, (error, assi)!->
      if error
        console.log 'error in finding id:', id
      else if req.user.identity is 'teacher'
          Homework.find-one {assignmentId: id}, (error, homew)!-> 
            if error
              console.log 'error in finding id:', id
            else
              Homework.update {assignmentId: id}, {$set: {score: req.param 'score'}}, {safe:true}, (error, bars) !->
                console.log homew
                res.render 'student_homework', user: req.user, assignment: assi, homeworks: homew


  