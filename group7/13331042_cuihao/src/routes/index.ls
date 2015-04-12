require! ['express']
require! {Assignment:'../models/assignment'}
require! {Homework:'../models/homework'}

router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

module.exports = (passport) ->
  router.get '/', (req, res)!-> 
    if req.is-authenticated!
      res.redirect '/home'
    else
      res.render 'index', message: req.flash 'message'

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

  router.get '/allhomework', is-authenticated, (req, res)!->
    Assignment.find (error, allassi)!->
      if error
        console.log 'error in finding assignment'
      else
        res.render 'homework_list', user: req.user, allassignment: allassi

  router.get '/addassignment', is-authenticated, (req, res)!-> res.render 'addassignment', user: req.user

  router.post '/addassignment', is-authenticated, (req, res)!->
    new-assignment = new Assignment {
      title             : req.param 'title'
      deadline          : req.param 'deadline'
      briefIntroduction : req.param 'brief'
      details           : req.param 'details'
      author            : req.user.username
    } 
    new-assignment.save (error)->
      if error
        console.log "Error in saving assignment: ", error
        throw error
      else
        console.log "Assignment registration success", new-assignment
        res.redirect '/allhomework'

  router.get '/assignmentdetail', is-authenticated, (req, res)!-> 
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
              res.render 'homework_detail', user: req.user, assignment: assi, homeworks: homew
        else if req.user.identity is 'teacher'
          Homework.find {assignmentId: id}, (error, homew)!-> 
            if error
              console.log 'error in finding id:', id
            else
              res.render 'homework_detail', user: req.user, assignment: assi, homeworks: homew

  router.post '/change', is-authenticated, (req, res)!->
    tar-pro = req.body.pro
    tar-content = req.body.content
    id = req.body.id
    if (tar-pro is 'briefIntroduction')
      Assignment.update {_id: id}, {$set: {briefIntroduction: tar-content}}, {safe:true}, (error, bars) !->
        if error
          console.log 'error in finding id:', id
        else
          res.send 'true'
    else if (tar-pro is 'details')
      Assignment.update {_id: id}, {$set: {details: tar-content}}, {safe:true}, (error, bars) !->
        if error
          console.log 'error in finding id:', id
        else
          res.send 'true'
    else if (tar-pro is 'title')
      Assignment.update {_id: id}, {$set: {title: tar-content}}, {safe:true}, (error, bars) !->
        if error
          console.log 'error in finding id:', id
        else
          res.send 'true'
    else if (tar-pro is 'deadline')
      Assignment.update {_id: id}, {$set: {deadline: tar-content}}, {safe:true}, (error, bars) !->
        if error
          console.log 'error in finding id:', id
        else
          console.log tar-content
          res.send 'true'

  router.get '/uploadhomework', is-authenticated, (req, res)!-> 
    id = req.param 'id'
    Assignment.find-by-id id, (error, assi)!->
      if error
        console.log 'error in finding id:'
      else
        res.render 'uploadhomework', user: req.user, assignment: assi

  router.post '/uploadhomework', is-authenticated, (req, res)!-> 
    id = ''+req.param 'id'
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
              res.redirect '/assignmentdetail?id='+req.param 'id'
        else
          new-homework = new Homework {
            title             : req.param 'title'
            assignmentId      : id
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
              res.redirect '/assignmentdetail?id='+req.param 'id'

  router.get '/article', is-authenticated, (req, res)!-> 
    id = req.param 'id'
    Homework.find-by-id id, (error, homew)!-> 
      if error
        console.log "Error in saving homework: ", error
        throw error
      else
        Assignment.find-by-id homew.assignmentId, (error, assi)!->
          if error
            console.log 'error in finding id:'
          else
            res.render 'article', user: req.user, assignment: assi, homework: homew

  router.post '/remark', is-authenticated, (req, res)!->
    id = req.body.id
    new-score = req.body.score
    Homework.update {_id: id}, {$set: {score: new-score}}, {safe:true}, (error, bars) !->
      if error
        console.log 'error in finding id:', id
      else
        res.send 'true'
