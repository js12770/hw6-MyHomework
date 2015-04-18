# require! ['express', "./../passport/publish_homework"]

require! {express:'express', work: "./../passport/publish_homework", Homework: "../models/homework", Submit: "../models/submit"}

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


  /*--------------------------------------主页面---------------------------------------*/
  router.get '/home', is-authenticated, (req, res)!->
    (error, submits) <- Submit.find {student: req.user.username}

    Homework.find {}, (error, homeworks)!->
      if error
        res.redirect '/'
      else
        homeworks = homeworks.sort!
        res.render 'home', user: req.user, homeworks: homeworks, submits: submits, message: req.param 'message'
  /*-----------------------------------------------------------------------------------*/


  /*-----------------------------------发布作业--------====---------------------------*/
  router.post '/publish_homework', is-authenticated, (req, res)!->
    work req, res, -> res.redirect '/home'
  /*----------------------------------------------------------------------------------*/



  /*----------------------------------修改作业要求------------------------------------*/
  router.post '/alter_content/', is-authenticated, (req, res) !->
    homework_id = req.param 'homework_id'
    content = req.param 'content'
    (error, homework) <- Homework .find-one {id: homework_id}
    console.log "error occurs in finding homework with error: "+error if error

    error_message = ""
    now = new Date!
    console.log homework.deadline

    /*判断作业deadline是否已到达*/
    if homework.deadline.getTime! < now.getTime!
        error_message = "时间已截止"
    if not error_message
      Homework .update {id: homework_id}, $set:{content: content}, (error) ->
        console.log "error occurs in altering content for homework with error: "+error if error
      res.redirect '/home?message=成功修改作业要求'
    else
      res.redirect '/home?message='+error_message
  /*-----------------------------------------------------------------------------------*/



  /*---------------------------------修改作业deadline----------------------------------*/
  router.post '/alter_deadline/', is-authenticated, (req, res) !->
    homework_id = req.param 'homework_id'
    deadline = req.param 'deadline'
    Homework .update {id: homework_id}, $set:{deadline: deadline}, (error) ->
      console.log "error occurs in alter content for homework with error: "+error if error
    res.redirect '/home?message=成功修改作业deadline'
  /*-----------------------------------------------------------------------------------*/


  /*-----------------------------批改作业页面------------------------------------------*/
  router.get '/hw_view', is-authenticated, (req, res) !->
    homework_id = req.param 'homework_id'
    (error, submits) <- Submit.find {homework_id: homework_id}
    console.log "error occurs in finding homework with error: "+error if error

    (error, homework) <- Homework.find-one {id:homework_id}
    console.log "error occurs in finding homework with error: "+error if error

    res.render 'hw_view', submits: submits, homework:homework, message:req.param 'message'
  /*-----------------------------------------------------------------------------------*/


  /*--------------------------------------批改分数-------------------------------------*/
  router.post '/mark/', is-authenticated, (req, res) !->
    homework_id = req.param 'homework_id'
    student = req.param 'student'
    score = req.param 'score'
    message = ""
    (error, homework) <- Homework.find-one {id:homework_id}
    console.log "error occurs in marking the score with error: "+error if error

    /*判断作业deadline是否已到达*/
    now = new Date!
    if homework.deadline.getTime! < now.getTime!
      message = "mark success!"
      Submit .update {homework_id:homework_id, student:student}, $set:{score:score}, (error) ->
          console.log "error occurs in marking the score with error: "+error if error
    else 
      message="未到截止时间！"
    res.redirect '/hw_view/?homework_id='+homework_id+"&message="+message
  /*-----------------------------------------------------------------------------------*/


  /*------------------------------------提交作业---------------------------------------*/
  router.post '/submit/', is-authenticated, (req, res) !->
    (error, submit) <- Submit.find-one {homework_id: req.param('homework_id'), student: req.param('username')}
    console.log "error occurs in finding submitting homework with error: "+error if error

    error_message = ""
    (error, homework) <- Homework.find-one {id: req.param 'homework_id'}
    console.log "error occurs in finding homework with error: " +error if error

    /*判断作业deadline是否已到达*/
    now = new Date!
    if homework.deadline.getTime! < now.getTime!
      error_message = "时间已截止!"

    /*判断是否存在已提交的作业，若没有，则在数据库中新建一项，否则直接在上面update来修改数据库*/
    if not submit and not error_message
      new-submit = new Submit {
        homework_id: req.param 'homework_id'
        student: req.param 'username'
        content: req.param 'content'
        title: req.param 'title'
      }
      new-submit.save (error)->
      if error
        console.log "Error in saving submit: ", error
        throw error
      else
        console.log "Homework submit success"
    else if not error_message
      Submit .update {homework_id: req.param('homework_id'), student: req.param('username')}, $set:{content: req.param 'content'}, (error) ->
        console.log "error occurs when update the homework submit with error: "+error if error

    if error_message
      res.redirect '/home/?message='+error_message
    else
      res.redirect '/home/?message=upload success'
  /*-----------------------------------------------------------------------------------*/


  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

