require! ['express']
require! {hw:'../models/hw', 'bcrypt-nodejs', 'passport-local'}
require! {shw:'../models/shw', 'bcrypt-nodejs', 'passport-local'}
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

  router.get '/main', is-authenticated, (req, res)!->
    chara = req.user['chara']
    if chara == "teacher"
      res.render 'main_teacher', user: req.user
    else 
      res.render 'main_student', user: req.user

  router.get '/submit/:_id', is-authenticated, (req, res)!-> 
    _id = req.param '_id'
    hw.find { '_id': _id } (err, hw_find) ->
      console.log hw_find
      res.render 'submit', item : hw_find[0]

  router.post '/submit/:_id', (req, res) !->
    _id = req.param '_id'
    hw.find { '_id': _id } (err, hw_find) ->
      shw.remove { 'worker': req.user.username, 'hwid' : hw_find[0]._id } ->
        new-shw = new shw {
          worker : req.user.username
          hwname : hw_find[0].hwname
          hwid : hw_find[0]._id
          content : req.param 'hwcontent'
        }
        console.log new-shw
        new-shw.save (error)->
          if error
            console.log "Error in saving homework: ", error
          else
            console.log "Homework publish success"
          res.redirect '/hwsee'

  router.post '/shwsee', (req, res) !->
    worker = req.user.username
    hwid = req.param 'hwid'
    shw.find { 'worker': worker, 'hwid' : hwid } (err, shw_find) ->
      console.log shw_find
      if shw_find.length == 0
        res.redirect '/hwsee'
      else
        res.render 'shwsee', item : shw_find[0]

  router.get '/watch_homework/:_id', is-authenticated, (req, res)!-> 
    _id = req.param '_id'
    shw.find { 'hwid': _id } (err, shw_find) ->
      res.render 'shwsee_teacher', collection : shw_find

  router.get '/republish/:_id', is-authenticated, (req, res)!-> 
    _id = req.param '_id'
    hw.findOne { '_id': _id } (err, hw_find) ->
      res.render 'hwupdate', item : hw_find

  router.post '/hwupdate/:_id', (req, res) !->
    __id = req.param '_id'
    _hwddl = req.param '_hwddl'
    _hwrequest = req.param '_hwrequest'
    console.log __id + " " + _hwrequest + " " + _hwddl
    conditions = {_id : __id}
    update = {
      hwddl : _hwddl,
      hwrequest : _hwrequest
    }
    options = {upsert : true}
    hw.update conditions, update, options, (error)!->
      if error
        console.log "Error in modify homework: ", error
      else
        console.log "modify sucess"
      res.redirect '/hwsee'

  router.get '/hwcreate', (req, res)!-> 
    res.render 'hwcreate'

  router.get '/hwsee', is-authenticated, (req, res)!-> 
    Date nowDate = new Date()
    nowTime = nowDate.valueOf!
    hw.find (err, collection) ->
      for _hw in collection
        ddlTime = _hw.hwddl.valueOf!
        if ddlTime < nowTime
          _hw.overddl = "1"
      res.render 'hwsee', user: req.user, collection: collection

  router.post '/hwcreate', (req, res) !->
    new-hw = new hw {
      master  : req.user.username
      hwname  : req.param 'hwname'
      hwrequest  : req.param 'hwrequest'
      hwddl  : req.param 'hwddl'
      overddl : "0"
    }
    new-hw.save (error)->
      if error
        console.log "Error in saving homework: ", error
        res.redirect '/hwcreate'
      else
        console.log "Homework publish success"
    res.redirect '/home'

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

