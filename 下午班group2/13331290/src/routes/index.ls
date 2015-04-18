require! {'express', Homework: '../models/homework', 'mongoose', 'multer', 'fs'}

router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

my-multer = multer {
  dest: 'public/homeworks/'
  rename: (fieldname, filename, req, res)->
    return req.user.id
  changeDest: (dest, req, res)->
    new-dest = dest + req.params.title
    stat = null
    try
      stat = fs.statSync new-dest
    catch error
      fs.mkdirSync new-dest
    return new-dest
}

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
    if req.user.status is 'teacher'
      Homework.find {teacherId: req.user._id}, (error, homeworks)!->
        res.render 'teacher-home', user: req.user, homeworks: homeworks.sort {title: -1}
    else
      Homework.find (error, homeworks)!->
        res.render 'student-home', user: req.user, homeworks: homeworks

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  router.get '/publish', is-authenticated, (req, res)!-> res.render 'publish', user: req.user

  router.post '/publish', is-authenticated, (req, res)!->
    new-homework = new Homework {
      title       : req.body.title
      courseName  : req.body.courseName
      teacherName : req.user.username
      teacherId   : req.user._id
      deadline    : req.body.deadline
      requirement : req.body.requirement
      students    : []
    }
    (error) <-! new-homework.save
    if error
      console.log "Error in saving homework: ", error
      throw error
      res.redirect '/publish'
    else
      console.log "homework publication success"
      res.redirect '/home'

  router.get '/edit/:_id', is-authenticated, (req, res)!->
    (error, homework) <- Homework.find-by-id req.params._id
    return (console.log "Error in edit: ", error) if error

    res.render 'edit', user: req.user, homework: homework

  router.post '/edit/:_id', is-authenticated, (req, res)!->
    (error) <- Homework.find-by-id-and-update req.params._id, {deadline: req.body.deadline, requirement: req.body.requirement}
    return (console.log "Error IN update homework: ", error; throw error) if error

    console.log "homework update success"
    res.redirect '/home'

  router.get '/delete/:_id', is-authenticated, (req, res)!->
    (error) <- Homework.find-by-id-and-remove req.params._id
    return (console.log "Error in delete homework: ", error; throw error) if error

    console.log "homework delete success"
    res.redirect '/home'

  router.get '/p/:_id/:title', is-authenticated, (req, res)!->
    (error, homework) <- Homework.find-by-id req.params._id
    return (console.log "Error in view homework: ", error; throw error) if error

    console.log "homework view success"
    res.render 'view-hw', user: req.user, homework: homework

  router.post '/p/:_id/:title', is-authenticated, my-multer, (req, res)!->
    (error, homework) <- Homework.find-by-id req.params._id
    for student, index in homework.students
      if student.id == req.user.id
        return res.redirect '/home'

    (error) <- Homework.find-by-id-and-update req.params._id, {$push: {students: {'id' : req.user.id, 'name' : req.user.username, 'path': req.user.id + '.zip', 'score': ''}}}
    return (console.log "Error in upload homework: ", error; throw error) if error

    console.log "homework upload success"
    res.redirect '/home'

  router.get '/r/:_id', is-authenticated, (req, res)!->
    (error, homework) <- Homework.find-by-id req.params._id
    return (console.log "Error in revise homework: ", error; throw error) if error

    res.render 'revise-hw', user: req.user, homework: homework

  router.post '/r/:_id', is-authenticated, (req, res)!->
    if typeof req.body.scores is 'string'
      (error) <- Homework.find-by-id-and-update req.params._id, {$set: {'students.0.score': req.body.scores}}
      return (console.log "Error in score homework: ", error; throw error) if error
    else
      for score, index in req.body.scores
        (error) <- Homework.find-by-id-and-update req.params._id, {$set: {('students.' + index.to-string! + '.score'): score}}
        return (console.log "Error in score homework: ", error; throw error) if error

    res.redirect '/home'

  router.get '/download/:filename/:title', is-authenticated, (req, res)!->
    res.download('public/homeworks/' + req.params.title + '/' + req.params.filename)

