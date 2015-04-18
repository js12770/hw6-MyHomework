require! ['express']
require! {Homework: '../models/homework', Submit:'../models/submit'}
router = express.Router! 


is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

formate-date = (date) ->
  str = date.getFullYear! + '-'
  month = date.getMonth! + 1
  if date.getMonth! < 10 then str = str + '0' + month + '-' else str = str + month + '-'
  if date.getDate! < 10 then str = str + '0' + date.getDate! else str = str + date.getDate!
  return str

module.exports = (passport)->
# index
  router.get '/', (req, res)!-> res.render 'index', message: req.flash 'message'

# login
  router.get '/login', (req, res)!-> res.render 'login', message: req.flash 'message'
  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/home', failure-redirect: '/', failure-flash: true
  }

# signup
  router.get '/signup', (req, res)!-> res.render 'register', message: req.flash 'message'
  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: '/home', failure-redirect: '/signup', failure-flash: true
  }

# home-page
  router.get '/home', is-authenticated, (req, res)!-> 
    Homework.
      find().
      sort('-ddl').
      exec (err, obj)->
        if err
          console.log "Found homeworks error."
        else
          date = new Date
          res.render 'home', {
            user      : req.user
            homeworks : obj
            current   : formate-date date
          }

# signout
  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

# submits
  router.get '/submits', is-authenticated, (req, res)!->
    if req.user.identity == 'teacher'
      Submit.
        find().
        sort('-time').
        exec (err, obj)->
          if err
            console.log "Found submits error."
          else
            res.render 'submits', {
              user    : req.user
              submits : obj
            }
    else if req.user.identity == 'student'
      Submit.
        find(stu:req.user.username).
        sort('-time').
        exec (err, obj)->
          if err
            console.log "Found-submits error."
          else
            res.render 'submits', {
              user    : req.user
              submits : obj
            }

# new
  router.get '/new', is-authenticated, (req, res)!-> res.render 'new', {user:req.user}
  router.post '/new', is-authenticated, (req, res)!->
    if req.user.identity == 'student'
      Homework.find-one {name: req.param 'homework-title'}, (error, obj)->
        if error
          console.log "Found homework error."
          throw error
        else
          if obj == null
            console.log "No homework named #{req.param 'homework-title'}."
            res.redirect '/new'
          else
            ddl = obj.ddl
            date = new Date
            new-submit = new Submit {
              stu     : req.user.username
              hw      : req.param 'homework-title'
              content : req.param 'content'
              time    : formate-date date
              ddl     : ddl
            } 
            new-submit.save (error)->
              if error
                console.log "Error in saving submit: ", error
                throw error
              else
                res.redirect '/submits'
    else if req.user.identity == 'teacher'
      Homework.find-one {name: req.param 'title'}, (error, obj)->
        if error
          console.log "Found homework error."
          throw error
        else
          if obj == null
            date = new Date
            new-homework = new Homework {
              name        : req.param 'title'
              description : req.param 'description'
              start       : formate-date date
              ddl         : req.param 'ddl'
            } 
            new-homework.save (error)->
              if error
                console.log "Error in saving homework: ", error
                throw error
              else
                res.redirect '/home'
          else
            console.log "Homework already existed."
            res.redirect '/new'

# score -- teacher
  router.post '/score/:_hw/:_stu', is-authenticated, (req, res)!->
    update = ($set:{score: req.param 'submit-score'})
    Submit.update {hw:req.param '_hw', stu:req.param '_stu'}, update, (err, num, raw)->
      if err
        throw err
      else
        res.redirect '/submits'

# edit
  router.get '/edit/:_name', is-authenticated, (req, res)->
    Homework.find-one {name:req.param '_name'}, (err, obj)->
      if err
        throw err
      else
        res.render 'edit', {
          user     : req.user
          homework : obj
        }

  router.post '/edit',  is-authenticated, (req, res)!->
    if req.user.identity == 'teacher'
      update-des = ($set:{description: req.param 'edit-description'})
      Homework.update {name: req.param 'title'}, update-des, (err, num, raw)->
        if err
          throw err
      update-ddl = ($set:{ ddl: req.param 'edit-ddl'})
      Homework.update {name: req.param 'title'}, update-ddl, (err, num, raw)->
        if err
          throw err
        else
          res.redirect '/home'

    else if req.user.identity == 'student'
      update-content = ($set:{content: req.param 'edit-content'})
      Submit.update {hw: req.param 'title', stu: req.user}, update-content, (err, num, raw)->
        if err
          throw err
        else 
          res.redirect '/submits'

# rewrite -- student
  router.get '/rewrite/:_hw/:_stu', is-authenticated, (req, res)->
    Submit.find-one {hw: req.param '_hw', stu: req.param '_stu'}, (err, obj)->
      if err
        throw err
      else
        res.render 'edit', {
          user   : req.user
          submit : obj
        }    
    