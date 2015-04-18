require! {'express', Course:'../models/course', Homework:'../models/homework', HomeworkDetail:'../models/homework_detail', fs:'fs'}
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

  router.get '/home', is-authenticated, (req, res)!-> res.redirect '/mainpage'
    # console.log is-authenticated

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

# register the course controller
router.post '/controllers/course', is-authenticated, (req, res) !->
  Course.find {
    course_name: req.param 'course'
    role: req.param 'role'
  }, (error, isExsistented) !->
    temp = req.param 'role'
    len = isExsistented.length
    if len != 0 && temp is 'teacher'
      # course.log 'here'
      message = "The course has been registered by other teacher, you could not register it as a teacher again!"
      res.render 'register_course', message: message
    else
      new-course = new Course {
        course_name: req.param 'course'
        role: req.param 'role'
        role_name: req.user.username
      }
      new-course.save (error) !->
        if error
          console.log 'Register course fail!'
          throw error
        else
          if 'teacher' is req.param 'role'
            console.log 'Course register successfully(tecaher)!'
            res.render 'public_homework', user: req.user
          else
            console.log 'Course register successfully(student)!'
            res.redirect '/mainpage'

# show the detail page for teacher or student
router.get '/mainpage', is-authenticated, (req, res) !->
  Course.find-one {role_name: req.user.username}, (error, isfind) !->
      if error
        console.log 'Query fail when render the page!'
        throw error
      else if isfind
        if 'teacher' is isfind.role
          homeworkdetail = []
          homeAllName = []
          Homework.find {
            participator: req.user.username
            role: 'teacher'
          }, (error, homework) !->
            if error
              console.log 'Find Homework fail!'
              throw error
            else
              for val in homework
                homeAllName.push(val.homework_name)
              HomeworkDetail.find {
                homework_name: {$in : homeAllName}
              }, (error, hw)!->
                # console.log hw
                if error
                  console.log 'Find HomeworkDetail fail!'
                  throw error
                else
                  homeworkdetail.push(hw)
                  if req.param 'homework'
                    is-modify-homework-name = req.param 'homework'
                    HomeworkDetail.find-one {
                      possessor: req.user.username
                      homework_name: req.param 'homework'
                    }, (error, whichHomeworkReturn) !->
                      res.render 'public_homework', user: req.user, homework: homework, ModifyHomeworkName: is-modify-homework-name, homeworkdetail: hw, whichHomeworkReturn: whichHomeworkReturn
                  else
                    res.render 'public_homework', user: req.user, homework: homework, homeworkdetail: hw
        else
          Homework.find {
            participator : req.user.username
            role: 'student'
          }, (error, has_participated) !->
            if error
              console.log 'Find the has_participated course fail!'
              throw error
            else
            #  get the detail of the homework the student has participated
              has_participated_detail = []
              has_participated.forEach (has_add) !->
                HomeworkDetail.find-one {
                  possessor: has_add.possessor
                  homework_name: has_add.homework_name
                }, (error, each_detail) !->
                  if error
                    console.log 'Find each homeworkdetail fail!'
                    throw error
                  else
                    time = new Date()
                    now = time.getFullYear! + '-' + time.getMonth! + '-' + time.getDate! + ' ' + time.getHours! + ':' + time.getMinutes!
                    each_detail.original_name = has_add.original_name
                    each_detail.dest_name = has_add.dest_name
                    if each_detail.deadline < now
                      has_add.status = '不能提交，已过期'
                    each_detail.status = has_add.status
                    has_participated_detail.push(each_detail)
              # get the names of the homework the student has participated
              has_participated_name = []
              for each_name in has_participated
                has_participated_name.push(each_name.homework_name)
              # get the homework the student has not participated
              Homework.find {
                role: 'teacher'
                homework_name: {$nin: has_participated_name}
              }, (error_for_can_participate, can_participate) !->
                if error_for_can_participate
                  console.log 'Find the course can be added fail!'
                  throw error_for_can_participate
                else
                # get the detail of the homework the student didn't participate
                  has_not_participated_detail = []
                  can_participate.forEach (has_not_add) !->
                    HomeworkDetail.find-one {
                      homework_name: has_not_add.homework_name
                      possessor: has_not_add.possessor
                    }, (error, each_detail) !->
                      if error
                        console.log 'Find the detail of the homework that the student has not participated fail!'
                        throw error
                      else
                        each_detail.original_name = has_not_add.original_name
                        each_detail.status = has_not_add.status
                        each_detail.dest_name = has_not_add.dest_name
                        has_not_participated_detail.push(each_detail)
                  # find the course
                  Course.find {
                    $and: [{role: 'student'},{role_name: req.user.username}]
                  }, (error, participated_for_course) !->
                    if error
                      console.log 'Find the participated course fail!'
                      throw error
                    else
                      Course.find {
                          role: {$nin: ['student']}
                      }, (error, participate_for_course) !->
                        if error
                          console.log 'Find the course can participate fail!'
                          throw error
                        else
                          successful = 0
                          message = ''
                          hasMessage = 0
                          console.log req.param 'success'
                          if req.param 'success' is 1
                            successful = 1
                          else
                            successful = -1
                          if req.param 'message'
                            message = req.param 'message'
                            hasMessage = 1
                          res.render 'student_homework', user: req.user, participate_homework: has_not_participated_detail, participated_homework: has_participated_detail, participate_for_course: participate_for_course, participated_for_course: participated_for_course, message: message, successful: successful, hasMessage: hasMessage
                          console.log 'In student page'
      # if not find the the relative course, then redirect to the register course page
      else
        res.render 'register_course', user: req.user
        console.log 'In role choose page'

