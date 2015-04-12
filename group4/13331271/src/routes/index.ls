require! ['express', '../homework/homework']
router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

module.exports = (passport)->
  router.get '/', (req, res)!-> res.render 'index', message: req.flash 'message'

  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/home', failure-redirect: '/', failure-flash: true
  }

  router.get '/signup', (req, res)!-> res.render 'register', message: req.flash 'message'

  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: '/home', success-flash: true, failure-redirect: '/signup', failure-flash: true
  }

  router.get '/home', is-authenticated, (req, res)!-> 
    #res.cookie('user', req.user._id);
    if req.user.role is "teacher"
      homework.teacher req, res
      
    else if req.user.role is "student"
      homework.student req, res

  router.get '/signout', (req, res)!-> 
    req.logout!
    #req.redirect 'message', 'Logout successfully!'
    res.redirect '/'

  # 批改页面
  router.get '/grade', is-authenticated, (req, res)!-> 
    homework.submit-list req, res

  router.post '/grade', is-authenticated, (req, res)!-> 
    homework.grade req, res

  #　发布作业功能
  router.post '/issue', is-authenticated, (req, res)!->
    homework.issue req, res
  
  # 提交作业功能
  router.post '/submit', is-authenticated, (req, res)!->
    homework.submit req, res
