require! ['express', '../assignment/assignment']
router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

module.exports = (passport)->
  router.get '/', (req, res)!-> res.render 'index', msg: req.flash 'message'

  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/home', failure-redirect: '/', failure-flash: true
  }
  
  router.get '/signup', (req, res)!-> res.render 'register', msg: req.flash 'message'

  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: '/home', failure-redirect: '/signup', failure-flash: true
  }

  router.get '/home', is-authenticated, (req, res)!->
    res.render 'home', user: req.user, msg: req.flash 'message'

  router.get '/signout', (req, res)!-> 
    req.logout!
    req.flash 'message', '已退出'
    res.redirect '/'

  router.get '/assignment', is-authenticated, (req, res)!->
    assignment.get req, res


  router.get '/assignment/:id', is-authenticated, (req, res)!->
    assignment.get req, res, req.params.id

  router.get '/assignment/submit/:id', is-authenticated, (req, res)!->
    res.render 'submitAssignment', user: req.user, id: req.params.id, msg: req.flash 'message'

  router.post '/assignment/submit/:id', is-authenticated, (req, res)!->
    assignment.submit req, res

  router.get '/myassignment/:id', is-authenticated, (req, res)!->
    assignment.myAssignment req, res

  router.post '/myassignment/:id', is-authenticated, (req, res)!->
    if req.user.identity is 'student'
      res.redirect '/myassignment'
    else
      assignment.rateAssignment req, res

  router.get '/myassignment', is-authenticated, (req, res)!->
    assignment.getAssignmentList req, res

  router.get '/setassignment', is-authenticated, (req, res)!->
    res.redirect '/home' if  req.user.identity is 'student'
    if req.query.aid
      if req.query.op is 'delete'
        assignment.delete req, res
      else
        assignment.get req, res, req.query.aid, true
    else
      m = 'set'
      res.render 'setAssignment', user: req.user, mode: m

  router.post '/setassignment', (req, res)!->
    if req.query.aid
      console.log "收到修改作业请求"
      assignment.edit req, res
    else
      console.log "收到发布作业请求：", req.body
      assignment.set req, res

  router.get '/correctassignment', is-authenticated, (req, res)!->
    res.redirect '/home' if  req.user.identity is 'student'
    assignment.getAssignmentList req, res