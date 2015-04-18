require! ['express', '../models/user', '../models/assignment', '../models/handIn']
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
    user.find {userType: 'student'} (err, student) !-> 
      if !assignment
        res.render 'home', user: req.user, stu: student
      else
        AS = {}
        ASS = []
        assignment.find {} (err, assignments) !->
          for as in assignments
            as.content.replace /&nbsp/g ' '
            dl = new Date as.date
            current-time = new Date
            ASS.push {time: current-time, deadline: dl, date: as.date, dbContent: as.content, viewContent: as.content.replace /<br>/g '\r\n'}
          res.render 'home', user: req.user, stu: student, ass : ASS

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  router.get '/publish', (req, res)!->
    res.render 'publish'

  router.post '/home', (req, res)!->
    if req.param 'asct'
      cnt = req.param 'update'         #这里返回的cnt是个二元数组（为什么会这样？？），直接update会取第一元并在结尾加上逗号，故以下取cnt【0】
      cnt[0] = cnt[0].replace /\r\n/g '<br>'
      while cnt[0].match " " != ' '
        cnt[0] = cnt[0].replace " " '&nbsp'
      assignment.update {content: req.param 'asct'} {content: cnt[0], date: req.param 'date'} (err, updated) !->
        if err
          console.log 'err'
      handIn.update {assignment: req.param 'asct'} {assignment: cnt[0], deadline: req.param 'date'} (err, updated) !->
        if err
          console.log 'err'
    else
      ctn = req.param 'publish'
      ctn = ctn.replace /\r\n/g '<br>'
      while ctn.match " " != " "
        ctn = ctn.replace " " '&nbsp'
      new-assignment = new assignment {
        content: ctn
        date: req.param 'date'
      }

      new-assignment.save (error)->
        if error
          console.log "Error in saving user: ", error
          throw error
        else
          console.log "Assignment publishes success"

    res.redirect '/home'

  router.post '/update', (req, res) !->
    assignment.find-one {content: req.param 'asct'} (err, current-assignment) !->    
      if (err)
        console.log 'err'
      else
        res.render 'update' cass : current-assignment

  router.post '/submit', (req,res) !->
    assignment.find-one {content: req.param 'asct'} (err, current-assignment) !->    
      if (err)
        console.log 'err'
      else
        user.find-one {firstName : req.param 'studentName'} (err, current-student) !->
          if err
            console.log 'err'
          else
            res.render 'submit' cass: current-assignment, cstu: current-student

  router.get '/myHomework' (req, res) !->
    handIn.find {student: req.user.firstName} (err, hand-ins) !->
      if err
        console.log 'err'
      else
        HANDIN = []
        for hi in hand-ins
          hi.assignment = hi.assignment.replace /<br>/g '\r\n'
          HANDIN.push {assignment: hi.assignment, grade: hi.grade, answer: hi.answer.replace /<br>/g '\r\n'}
        res.render 'myHomework' handIn: HANDIN
  
  router.post '/myHomework' (req, res) !->
    handIn.find-one {
      student: req.param 'studentName'
      assignment: req.param 'asct'
      } (err, job) ->
      if err
        return (console.log 'err')
      ans = req.param 'submit'
      ans = ans.replace /\r\n/g '<br>'
      while ans.match ' ' != ' '
        ans = ans.replace ' ' '&nbsp'
      if job
        job.answer = ans
        console.log job
        job.save (err) !->
          if err
            console.log 'save err'
      else
        new-hi = new handIn {
          student: req.param 'studentName'
          assignment: req.param 'asct'
          answer: ans
          deadline: req.param 'asdl'
        }
        console.log new-hi
        new-hi.save (err) !->
          if err
            console.log 'save err'
      res.redirect '/myHomework'

  router.get '/answer' (req, res) !->
    handIn.find {student: req.param 'studentName'} (err, hand-ins) !->
      if err
        console.log 'err'
      else
        HANDIN = []
        for hi in hand-ins
          hi.assignment = hi.assignment.replace /<br>/g '\r\n'
          current-time = new Date
          dl = new Date hi.deadline
          HANDIN.push {time: current-time, deadline: dl, assignment: hi.assignment, grade: hi.grade, DBanswer: hi.answer, answer: hi.answer.replace /<br>/g '\r\n'}
        res.render 'answer' handIn: HANDIN, stuName: req.param 'studentName'

  router.post '/answer' (req, res) !->
    handIn.update {answer: req.param 'answer'} {grade: req.param 'grade'} (err, current-hi) !->
      if err
        console.log 'err'
      res.redirect '/answer?studentName=' + req.param 'studentName'