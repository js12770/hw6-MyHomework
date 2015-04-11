require! {'express', Homework:'../models/homework', Announcement:'../models/announcement'}
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
    Announcement.find {}, (error, docs)!->
      if error
        res.redirect '/'
      else
        res.render 'home', user: req.user, announcement: docs

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  router.get '/hw-produce', is-authenticated, (req, res)!-> res.render 'homework-produce', user: req.user

  router.post '/hw-produce', is-authenticated, (req, res)!->
    content = req.param 'produced-question-content'
    date = req.param 'produced-question-date'
    if content is not '' and date is not ''
      homework = new Homework {
        producerID    : req.user.username
        producerName  : req.user.firstName + '.' + req.user.lastName
        question      : content
        ddl           : date
      }
      homework.save (error)!->
        if error
          console.log "Error in publishing homework: ", error
          throw error
        else
          console.log "Homework publish success"
          res.redirect '/home'
    else
      res.redirect '/hw-produce'

  router.get '/hw-view', is-authenticated, (req, res)!->
    Homework.find {}, (error, docs)!->
      if error
        res.redirect '/home'
      else
        res.render 'homework-view', user: req.user, hwlist: docs
  
  router.get '/question/*', is-authenticated, (req, res)!->
    console.log req.params[0]
    Homework.find {question:req.params[0]}, (error, docs)!->
      if error or docs.length is 0
        res.redirect '/home'
      else
        console.log docs
        res.render 'homework-answer', user: req.user, question: docs

  router.post '/hw-answer', is-authenticated, (req, res)!->
    question = req.param 'question-content'
    answer = req.param 'answer=question=content'
    Homework.find {question:question}, (error, docs)!->
      if error
        res.redirect '/home'
      else
        mydate = new Date()
        time = mydate.getFullYear! + '-' + (mydate.getMonth()+1) + '-' + mydate.getDate()
        announcement = new Announcement {
          username   : req.user.username
          firstName  : req.user.firstName
          lastName   : req.user.lastName
          producerID : docs[0].producerID
          question   : docs[0].question
          answer     : answer
          commitTime : time
        }
        Announcement.find {
          username   : req.user.username
          firstName  : req.user.firstName
          lastName   : req.user.lastName
          question:question
          }, (error, docs)!->
            if error
              res.redirect '/home'
            else if docs.length is 0
              announcement.save (error)!->
                if error
                  console.log "Error in publishing homework answer: ", error
                  throw error
                else
                  console.log "Homework answer publish success"
                  res.redirect '/home'
            else
              res.redirect '/home'
        console.log req.user.username
        res.redirect '/home'