# the teacher public or modify the homework controller
router.post '/public-or-modify', is-authenticated, (req, res) !->
  if req.param 'homework'
    HomeworkDetail.update {$and: [
      {homework_name: req.param 'homework'},
      {possessor: req.user.username}
      ]},
      {$set: {
      requires: req.param 'homeworkRequire'
      deadline: req.param 'homeworkDeadline'
      }}, false, (error) !->
          if error
            console.log 'update homeworkdetail fail!'
            throw error
          else
            console.log 'update homeworkdetail successfully!'
            d = new Date()
            res.redirect '/mainpage?ca=' + d
  else
    new-homework = new Homework {
      homework_name: req.param 'homeworkName'
      participator: req.user.username
      role: 'teacher'
      possessor: req.user.username
    }
    new-homeworkDetail = new HomeworkDetail {
      homework_name: req.param 'homeworkName'
      content: req.param 'homeworkContent'
      requires: req.param 'homeworkRequire'
      deadline: (req.param 'homeworkDeadline-date') + ' ' + (req.param 'homeworkDeadline-time')
      possessor: req.user.username
    }
    new-homework.save (error) !->
      if error
        console.log 'Save homework fail!'
        throw error
      else
        new-homeworkDetail.save (error) !->
          if error
            console.log 'Save HomeworkDetail fail!'
            throw error
          else
            res.redirect '/mainpage'

router.post '/participateHomework', is-authenticated, (req, res) !->
  new-homework = new Homework {
    homework_name: req.param 'homework_name'
    role: 'student'
    possessor: req.param 'possessor'
    participator: req.user.username
    status: '未交'
  }
  new-homework.save (error) !->
    if error
      console.log 'participate Homework fail!'
      throw error
    else
      console.log 'Participate Homework successfully!'
      res.redirect '/mainpage'

router.post '/participateCourse', is-authenticated, (req, res) !->
  new-course = new Course {
    course_name: req.param 'course_name'
    role: 'student'
    role_name: req.user.username
    possessor: req.user.username
  }
  new-course.save (error) !->
    if error
      console.log 'Participate Course fail!'
      throw error
    else
      console.log 'Participate Course successfully!'
      res.redirect '/mainpage'


