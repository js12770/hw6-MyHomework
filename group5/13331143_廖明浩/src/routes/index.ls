require! ['express' , '../models/user' , '../models/homework' , 'mongoose', '../models/submit']
router = express.Router!


#getallhomework = (res, req)-> user.find-one {username: 'pml'} (error, user)->return res.render 'home', user : req.user
/*
getallhomework = (res, req)->
  console.log 'enter getallhomework()' 
  (error, homeworks) <- homework.find-one {teacher : 'pml'}
  console.log homeworks
  res.render 'home' , user : req.user*/

getallhomework = (res, req)->
    homework.find {} (error, homeworks) ->
      submit.find { user_id : req.user._id} (error, submits) ->
        res.render 'home' , user : req.user , homeworks : homeworks, submits : submits

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
    #res.render 'home' , user : req.user
    getallhomework res, req

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  router.post '/mark', is-authenticated, (req, res)!->
    submit.find { homework_id : req.param 'homework_id'} (error, submits) ->
      homework.find-one {_id : req.param 'homework_id'} (error, homeworks) ->
        res.render 'mark' , homeworks : homeworks, submits : submits


  router.post '/assign', is-authenticated, (req, res)!->
    new-homework = new homework {
        title : req.param 'title'
        detail : req.param 'detail'
        teacher : req.param 'teacher'
        deadline : req.param 'deadline'
    }
    new-homework.save (error)->
      if error
        console.log "Error in saving homework: ", error
        throw error
      else
        console.log "Homework registration success"
        res.redirect '/home'
        console.log 'redirect home page'

  router.post '/delete', is-authenticated, (req, res)!->
    (error) <- homework.remove {_id : req.param '_id'}
    console.log ' data has been deleted'
    res.redirect '/home'
    console.log 'redirect home page'

  router.post '/modify', is-authenticated, (req, res) !->
    title = req.param 'title'
    detail = req.param 'detail'
    deadline = req.param 'deadline'
    (error) <- homework.update {_id : req.param '_id'}, {$set : {title : title, detail : detail, deadline : deadline}}
    console.log ' data has been updated'
    res.redirect '/home'
    console.log 'redirect home page'

  router.post '/submit', is-authenticated, (req, res)!->
    submit.find { homework_id : req.param 'homework_id'} (error, submits) ->
      if (submits.length == 0)
        new-submit = new submit {
        user_id : req.param 'user_id'
        homework_id : req.param 'homework_id'
        content : req.param 'content'
        grade : req.param 'grade'
        user_name : req.param 'user_name'
        }
        new-submit.save (error)->
          if error
            console.log "Error in saving submit: ", error
            throw error
          else
            console.log "submit registration success"
            res.redirect '/home'
            console.log 'redirect home page'
      else
        content = req.param 'content'
        grade = req.param 'grade'
        (error) <- submit.update {homework_id : req.param 'homework_id'}, {$set : {content : content, grade : grade}}
        console.log ' submitdata has been updated'
        res.redirect '/home'
        console.log 'redirect home page'

  router.post '/give_grades', is-authenticated, (req, res)!->
    (error) <- submit.update {_id : req.param '_id'}, {$set : {grade : req.param 'grade'}}
    submit.find { homework_id : req.param 'homework_id'} (error, submits) ->
      homework.find-one {_id : req.param 'homework_id'} (error, homeworks) ->
        res.render 'mark' , homeworks : homeworks, submits : submits