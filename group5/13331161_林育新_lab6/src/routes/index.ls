require! {'express', Homework:'../models/homework'}
router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

module.exports = (passport)->
  router.get '/', (req, res)!-> res.render 'index', message: req.flash 'message'

  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/tell', failure-redirect: '/', failure-flash: true
  }

  router.get '/signup', (req, res)!-> res.render 'register', message: req.flash 'message'

  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: '/tell', failure-redirect: '/signup', failure-flash: true
  }


  #route for tell teacher or student
  router.get '/tell', (req, res) !->
    if req.user.category == 'teacher'
      res.redirect '/teacher'
    else
      res.redirect '/student'

  router.get '/teacher', is-authenticated, (req, res)!-> res.redirect '/showhw'
  router.get '/student', is-authenticated, (req, res)!-> res.redirect '/unfinish'

  #router for base
  router.get '/signout', (req, res) !-> res.redirect '/'

  #router for teacher
  router.get '/publish', is-authenticated, (req, res) !-> res.render 'publish', user:req.user

  router.get '/showhw', is-authenticated, (req, res) !->
    d = new Date()
    if d.getMonth! < 10 then month = '0' + (d.getMonth! + 1) else month = d.getMonth! + 1
    if d.getDate! < 10 then day = '0' + d.getDate! else day = d.getDate!
    if d.getHours! < 10 then hour = '0' + d.getHours! else hour = d.getHours!
    if d.getMinutes! < 10 then minute = '0' + d.getMinutes! else minute = d.getMinutes!
    nowtime = d.getFullYear! + '-' + month + '-' + day + ' ' + hour + ':' + minute;
    #create nowtime
    #nowtime = d.getFullYear! + '-' +(d.getMonth! + 1) + '-' + d.getDate! + ' ' + d.getHours! + ':' + d.getMinutes!
    console.log(nowtime)
    Homework.find {$and : [
      {createid : req.user._id},
      {ddl : {$gte: nowtime}}
      ]}, (error, homework) !->
        res.render 'showhw', user:req.user, hw:homework
  
  router.get '/correcthw', is-authenticated, (req, res) !->
    d = new Date()
    if d.getMonth! < 10 then month = '0' + (d.getMonth! + 1) else month = d.getMonth! + 1
    if d.getDate! < 10 then day = '0' + d.getDate! else day = d.getDate!
    if d.getHours! < 10 then hour = '0' + d.getHours! else hour = d.getHours!
    if d.getMinutes! < 10 then minute = '0' + d.getMinutes! else minute = d.getMinutes!
    nowtime = d.getFullYear! + '-' + month + '-' + day + ' ' + hour + ':' + minute;
    #create nowtime
    #tell the month
    #nowtime = d.getFullYear! + '-' +(d.getMonth! + 1) + '-' + d.getDate! + ' ' + d.getHours! + ':' + d.getMinutes!
    console.log(nowtime)
    Homework.find {$and : [
      {createid : req.user._id},
      {ddl : {$lte : nowtime}}
      ]}, (error, homework) !->
        res.render 'correcthw', user:req.user, hw:homework

  router.post '/publish', (req, res) !->
    new-hw = new Homework {
      createid: req.user._id
      createby : req.param 'createby'
      ddl : (req.param 'date') + ' ' + (req.param 'time')
      command : req.param 'command'
      hwname : req.param 'hwname'
      submit_hw : []
    }
    new-hw.save (error)->
      if error
        console.log "Error in publishing homework: ", error
        throw error
      else
        console.log "User publish homework success"
        res.redirect '/showhw'

  router.get '/modify/:_id', is-authenticated, (req, res) !->
    (error, course) <- Homework.find-by-id req.params._id
    return (console.log "Error in modify: ", error) if error

    res.render 'modify_hw', user:req.user, hw:course

  router.post '/modify/:_id', is-authenticated, (req, res) !->
    (error) <- Homework.find-by-id-and-update req.params._id, {ddl: (req.param 'date') + ' ' + (req.param 'time'), command: req.param 'command'}
    return (console.log "Error in modify: ", error) if error

    console.log "success modify"
    res.redirect '/showhw'

  router.get '/score/:_id', is-authenticated, (req, res) !->
    (error, course) <- Homework.find-by-id req.params._id
    return (console.log "Error in connect to the page of correct: ", error) if error
    
    res.render 'score_hw', user:req.user, hw:course

  #some question here, how to save the score
  router.post '/score/:_id', is-authenticated, (req, res) !->
    #(error, course) <- Homework.find-by-id-and-update req.params._id, {$set: {'submit_hw.0.score': req.param 'score'}}
    #return (console.log "Error in revise hw: ", error) if error
    
    if typeof (req.param 'score') is 'string'
      console.log (typeof req.param 'score')
      (error) <- Homework.find-by-id-and-update req.params._id, {$set: {'submit_hw.0.score': req.param 'score'}}
      return (console.log "Error in submit score: ", error) if error
    else
      for scores, index in req.param 'score'
        (error) <- Homework.find-by-id-and-update req.params._id, {$set: {('submit_hw.' + index.to-string! + '.score') : scores}}
        return (console.log "Error in submit score: ", error) if error

    res.redirect '/correcthw'

  router.get '/download/:filename', is-authenticated, (req, res) !->
    res.download('./homeworks/' + req.params.filename)

  #end of route for teacher

  #router for student
  router.get '/unfinish', is-authenticated, (req, res) !->
    d = new Date()
    if d.getMonth! < 10 then month = '0' + (d.getMonth! + 1) else month = d.getMonth! + 1
    if d.getDate! < 10 then day = '0' + d.getDate! else day = d.getDate!
    if d.getHours! < 10 then hour = '0' + d.getHours! else hour = d.getHours!
    if d.getMinutes! < 10 then minute = '0' + d.getMinutes! else minute = d.getMinutes!
    nowtime = d.getFullYear! + '-' + month + '-' + day + ' ' + hour + ':' + minute;
    Homework.find {ddl : {$gte: nowtime}}, (error, homework) !->
        res.render 'student_unfinish', user:req.user, hw:homework

  router.get '/finish', is-authenticated, (req, res) !->
    d = new Date()
    if d.getMonth! < 10 then month = '0' + (d.getMonth! + 1) else month = d.getMonth! + 1
    if d.getDate! < 10 then day = '0' + d.getDate! else day = d.getDate!
    if d.getHours! < 10 then hour = '0' + d.getHours! else hour = d.getHours!
    if d.getMinutes! < 10 then minute = '0' + d.getMinutes! else minute = d.getMinutes!
    nowtime = d.getFullYear! + '-' + month + '-' + day + ' ' + hour + ':' + minute;
    Homework.find {ddl : {$lte: nowtime}}, (error, homework) !->
        res.render 'student_finish', user:req.user, hw:homework

  router.get '/handin/:_id', is-authenticated, (req, res) !->
    (error, course) <- Homework.find-by-id req.params._id
    return (console.log "Error in handin: ", error) if error

    res.render 'student_commit', user: req.user, hw:course

  router.post '/handin/:_id', is-authenticated, (req, res) !->
    (error, course) <- Homework.find-by-id req.params._id
    for student, index in course.submit_hw
      if student.id.to-string! == req.user._id.to-string!
        return res.redirect '/unfinish'
    (error) <- Homework.find-by-id-and-update req.params._id, {$push: {submit_hw: {'hwid': req.params._id, 'id' : req.user._id, 'name' : req.user.username, 'path' : (req.user.userid + '-' + req.user.username + '.zip'), 'score' : ''}}}
    return (console.log "Error in handin homework: ", error) if error


    console.log "handin success!"

    res.redirect '/unfinish'

  #some thing have to do to check the student by stuid
  router.get '/check/:_id', is-authenticated, (req, res) !->
    (error, course) <- Homework.find-by-id req.params._id
    return (console.log "Error in Check your score: ", error) if error

    res.render 'student_check_score', user: req.user, hw:course


  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'


