require! ['express', '../db']
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
    # res.render 'home', user: req.user

    # console.log 'after-render-------------------------------------'

    try
      db.show-homework-publish req, res
    catch err
      console.log err

  router.get '/signout', (req, res)!->
    req.logout!
    res.redirect '/'

  router.get '/publish', is-authenticated, (req, res)!->
    console.log 'test-modify---------------------'
    console.log req.query.modify

    if req.query.modify
      res.render 'publish', user: req.user, modify: req.query.modify
    else
      console.log 'test-else---------------'
      res.render 'publish', user: req.user

  router.post '/publish', (req, res)!->
    console.log '--------------------here-------------------------'
    console.log req.body
    console.log '--------------------here-------------------------'

    if req.body.modify
      console.log 'modify-branch--------------'
      try
        db.modify req.body
      catch error
    else
      try
        db.publish req.body, req.user.username
      catch err
        console.log err

    res.redirect '/home'

  router.get '/submitList', is-authenticated, (req,res)!->
    try
      db.show-homework-submit req, res
    catch err
      console.log err

  router.get '/submit', is-authenticated, (req, res)!->
    console.log 'in-get-submit-------------------'
    console.log req.user
    console.log req.query.belong-to
    res.render 'submit', user: req.user, belong-to: req.query.belong-to

  router.post '/submit', is-authenticated, (req, res)!->
    console.log '--------------------submit-------------------------'
    console.log req.body
    console.log '--------------------submit-------------------------'

    try
      db.submit req.body, req.user.username
    catch err
      console.log err

    res.redirect '/submitList'
