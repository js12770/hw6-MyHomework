require! {'express',Homework:'../models/homework', Answer:'../models/answer'}
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
    if req.user.character == "student"
      Homework.find (err, homeworks) ->
        Date nowDate = new Date();
        nowTime = nowDate.valueOf!
        for homework in homeworks
            if homework.deadline.valueOf! > nowTime
              homework.canHandIn = true
            else
              homework.canHandIn = false
        res.render 'home', {user: req.user, homeworks: homeworks}
    else
      Homework.find  {"master" : req.user.username} (err, homeworks) ->
        Date nowDate = new Date();
        nowTime = nowDate.valueOf!
        for homework in homeworks
            if homework.deadline.valueOf! > nowTime
              homework.canModify = true
            else
              homework.canModify = false
        res.render 'home', {user: req.user, homeworks: homeworks}
      
  router.get '/publish_page', is-authenticated, (req, res) !->
    res.render 'publish_homework'

  router.post '/hand_in_page', is-authenticated, (req, res) !->
    console.log req.param 'homework_title'
    res.render 'hand_in_answer', {homework_id: (req.param 'homework_id'),  homework_title: (req.param 'homework_title'), homework_deadline : (req.param 'homework_deadline')}

  router.post '/modify_page', is-authenticated, (req, res) !->
    modify-homework = new Homework {
      master  : req.user.username
      title  : req.param 'homework_title'
      deadline  : req.param 'homework_deadline'
      demand  : req.param 'homework_demand'
    }
    res.render 'modify_homework', {homework: modify-homework,homework_id: req.param 'homework_id'}

  router.get '/watch_answers', is-authenticated, (req, res)!-> 
    if req.user.character == "teacher"
        Answer.find {"homework_id" : req.param 'homework_id'},  (err, answers) ->
          Date nowDate = new Date();
          nowTime = nowDate.valueOf!
          for answer in answers
            if answer.homework_deadline.valueOf! < nowTime
              answer.canCheck = true
            else
              answer.canCheck = false
          res.render 'watch_answers', {user: req.user, answers: answers}
    else
        Answer.find {"homework_id" : (req.param 'homework_id'), "master" : req.user.username},  (err, answers) ->
          res.render 'watch_answers', {user: req.user, answers: answers}

  router.post '/check' , is-authenticated, (req, res) !->
    conditions = {_id:req.param 'answer_id'}
    update = {
      score  : (req.param 'check_score'),
    }
    options = {upsert : true}
    Answer.update conditions, update, options, (error) !->
      if error
            console.log "Error in check answer: ", error
      else
            console.log "check sucess"
    res.redirect '/home'

  router.post '/hand_in',  is-authenticated, (req, res) !->
    new-answer = new Answer {
      master  : req.user.username,
      homework_id  : (req.param 'homework_id'),
      homework_title : (req.param 'homework_title'),
      homework_deadline : (req.param 'homework_deadline'),
      content  : (req.param 'answer_content'),
      score: (req.param 'score'),
    }
    console.log new-answer["score"]
    Answer.remove {master : req.user.username, homework_id: req.param 'homework_id'}, (error) ->
      if error
        console.log 'Error to delete old answer '
    new-answer.save (error)->
      if error
        console.log "Error to hand in answer: ", error
      else
        console.log "Answer hand in success"
    res.redirect '/home'

  router.post '/publish' , is-authenticated, (req, res) !->
    new-homework = new Homework {
      master  : req.user.username
      title  : (req.param 'homework_title'),
      deadline  : req.param 'homework_deadline'
      demand  : req.param 'homework_demand'
    }
    new-homework.save (error)->
      if error
        console.log "Error to publish homework: ", error
      else
        console.log "Homework publish success"
    res.redirect '/home'

  router.post '/republish' , is-authenticated, (req, res) !->
    conditions = {_id:req.param 'homework_id'}
    update = {
      deadline  : (req.param 'homework_deadline'),
      demand  : (req.param 'homework_demand')
    }
    options = {upsert : true}
    Homework.update conditions, update, options, (error) !->
      if error
            console.log "Error in modify homework: ", error
      else
            console.log "modify sucess"
    res.redirect '/home'
  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'
