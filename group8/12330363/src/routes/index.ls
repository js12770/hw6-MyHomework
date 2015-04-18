require! {'express', User: '../models/user', Specification: '../models/specification', Homework: '../models/homework'}
router = express.Router!

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'
set-user-flag = (req) -> if 10 == req.user.userType then true else false

module.exports = (passport)->
  router.get '/', (req, res)!->
    res.render 'index', message: req.flash 'message'

  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/home', failure-redirect: '/', failure-flash: true
  }

  router.get '/signup', (req, res)!->
    res.render 'register', message: req.flash 'message'

  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: '/home', failure-redirect: '/signup', failure-flash: true
  }

  router.get '/home', is-authenticated, (req, res)!->
    flag = set-user-flag req
    res.render 'home',
      user: req.user,
      user_flag: flag,

  router.get '/signout', (req, res)!->
    req.logout!
    res.redirect '/'

  router.get '/get_specification', is-authenticated, (req, res) !->
    Specification.find (err, specs) !->
      res.json specs


  router.get '/get_homework', is-authenticated, (req, res) !->
    flag = set-user-flag req
    Homework.find (if not flag then {'authorId': req.user.id} else null), (err, hws) !->
      res.json hws

  router.post '/submit_homework', is-authenticated, (req, res) !->
    if not (set-user-flag req)
      new-homework = new Homework {
        specTitle: req.body.title
        version: 1
        content: req.body.content
        modifiedDate: new Date()
        author: req.user.username
      }
      new-homework.save (error) ->
        if error
          console.log 'Error in saving homework', error
          throw error

  router.post '/post_specification', is-authenticated, (req, res) !->
    if set-user-flag req
      Specification.find-one {title: req.body.title}, (error, doc) !->
        if error
          throw error
        else if not doc
          new-specification = new Specification {
            title: req.body.title
            version: 1
            deadline: new Date(req.body.deadline)
            content: req.body.content
            author: req.user.username
          }
          new-specification.save (error) ->
            if error
              console.log 'Error in saving specification', error
              throw error
        else
          Specification.update {_id: doc._id }, {$set:
            title: req.body.title
            version: req.body.version + 1
            deadline: req.body.deadline
            content: req.body.content
          }


  router.post '/grade_homework', is-authenticated, (req, res) !->
    if not (set-user-flag req)
      Homework.update {specTitle: req.body.title}, {grades: req.body.grades} (error) ->
        if error
          throw error
