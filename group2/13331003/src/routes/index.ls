require! ['express']
require! {HwPublic:'../models/hwpublic'}
require! {HwSumbit:'../models/hwsumbit'}
router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

show-HwPublic = (req, res, next)!-> 
  if req.user.usertype == 'teacher'
    query-old-HwPublic = {teacher: req.user.username}
  else
    query-old-HwPublic = {}

  HwPublic.find query-old-HwPublic, (error, hwPublic)!->
    if hwPublic
      if req.user.usertype == 'teacher'
        res.render 'hwpublic', {
          HwPublic: hwPublic,
        }
      else
        res.render 'hwsumbit', {
          HwPublic: hwPublic,
        }
    else
      console.log "Can not find the hwpublic"


show-HwSumbit = (req, res, next)!->
  if req.user.usertype == 'student'
    query-old-HwSumbit = {student: req.user.username}
  else
    query-old-HwSumbit = {}

  HwSumbit.find query-old-HwSumbit, (error, hwSumbit)!->
    res.render 'hwscore' {
      HwSumbit: hwSumbit,
      user: req.user,
    }
    console.log "render part", hwSumbit



Homework-Public = (req, res, next)!->
  query-old-HwPublic = {course: req.param 'course'}
  new-HwPublic-data = {
    content: req.param 'content'
    course: req.param 'course'
    teacher: req.user.username
    deadline: req.param 'deadline'
  }
  HwPublic.find query-old-HwPublic, (err, hwPublic)!->
    if hwPublic.length != 0
      HwPublic.update query-old-HwPublic, new-HwPublic-data, (err, HwPublic1)!->
        console.log "Update the homework public"
        show-HwPublic req, res
    else
      new-HwPublic = new HwPublic new-HwPublic-data
      new-HwPublic.save (error)->
        if error
          console.log "Error in public homework", error
          throw error
        else
          console.log "Homework public success", new-HwPublic
          show-HwPublic req, res


Homework-Sumbit = (req, res, next)!-> 
  query-old-HwSumbit = {student: req.user.username, course: req.param 'course'}
  new-HwSumbit-data = {
    content: req.param 'content'
    course: req.param 'course'
    student: req.user.username
    date: new Date()
  }
  query-course-deadline = {course: req.param 'course'}
  HwPublic.find query-course-deadline, (err, hwPublic)!->
    if hwPublic.length == 0
      show-HwPublic req, res
    else
      date = new Date()
      if date < Date(hwPublic.deadline)
        show-HwPublic req, res
      else
        HwSumbit.find query-old-HwSumbit, (err, hwSumbit)!->
          if hwSumbit.length == 0
            new-HwSumbit = new HwSumbit new-HwSumbit-data
            new-HwSumbit.save (error)->
              if error
                console.log "Error in sumbit homework", error
                throw error
              else
                console.log "Homework sumbit success", new-HwSumbit
                show-HwSumbit req, res

          else
           console.log "old one", hwSumbit
           HwSumbit.update query-old-HwSumbit, new-HwSumbit-data, (err, HwSumbit1)!->
            console.log "Homework update success", new-HwSumbit-data
            show-HwSumbit req, res      


givehwscore = (req, res, next)!-> 
  score = req.param 'score'
  course: req.param 'course'
  student: req.param 'student'

  query-old-HwSumbit = 
                      student: req.param 'student'
                      course: req.param 'course'
  HwSumbit.update query-old-HwSumbit, {$set: {score:score}} (err, HwSumbit1)!->
    console.log "Homework give score success", score
    show-HwSumbit req, res



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

  router.get '/hwsumbit', is-authenticated, (req, res)!-> show-HwPublic req, res

  router.post '/hwsumbit', is-authenticated, (req, res)!-> Homework-Sumbit req, res

  router.get '/hwpublic', is-authenticated, (req, res)!-> show-HwPublic req, res

  router.post '/hwpublic', is-authenticated, (req, res)!-> Homework-Public req, res

  router.get '/hwscore', is-authenticated, (req, res)!-> show-HwSumbit req, res

  router.post '/hwscore', is-authenticated, (req, res)!-> givehwscore req, res