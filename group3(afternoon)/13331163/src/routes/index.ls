require! { User: '../models/user', Course: '../models/course', Homework: '../models/homework' Util: '../public/js/util', Requirement: '../models/requirement' 'express'}
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

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  router.get '/home', is-authenticated, (req, res)!->
    (error, courses) <- Course.find {}
    return (console.log 'Error in get all courses: ', error) if error
    (error, mycourses) <- Course.find {username: req.user.username}
    return (console.log 'Error in get my courses: ', error) if error
    res.render 'home', { courses: (Util.unique courses), mycourses: (Util.unique mycourses), user: req.user}


  router.post '/addcourse', (req, res)!->
    new-course = new Course {
      coursename: req.param 'coursename'
      username: req.user.username
    }
    new-course.save (error)->
      if error
        console.log "Error in saving course: ", error
        throw error
      else
        console.log "Course Added success"
    res.redirect '/home'

  router.get '/entercourse', (req, res)!->
    new-course = new Course {
      coursename: req.param 'coursename'
      username: req.user.username
    }
    new-course.save (error)->
      if error
        console.log "Error in saving course: ", error
        throw error
      else
        console.log "Course Added success"
    res.redirect '/home'

  router.get '/homework', (req, res)!->
    (error, courses) <- Course.find {}
    return (console.log 'Error in get all courses: ', error) if error
    (error, mycourses) <- Course.find {username: req.user.username}
    return (console.log 'Error in get my courses: ', error) if error
    (error, requirements) <- Requirement.find {coursename: (req.param 'coursename')}
    return (console.log 'Error in get requirements: ', error) if error
    (error, homeworks) <- Homework.find {coursename: (req.param 'coursename')}
    return (console.log 'Error in get homeworks: ', error) if error
    res.render 'homework', { courses: (Util.unique courses), mycourses: (Util.unique mycourses), user: req.user, requirements: requirements, homeworks: homeworks}

  router.post '/addhomework', (req, res)!->
    console.log (new Date(req.param 'deadline'))
    new-requirement = new Requirement {
      coursename: req.param 'coursename'
      requirementname: req.param 'requirementname'
      requirementcontent: req.param 'requirementcontent'
      deadline: req.param 'deadline'
    }
    new-requirement.save (error)->
      if error
        console.log "Error in saving requirement: ", error
        throw error
      else
        console.log "Requirement Added success"
    res.redirect '/home'

  router.post '/submithomework', (req, res)!->
    Homework.update {
      coursename: req.param 'coursename'
      requirementname: req.param 'requirementname'
      username: req.user.username
      }, {
        coursename: req.param 'coursename'
        requirementname: req.param 'requirementname'
        username: req.user.username
        content: req.param 'content'
        score: 'none'
        }, {
          multi: true
          upsert: true
          }, (error, numberAffected, rawResponse)->
            return (console.log 'Error in update homework: ', error) if error
            console.log numberAffected
    res.redirect '/home'
    # new-homework = new Homework {
    #   coursename: req.param 'coursename'
    #   requirementname: req.param 'requirementname'
    #   username: req.user.username
    #   content: req.param 'content'
    #   score: undefined
    # }
    # new-homework.save (error)->
    #   if error
    #     console.log "Error in saving homework: ", error
    #     throw error
    #   else
    #     console.log "Homework Added success"
    # res.redirect '/home'

  router.post '/mark', (req, res)!->
    console.log (req.param 'coursename')
    console.log (req.param 'requirementname')
    console.log req.user.username
    Homework.find {}, (error, homeworks)->
      return (console.log 'Error in get homeworks: ', error) if error
      console.log homeworks

    Homework.update {
      coursename: (req.param 'coursename')
      requirementname: (req.param 'requirementname')
      username: (req.param 'username')
      }, {
        score: (req.param 'score')
        }, {
          multi: true
          }, (error, numberAffected, rawResponse)->
            return (console.log 'Error in update score: ', error) if error
    res.redirect '/home'

  router.post '/updaterequirement', (req, res)!->
    Requirement.update {
      coursename: req.param 'coursename'
      requirementname: req.param 'requirementname'
      }, {
        requirementcontent: req.param 'requirementcontent'
        }, (error, numberAffected, rawResponse)->
          return (console.log 'Error in update requirement: ', error) if error
    res.redirect '/home'