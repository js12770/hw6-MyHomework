require! ['express']
router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

module.exports = (passport, homework)->
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
    req.flash 'message', 'Logout successfully!'
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

  # 删除提交功能
  router.post '/delete', is-authenticated, (req, res)!->
    homework.del req, res

  # 编辑提交功能
  router.post '/edit', is-authenticated, (req, res)!->
    homework.edit req, res

  router.get '/download/submit/:filename', is-authenticated, (req, res)!->
    (err)<- res.download "./uploads/submit/#{req.param 'filename'}"
    return console.log err if err

  router.get '/download/issue/:filename', is-authenticated, (req, res)!->
    (err)<- res.download "./uploads/issue/#{req.param 'filename'}"
    return console.log err if err

