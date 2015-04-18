require! ['express']
require! {Class: '../models/class'}
require! {Homework: '../models/homework'}
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

  router.get '/signout', (req, res)!->
    req.logout!
    res.redirect '/'

  router.get '/CreateNewClass', is-authenticated, (req, res)!-> res.render 'createNewClass', user: req.user
  router.post '/CreateNewClass', is-authenticated, (req, res)!->
    (error, class_) <- Class.find-one {className: req.param 'classname'}
    return (console.log 'Error in add new class: ', error ; done error) if error
    return (console.log 'Class already exists!'; res.redirect '/home') if class_
    return (console.log 'You are not a teacher!'; res.redirect '/home') if req.user.isStudent

    new-class = new Class {
      className: req.param 'classname'
      time: req.param 'time'
      teacher: req.user.username
    }
    new-class.save (error) ->
      if error
        console.log 'Falied to save new class: ', error
        throw error
      else
        console.log 'Create new class successfully!'
        res.redirect '/home'

  router.get '/AllClasses', is-authenticated, (req, res)!->
    (error, class_) <- Class.find
    res.render 'allClasses', user: req.user, classes: class_

  router.get '/class/:classname', is-authenticated, (req, res)!->
    (error, class_) <- Class.find-one {className: req.params.classname}
    res.render 'viewClass', user: req.user, class_: class_

  router.get '/class/:classname/addHomework', is-authenticated, (req, res)!->
    console.log(req.params.classname)
    (error, class_) <- Class.find-one {className: req.params.classname}
    console.log 'adding homework'
    res.render 'addHomework', user: req.user, class_: class_

  router.post '/class/:classname/CreateNewHomework', is-authenticated, (req, res)!->
    (error, class_) <- Class.find-one {className: req.params.classname}
    return (console.log 'Error in add new homework: ', error ; done error) if error

    new-homework = new Homework {
      homeworkName: req.param 'homeworkName'
      className: class_.className
      teacher: class_.teacher
      description: req.param 'description'
      deadline: req.param 'deadline'
    }

    class_.homeworks.push(new-homework)
    class_.save (error) -> if err then return handleError(err) else console.log('Success!')

    new-homework.save (error) ->
      if error
        console.log 'Falied to save new homework: ', error
        throw error
      else
        console.log 'Create new homework successfully!'
        res.redirect '/class/' + class_.className

  router.get '/class/:classname/allHomeworks', is-authenticated, (req, res)!->
    (error, class_) <- Class.find-one {className: req.params.classname}
    res.render 'allHomeworks', user: req.user, class_: class_

  router.post '/join/:classname', is-authenticated, (req, res)!->
    (error, class_) <- Class.find-one {className: req.params.classname}
    return (console.log 'Error in join new class: ', error ; done error) if error

    class_.students.push(req.user.username)
    class_.save (error) -> if error then return handleError(error) else console.log('Success!')
    res.redirect '/allClasses'

  router.get '/class/:classname/:homeworkName/submit', is-authenticated, (req, res)!->
    (error, class_) <- Class.find-one {className: req.params.classname}
    res.render 'submitHomework', user: req.user, class_: class_, homeworkName: req.params.homeworkName

  router.post '/class/:classname/:homeworkName/submit', is-authenticated, (req, res)!->
    (error, class_) <- Class.find-one {className: req.params.classname}
    (error, homework_) <- Homework.find-one {className: req.params.classname, homeworkName: req.params.homeworkName}

    [submit.offdate = 'true' for submit in homework_.submits when submit.student == req.user.username]

    homework_.submits.push {
      student: req.user.username
      content: req.param 'content'
      date: new Date().toLocaleString()
      grade: 'yet not graded'
      offdate: 'false'
    }
    class_.homeworks.pop {homeworkName: req.params.homeworkName}
    class_.homeworks.push homework_
    class_.save()
    homework_.save()

    res.redirect '/class/' + class_.className + '/allHomeworks'

  router.get '/class/:classname/:homeworkName/allSubmissions', is-authenticated, (req, res)!->
    (error, class_) <- Class.find-one {className: req.params.classname}
    var homework_
    for homework in class_.homeworks
      if homework.homeworkName == req.params.homeworkName
        homework_ = homework
    res.render 'allSubmissions', user: req.user, homework_: homework_

  router.post '/class/:classname/:homeworkName/:studentName/updateGrade', is-authenticated, (req, res)!->
    (error, class_) <- Class.find-one {className: req.params.classname}
    (error, homework_) <- Homework.find-one {className: req.params.classname, homeworkName: req.params.homeworkName}

    [submit.grade = req.param 'score' for submit in homework_.submits when submit.offdate == 'false' and submit.student == req.param 'studentName']

    class_.save()
    homework_.save()

    res.redirect '/class/' + class_.className + '/allHomeworks'
