require! ['express']
require! { Homework:'../models/homework', Answer:'../models/answer', User:'../models/user' }
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
    Homework.find {}, (err, collection) ->
      res.render 'home', user: req.user, homeworks: collection

  router.get '/assign', is-authenticated, (req, res)!->
    if req.user.identity == 'teacher'
      res.render 'assign'

  router.post '/assign', is-authenticated, (req, res)!->
    if req.user.identity == 'teacher'
      new-homework = new Homework {
        title:        req.param 'title'
        description:  req.param 'description'
        deadline:     req.param 'deadline'
      }
      new-homework.save (error)->
        res.redirect '/home'

  router.get '/homework/:id', is-authenticated, (req, res)!->
    Homework.find-one { _id: req.param 'id' }, (err, homework) ->
      if req.user.identity == 'teacher'
        Answer.find { homework: req.param 'id' }, (err, answers) ->
          res.render 'homework', user: req.user, homework: homework, answers: answers
      else  # student
        Answer.find-one { homework: req.param 'id', student: req.user._id }, (err, answer) ->
          res.render 'homework', user: req.user, homework: homework, answer: answer

  router.post '/homework/:id', is-authenticated, (req, res)!->
    if req.user.identity == 'teacher'
      Homework.update { homework: req.param 'id' }, { $set: { title: req.param 'title', description: req.param 'description', deadline: req.param 'deadline' } }, (err, collection) ->
        res.redirect '/home'
    else  # student
      Answer.find-one { homework: req.param 'id', student: req.user._id }, (err, answer) ->
        if answer
          Answer.update { homework: req.param 'id', student: req.user._id }, { $set: {content: req.param 'content'} }, (err, collection) ->
            res.redirect '/home'
        else
          new-answer = new Answer {
            homework: req.param 'id'
            student: req.user._id
            firstName: req.user.firstName
            lastName: req.user.lastName
            content: req.param 'content'
          }
          new-answer.save (error)->
            res.redirect '/home'

  router.get '/answer/:id', is-authenticated, (req, res)!->
    if req.user.identity == 'teacher'
      Answer.find-one { _id: req.param 'id' }, (err, answer) ->
        res.render 'answer', answer: answer

  router.post '/answer/:id', is-authenticated, (req, res)!->
    if req.user.identity == 'teacher'
      Answer.update { _id: req.param 'id' }, { $set: {score: req.param 'score'} }, (err, collection) ->
        res.redirect '/home'

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