router.post '/upload', is-authenticated, (req, res) !->
  time = new Date()
  now = time.getFullYear! + '-' + time.getMonth! + '-' + time.getDate! + ' ' + time.getHours! + ':' + time.getMinutes!
  console.log now
  HomeworkDetail.find-one {
    possessor: req.param 'possessor'
    homework_name: req.param 'homework_name'
    deadline: {$gte: now}
  }, (error, is-not-kong) !->
    if !is-not-kong
      console.log 'fsdsfd'
      res.redirect '/mainpage'
    else
      username = req.user.username
      upfile = req.files.upfile
      email = req.user.email
      possessor = req.param 'possessor'
      hw = req.param 'homework_name'
      console.log hw
      console.log possessor
      if upfile
        files = []
        if upfile instanceof  Array
          files = upfile
        else
          files.push(upfile)
        for file in files
          name = file.name
          # upload file in server rules
          file-name-of-last = username + possessor + hw + Math.random() + '.' + file.extension
          target_path = 'upload-homework/' + file-name-of-last
          console.log target_path
          dest_name = file-name-of-last
          path = file.path
          fs.rename path, target_path, (error) !->
            if error
              console.log 'Move file occurs wrongly!'
              # fs.unlink path
              date = new Date()
              fs.unlink path
              res.redirect '/mainpage?newdate=' + date
              throw error
            else
              Homework.update {
                $and: [
                  {role: 'student'},
                  {participator: req.user.username},
                  {possessor: req.param 'possessor'},
                  {homework_name: req.param 'homework_name'}
                ]
              }, {
                $set: {
                  original_name: file.originalname
                  dest_name: dest_name
                  status: '已交'
                }
              }, false, (error) !->
                  console.log dest_name
                  if error
                    console.log 'Save information of homework to database fail!'
                    throw error
                  else
                    console.log 'Save information of homework to database successfully!'
                    date = new Date()
                    res.redirect '/mainpage?newdate=' + date + '&success=1' 
      else
        message = 'There is no file chosen!'
        res.redirect '/mainpage?message=' + message

router.get '/download', is-authenticated, (req, res) !->
  path = 'upload-homework/' + req.param 'destName'
  name = req.param 'destName'
  res.download path, (error) !->
    if error
      console.log 'Download Fail!'
      res.redirect '/mainpage'
      throw error
    else
      console.log 'Download successfully!'
      if req.param 'role' is 'student'
        res.redirect '/mainpage'
      else
        res.redirect '/detail'


router.get '/detail', is-authenticated, (req, res) !->
  homework_name = req.param 'homework'
  HomeworkDetail.find-one {
    homework_name: homework_name
    possessor: req.user.username
  }, (error, single-homework-in-detail) !->
    if error
      console.log 'Find Homework Detail fail!'
      res.redirect '/mainpage'
      throw error
    else
      Homework.find {
        homework_name: homework_name
        possessor: sys = req.user.username
        role: 'student'
      }, (error, participator-in-single-homework) !->
        if error
          console.log 'Find Students Fail!'
          res.redirect '/mainpage'
          throw error
        else
          console.log 'Get information successfully of' + homework_name
          time = new Date()
          participatorInSingleHomework = participator-in-single-homework
          participatorInSingleHomework.modify = ''
          now = time.getFullYear! + '-' + time.getMonth! + '-' + time.getDate! + ' ' + time.getHours! + ':' + time.getMinutes!
          if now > single-homework-in-detail.deadline
            participatorInSingleHomework.modify = 'can-modify'

          res.render 'teacher_homework_detail', sigleHomeworkInDeatil: single-homework-in-detail, participatorInSingleHomework: participatorInSingleHomework

router.post '/modify', is-authenticated, (req, res) !->
  time = new Date()
  now = time.getFullYear! + '-' + time.getMonth! + '-' + time.getDate! + ' ' + time.getHours! + ':' + time.getMinutes!
  console.log 'sdfsfdkdfsalk;ad;kl;'
  if now > single-homework-in-detail.deadline
    Homework.update {
      $and: [{possessor: req.user.username}, {homework_name: req.param 'homework_name'}, {role: 'student'}, {participator: req.param 'student_name'}]
    }, {
      $set: {
        score: req.param 'score'
      }
    }, false, (error) !->
      if error
        console.log 'score Fail!'
        res.redirect '/detail?homework=' + req.param 'homework_name'
        throw error
      else
        console.log 'successfully score!'
        res.redirect '/detail?homework=' + req.param 'homework_name'
  else
    console.log 'Deadline is not now!'
    res.redirect '/detail?homework=' + req.param 'homework_name'






