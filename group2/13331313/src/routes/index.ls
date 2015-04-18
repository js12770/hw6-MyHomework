require! ['express']
require!{Homework:'../models/homework'}
require!{Answer:'../models/answer'}
require!{User:'../models/user', 'bcrypt-nodejs', 'passport-local'}
require!{'moment'}
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
      Homework.find {}, (error, homeworks_)!->
        if error
          return console.log 'error in finding homeworks'
        now=new Date()

        myLocaleTime = moment! .format 'YYYY-MM-DD HH:mm:ss'
        res.render 'homework-list', user: req.user, homeworks:homeworks_, time:myLocaleTime

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

#create hw
router.get '/createHw' (req, res)!->
  Homework.count {}, (error, count)!->
    if error
      return
    else
      console.log ('count'+count)
      res.render 'createHw', Hw-id:count, user:req.user

router.post '/createHw' (req, res)!->
  Homework.count {}, (error, sum)!->
    if error
      console.log 'fail to count homeworks'
    else
      if req.body.deadline
        homework_=new Homework {
          Hw_id:  sum,
          title: req.body.title,
          require: req.body.require,
          deadline: req.body.deadline
        }
        homework_.save (error)->
          if error
            console.log "Error in creating hw", error
            throw error
          else
            console.log "create hw success"
        res.redirect '/home'
      else
        res.redirect '/createHw'

#homework-detail
router.get '/homework', (req, res)!->
  Homework.find-one {title:req.query.homework_t}, (error, homework_)!->
    if error
      console.log 'cant find homework'
    else
      time = moment! .format 'YYYY-MM-DD HH:mm:ss'
      if req.user.type=='tea'
        Answer.find {Hw_id:homework_.Hw_id}, (error, answers)->
          if error
            return
          if answers
            res.render 'homework-detail', user:req.user, homework:homework_, answers:answers, time:time
      if req.user.type=='stu'
        Answer.find {Hw_id:homework_.Hw_id, author:req.user.username}, (error, answers)->
          if error
            return
          else res.render 'homework-detail', user:req.user, homework:homework_, answers:answers, time:time

#answer
router.post '/handin', (req, res)!->
  Answer.find-one {Hw_id:req.body.hwId, author:req.user.username}, (error, answer)!->
    if error
      console.log 'fail in finding answer for hw'
    else
      if answer
        Answer.remove {Hw_id:req.body.hwId, author:req.user.username} (error, answer)!->
          console.log 'remove'
      newAnswer = new Answer {
        Hw_id:req.body.hwId,
        content:req.body.content,
        author:req.user.username,
        grade: ''
      }
      newAnswer.save (error)!->
        if error
          console.log "Error in saving ans", error
          throw error
        else
          console.log "create ans success"
    Homework.find-one {Hw_id:req.body.hwId}, (error, homework)!->
      if homework
        res.redirect '/homework?homework_t='+homework.title
      else 
        res.redirect '/home'

#edit homework
router.get '/editHw', (req, res)!->
  myLocaleTime = moment! .format 'YYYY-MM-DD HH:mm:ss'
  Homework.find-one {Hw_id:req.query.HwId}, (error, homework)!->
    if error
      console.log 'fail in find homework'
    else
        hw_id=homework.Hw_id
        res.render 'createHw', user:req.user, edit:'1', homework:homework

router.post '/editHw', (req, res)!->
  Homework.update {Hw_id:req.body.id},
    {deadline:req.body.deadline, require:req.body.require},
    (error, homework)!->
      if error
        console.log 'fail in find homework'
      else
        if homework
          res.redirect 'home'

#grade
router.post '/updateGrade', (req, res)!->
  Answer.update {Hw_id:req.query.hwId, author:req.query.author},
    {grade:req.body.grade},
    (error, answer)->
      if error
        console.log 'error'
      else
        res.redirect 'home'
