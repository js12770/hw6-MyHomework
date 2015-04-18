require! {'express', Homework:'../models/Homework', Handin:'../models/Handin'}
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
    Homework.find {}, (err, homework)!->
      if err
        console.log err
        res.redirect '/'
      else
        now = new Date!
        res.render 'home', user: req.user, homework: homework, now: now

  router.get '/homework', (req, res)!-> res.render 'homework', user: req.user, edit:0

  router.post '/homework' (req, res)!->
    new-homework = new Homework {
      hwname : req.param 'hwname'
      discription  : req.param 'discription'
      deadline  : req.param 'deadline'
    }
    new-homework.save (error)->
      if error
        console.log "Error in adding homework: ", error
      else
        console.log "New homework publish success"
    res.redirect '/home'

  router.get '/homework/:hwname', (req, res)!-> 
    Homework.find-one {hwname: req.param 'hwname'}, (err, target) ->
      res.render 'homework', homework: target, user: req.user, edit: 1

  router.post '/homework/:hwname', (req, res)!-> 
    hw = req.param 'hwname'
    nd = req.param 'discription'
    nddl = req.param 'deadline'
    Homework.update {hwname: hw},{$set: {discription: nd, deadline: nddl}},(err, num, raw)->
      if err
        console.log 'edit homework failed.'
      else
        res.redirect '/home'
    res.redirect '/home'

  router.get '/handin/:hwname', is-authenticated, (req, res)!->
    Homework.find-one {hwname: req.param 'hwname'}, (err, collection) ->
      hw = req.param 'hwname'
      Handin.find-one {hwname: hw, student: req.user.username}, (err, handin) !->
        res.render 'handin', homework: collection, user: req.user, prehandin:handin

  router.post '/handin/:hwname' is-authenticated, (req, res) !->
    hw = req.param 'hwname'
    Handin.find-one {hwname: hw, student: req.user.username}, (err, handin) !->
      if handin is null
        new-handin = new Handin {
          student: req.user.username
          hwname: req.param 'hwname'
          answer : req.param 'answer'
          score: 'Null'
        }
        new-handin.save (error)->
        if error
          console.log "Error in handing in homework: ", error
        else
          console.log "Homework hand in success"
      else
        Handin.update {hwname: hw, student: req.user.username},{$set: {answer: req.param 'answer'}},(err, num, raw)->
          if err
            throw err
          else
            res.redirect '/home'
    res.redirect '/home'

  router.get '/answerlist/:hwname', is-authenticated, (req, res)!->
    Handin.find {hwname: req.param 'hwname'},(err, collection) ->
      if err
        console.log "Error in getting list: ", error
      else
        res.render 'answerlist', user: req.user, handin: collection, hwname: req.param 'hwname'

  router.get '/remark/:hwname/:student', is-authenticated, (req, res)!->
    Handin.find-one {hwname: req.param 'hwname', student: req.param 'student'},(err, collection) ->
      if err
        console.log "Error in getting target: ", error
      else
        res.render 'remark', user: req.user, handin: collection

  router.post '/remark/:hwname/:student', is-authenticated, (req, res)!->
    Handin.update {hwname: req.param 'hwname', student: req.param 'student'},{$set: {score: req.param 'score'}},(err, num, raw)->
      if err
        throw err
      else
        res.redirect '/answerlist/'+req.param 'hwname'
    res.redirect '/answerlist/'+req.param 'hwname'

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

