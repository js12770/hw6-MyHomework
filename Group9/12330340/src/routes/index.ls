require! {User:'../models/user', Homework:'../models/homework', Requirement:'../models/requirement','express'}
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
    if req.user.actor == 'teacher'
      Requirement.find (tid: req.user._id),(err, homework) !->
        Homework.find (tid: req.user._id),(err, answer) !->
          res.render 'home',
            user: req.user,
            homework: homework,
            answer: answer
    else if req.user.actor == 'student'
      Requirement.find (err, homework) !->
          Homework.find {sid : req.user._id}, (err, ans) !->
            res.render 'home',
              user: req.user,
              homework: homework,
              answer: ans

  router.post '/home/addHw', (req, res)!->
    username = req.param 'user'
    console.log 'addHw initial'
    User.find-one {username: username} (err, user) !->
      newHw = new Requirement {
        tid : user._id
        teacher : user.username
        requires : req.param 'requires'
        deadline : req.param 'deadline'
      }
      newHw.save (error)->
        if error
          console.log "Error in saving requirement: ", error
          throw error
        else
          console.log newHw.tid
          console.log "Requirement add success"

  router.post '/home/reeditHw', (req, res)!->
    username = req.param 'user'
    console.log 'addHw initial'
    User.find-one {username: username} (err, user) !->
      Requirement.find-one {tid : user._id, requires : req.param 'exReq', deadline : req.param 'exDdl'} (err, r) !->
        r.requires = req.param 'requires'
        r.deadline = req.param 'deadline'
        r.save (error)->
          if error
            console.log 'error'
          else
            console.log 'update ok'

  router.post '/home/submitHw', (req, res)!->
    username = req.param 'user'
    console.log 'submit homework initial'
    User.find-one {username: username} (err, user) !->
      requires = req.param 'requires'
      Requirement.find-one {requires : requires} (err, hw) !->
        User.find-one {username : req.param 'teacher'} (err, t) !->
          newAns = new Homework {
            hid : hw._id
            sid : user._id
            tid : t._id
            teacher : req.param 'teacher'
            student : user.username
            content : req.param 'content'
            grade : 'null'
          }
          newAns.save (error)->
            if error
              console.log 'Error in submitting homework'
            else
              console.log 'success submitting'

  router.post '/home/changeHw', (req, res)!->
    username = req.param 'user'
    User.find-one {username: username} (err, user) !->
      Requirement.find-one {teacher: req.param 'teacher', requires: req.param 'requires'} (err, r) !->
        Homework.find-one {sid : user._id, hid : r._id} (err, h) !->
          h.content = req.param 'content'
          h.save (error)->
            if error
              console.log 'error'
            else
              console.log 'update ok'

  router.post '/home/grade', (req, res)!->
    Requirement.find-one {teacher : req.param 'teacher', requires : req.param 'requires'} (err, r) !->
      Homework.find-one {hid : r._id, teacher : req.param 'teacher', student : req.param 'student'} (err, h) !->
        h.grade = req.param 'grade'
        h.save (error)->
          if error
            console.log 'error'
          else
            console.log 'grade ok'

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

