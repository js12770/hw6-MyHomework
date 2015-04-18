require! ['express', '../controller']
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
    controller.show-homework-publish req, res

  router.get '/signout', (req, res)!->
    req.logout!
    res.redirect '/'

  router.get '/publish', is-authenticated, (req, res)!->
    if req.query.modify
      res.render 'publish', user: req.user, belong-to: req.query.modify
    else
      res.render 'publish', user: req.user

  router.post '/publish', (req, res)!->
    if req.body.belong-to
      controller.modify req, res
    else
      controller.publish req, res

    res.redirect '/home'

  router.get '/submitList', is-authenticated, (req, res)!->
    controller.show-homework-submit req, res

  router.post '/submitList', is-authenticated, (req, res)!->
    controller.grade-homework-submit req, res
    res.redirect '/submitList?belongTo=' + req.body.belong-to + '&deadline=' + req.body.deadline

  router.get '/submit', is-authenticated, (req, res)!->
    res.render 'submit', user: req.user, belong-to: req.query.belong-to, deadline: req.query.deadline

  router.post '/submit', is-authenticated, (req, res)!->
    controller.submit req, res
    res.redirect '/submitList?belongTo=' + req.body.belong-to + '&deadline=' + req.body.deadline