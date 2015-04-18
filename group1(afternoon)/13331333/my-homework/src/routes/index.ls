require! {'express', Question:'../models/question', Answer:'../models/answer'}
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

  router.get '/home', is-authenticated, (req, res)!-> res.render 'home', user: req.user

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  router.get '/ask', is-authenticated, (req, res)!-> res.render 'ask', message: req.flash 'message'

  router.post '/ask', (req, res)!->
    homework-deadline = new Date req.param 'deadline'
    /*由于Date的构造函数会直接将deadline看做格林尼治时间，导致时间增加8小时，
    所以这里减去8小时得到中国时间*/
    homework-deadline.setHours homework-deadline.getHours! - 8
    new-question = new Question {
      teacher_id: req.user._id
      teacher_name: req.user.username
      title: req.param 'title'
      requirements: req.param 'requirements'
      deadline: homework-deadline
    }
    new-question.save (error)->
      if error
        console.log "Error in saving question: ", error
        throw error
      else
        console.log "Question registration success"
        res.redirect '/home'

  router.get '/question' is-authenticated, (req, res)!->
    if req.user.identity == 'teacher'
      Question.find {teacher_id: req.user._id}, (error, collection) ->
        res.render 'question', { user: req.user, collection: collection }
    else
      Question.find (error, collection) ->
        res.render 'question', { user: req.user, collection: collection }
  
  router.get '/answer/:question_id', is-authenticated, (req, res)!->
    isDeadlinePassed = false
    Question.findOne {_id : req.param 'question_id'}, (error, collection) ->
        if collection.deadline < new Date!
          isDeadlinePassed = true
        res.render 'answer' { user: req.user, collection: collection, isDeadlinePassed: isDeadlinePassed}

  router.get '/update/:question_id', is-authenticated, (req, res)!->
    isDeadlinePassed = false
    Question.findOne {_id : req.param 'question_id'}, (error, collection) ->
        if collection.deadline < new Date!
          isDeadlinePassed = true
        res.render 'update' { user: req.user, collection: collection, isDeadlinePassed: isDeadlinePassed}

  router.post '/answer/:question_id/:question_title', (req, res)!->
    Answer.findOne {student_id: req.user._id, question_title: req.param 'question_title'}, (error, collection) ->
      if collection isnt null
        collection.content = req.param 'content'
        collection.save (error) ->
          if error
            console.log "Error in updating answer: ", error
            throw error
          else
            console.log "Updating answer success"
            res.redirect '/home'
      else
        Question.findOne {_id: req.param 'question_id'}, (error, collection) ->
          new-answer = new Answer {
            student_id: req.user._id
            question_id: req.param 'question_id'
            student_name: req.user.username
            question_title: req.param 'question_title'
            teacher_id: collection.teacher_id
            content: req.param 'content'
            score: null
          }
          new-answer.save (error)->
            if error
              console.log "Error in saving answer: ", error
              throw error
            else
              console.log "Answer registration success"
              res.redirect '/home'

  router.post '/update/:question_id/:question_title', (req, res)!->
    Question.findOne {_id : req.param 'question_id'}, (error, collection) ->
      if collection isnt null
        if req.body.deadline != ''
          homework-deadline = new Date req.param 'deadline'
          homework-deadline.setHours homework-deadline.getHours! - 8
          collection.deadline = homework-deadline
        if req.body.content != ''
          collection.requirements = req.param 'content'
        collection.save (error) ->
          if error
            console.log "Error in updating question: ", error
            throw error
          else
            console.log "Updating question success"
            res.redirect '/question'

  router.get '/score', is-authenticated, (req, res)!->
    if req.user.identity == 'teacher'
      Answer.find {teacher_id : req.user._id}, (error, collection) ->
        res.render 'score' { user: req.user, collection: collection }
    else
      Answer.find {student_id : req.user._id}, (error, collection) ->
        res.render 'score' { user: req.user, collection: collection }

  router.post '/givescore/:student_id/:question_id', (req, res) !->
    Answer.findOne {question_id: (req.param 'question_id'), student_id: (req.param 'student_id')}, (error, collection) ->
      collection.score = req.param 'score'
      collection.save (error) ->
        if error
          console.log "Error in updating question: ", error
          throw error
        else
          console.log "Updating question success"
          res.redirect '/home'


