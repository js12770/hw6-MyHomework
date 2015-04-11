require! {'express', User: '../models/user', Course: '../models/course'}

router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

module.exports = (passport)->
  router.get '/', (req, res)!-> res.render 'login', message: req.flash 'message'

  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/home', failure-redirect: '/', failure-flash: true
  }

  router.get '/signup', (req, res)!-> res.render 'signup', message: req.flash 'message'

  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: '/home', failure-redirect: '/signup', failure-flash: true
  }

  router.get '/home', is-authenticated, (req, res)!->
    if req.user.role is 'student'
      my-courses = []
      Course.find {}, (err, courses)!->
        for course in courses
          if course.students.to-string!index-of(req.user.username) isnt -1
            my-courses.push course
        res.render 'home', data : {user: req.user, courses: my-courses}
    else
      User.find {role: 'student'}, (err, students)!->
        Course.find {creater: req.user.username}, (err, courses)!->
          res.render 'home', data: {user: req.user, students: students, courses: courses}

  router.post '/home', is-authenticated, (req, res)!->
    console.log req.body
    Course.find-one {course-short-name: req.body.courseShortName}, (err, course)!->
      if err
        console.log 'Add course failed'
        res.write '<h1>Add course failed</h1>'
        res.end!

      if course
        console.log course
        msg = 'This course with the same short name has exited!'
        console.log msg
        res.write '<h1>' + msg + '</h1>'
        res.end!
      else
        new-course = new Course {
          creater            :  req.user.username
          course-name        :  req.body.courseName
          course-short-name  :  req.body.courseShortName
          short-discription  :  req.body.shortDiscription
          detail-discription :  req.body.detailDiscription
          students           :  req.body.selectStudent
          homework           :  []
        }
        new-course.save (err)!->
          if err 
            res.write '<h1>Save course error</h1>'
            res.end()
          else
            res.redirect '/home'

  router.get '/:courseShortName/course', is-authenticated, (req, res)!->
    Course.find-one {course-short-name: req.params.courseShortName}, (err, course)!->
      res.render 'course', data: {user: req.user, course: course}

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'
