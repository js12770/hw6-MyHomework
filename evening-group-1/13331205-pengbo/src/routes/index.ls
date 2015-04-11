require! {'express', Assignment: '../models/assignment', StudentWork: '../models/studentwork'}
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
      (error, assignments) <- Assignment.find
      res.render 'home', user: req.user, assignments: assignments

  router.post '/add-asgn', is-authenticated, (req, res)!->
        Assignment.find-one {asgnname: req.param 'asgnname'} (error, asgn)->
            if !(asgn) 
                newAsgn = new Assignment {
                    asgnname    : req.param 'asgnname'
                    deadline    : req.param 'deadline'
                    requirement : req.param 'requirement'
                }
                newAsgn.save()
            else
                Assignment.update {asgnname: req.param 'asgnname'}, {$set:{requirement: req.param 'requirement'}}, (err, num, raw)->
                    res.redirect '/home'
            res.redirect '/home'

  router.post '/add-stuwork', is-authenticated, (req, res)!->
        StudentWork.find-one {asgnment: req.param 'asgnment', student: req.user.username} (error, stuw)->
            if !(stuw)
                newStuwork = new StudentWork {
                    asgnment    : req.param 'asgnment'
                    student     : req.user.username
                    content     : req.param 'content'
                }
                newStuwork.save()
            else
                StudentWork.updata {asgnment: req.param 'asgnment', student: req.user.username}, {$set:{content: req.param 'content'}}, (err, num, raw)->
                    res.redirect '/home'
  /*
  router.get '/details', is-authenticated, (req, res)!->
        if req.user.identity == 'teacher'
            Assignment.find {asgnname: 
  */
  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

