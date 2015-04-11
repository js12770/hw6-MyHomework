require! ['express']
require! {Project:'../models/project', 'bcrypt-nodejs', 'passport-local'}
require! {User:'../models/user', 'bcrypt-nodejs', 'passport-local'}
router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

module.exports = (passport) ->
  router.get '/', (req, res)!-> res.render 'index', message: req.flash 'message'

  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/home', failure-redirect: '/', failure-flash: true
  }

  router.get '/signup', (req, res)!-> res.render 'register', message: req.flash 'message'

  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: '/home', failure-redirect: '/signup', failure-flash: true
  }

  router.get '/home', is-authenticated, (req, res)!-> res.render 'home', user: req.user

  router.get '/deadline', (req, res)!-> res.render 'deadline', user: req.user
  
  router.post '/deadline', (req, res)!-> 
    name = req.param 'name'
    new-project = new Project {
      name : name
      startTime : req.param 'ftime'
      deadline : req.param 'ttime'
    }
    new-project.save (error) ->
      if error
        console.log "Error in saving deadline: ", error
        throw error
      else
        User.update({teacher_student: 'teacher'}, {$push: {deadlines : new-project}}, {multi:true}, (error) !->)
        User.update({teacher_student: 'student'}, {$push: {deadlines : new-project}}, {multi:true}, (error) !->)
        res.render 'deadline' , user: req.user
        console.log "Deadline creation success"
  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'
