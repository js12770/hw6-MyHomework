require! {'express', 'path', 'fs', Homeworks:'../models/homework', HomeworkUpload:'../models/homeworkuploaded'}
router = express.Router! 
moment = require 'moment'

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

module.exports = (passport)->
  router.get '/', (req, res)!-> res.render 'index', message: req.flash 'message'

  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/info', failure-redirect: '/', failure-flash: true
  }

  router.get '/signup', (req, res)!-> res.render 'register', message: req.flash 'message'

  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: '/info', failure-redirect: '/signup', failure-flash: true
  }

  router.get '/info', is-authenticated, (req, res)!-> res.render 'info', user: req.user

  router.get '/signout', (req, res)!-> req.logout!; res.redirect '/'

  router.get '/home', is-authenticated, (req, res)!-> res.render 'home', user: req.user

  router.get '/allhomeworks', is-authenticated, (req, res)!->
    Homeworks.findAll {}, (result)->
      if result.length < 1 then console.log msg = "No homeworks found." else console.log result
      res.render 'allhomeworks', {user: req.user, homeworks: result, moment: moment, message: msg if msg}

  router.get '/check/:id', is-authenticated, (req, res)!->
    condition = {homeworkName: req.params.id}
    if req.user.role is 'student'
      if req.params.id is req.user.username then condition = {student: req.params.id} else res.redirect '/home'; return
    HomeworkUpload.findAll condition, (result)!->
      if result.length < 1
        console.log msg = "No homeworks submit."
      res.render 'check', {user: req.user, moment: moment, homeworks: result, message: msg if msg}

  router.get '/create', is-authenticated, (req, res)!->
    if req.user.role is 'student' then res.redirect '/home' else res.render 'form', {user: req.user, option: 'create'}

  router.post '/create', is-authenticated, (req, res)!->
    Homeworks.findById {name: req.body.name}, (result)!->
      if result
        console.log msg = "Homework: #{req.body.name} already exists."
        res.render 'form', {user: req.user, option: 'create', message: msg}
      else
        create-res = Homeworks.create req.user, {
          name: req.body.name, requirement: req.body.requirement, deadline: new Date(req.body.deadline.replace('T', ' '))}
        if create-res.error?
          console.log create-res.error; res.render 'form', {user: req.user, option: 'create', message: create-res.error}
        else res.redirect '/allhomeworks'

  router.get '/homework/:op/:id', is-authenticated, (req, res)!->
    if req.user.role is 'teacher' and req.params.op is 'submit' then res.redirect '/home'
    if req.user.role is 'student' and req.params.op is 'update' then res.redirect '/home'
    Homeworks.findById {name: req.params.id}, (result)!->
      if result then res.render 'form', {user: req.user, homework: result, moment: moment, option: req.params.op}
      else console.log msg = "Homework: #{req.params.id} not exists."; res.redirect '/home'

  router.post '/update/:id', is-authenticated, (req, res)!->
    Homeworks.findById {name: req.params.id}, (result)->
      if result
        new-date = new Date(req.body.deadline.replace('T', ' '))
        if new-date < result.startDate
          console.log msg = "Invalid Deadline."
          res.render 'form', {user: req.user, homework: result, moment: moment, option: 'update', message: msg}
        else
          if new-date.get-time! isnt result.deadline.get-time! then Homeworks.updateDeadline {name: result.name}, new-date
          if req.body.requirement isnt result.requirement then Homeworks.updateRequirement {name: result.name}, req.body.requirement
          res.redirect '/allhomeworks'
      else console.log msg = "Homework: #{req.params.id} not exists."; res.redirect '/allhomeworks'

  router.post '/submit/:id', is-authenticated, (req, res)!->
    Homeworks.findById {name: req.params.id}, (result)!->
      if result
        if result.deadline.get-time! < Date.now!
            res.render 'form', {user: req.user, homework: result, moment: moment, option: 'submit', message: 'You can not submit anymore.'}
        else
          if req.files.upfile? and req.files.upfile.size > 0 and req.files.upfile.extension is 'zip'
            upload-file = req.files.upfile
            temp_path = upload-file.path
            #target_path = path.join __dirname, '../public/stuhomeworks/', upload-file.name
            target_path = path.join __dirname, '../../stuhomeworks/', upload-file.name
            fs.rename temp_path, target_path, (error)!->
              if error then console.log error else console.log 'Upload file success.'
            HomeworkUpload.findById {homeworkName: req.params.id, student: req.user.username}, (result)!->
              if result
                HomeworkUpload.updateCommitment {homeworkName: result.homeworkName, student: req.user.username}, req.body.commitment, upload-file.name
              else
                HomeworkUpload.upload {homeworkName: req.body.name, student: req.user.username, commitment: req.body.commitment, filename: upload-file.name}
            Homeworks.updateUploaded {name: req.params.id}, result.uploaded+1
            res.redirect '/check/'+req.user.username
          else res.render 'form', {user: req.user, homework: result, moment: moment, option: 'submit', message: 'Zip files only and no empty files.'}
      else
        res.redirect '/home'

  router.get '/grade/:hwid/:stuid', is-authenticated, (req, res)!->
    if req.user.role is 'student' then res.redirect '/home'
    else HomeworkUpload.findById {homeworkName: req.params.hwid, student: req.params.stuid}, (result)!->
      if result
        Homeworks.findById {name: req.params.hwid}, (hw-result)!-> 
          if hw-result
            result.deadline = hw-result.deadline
            res.render 'grade', {user: req.user, homework: result, moment: moment}
          else console.log 'Relative homework not found.'; res.redirect '/home'
      else console.log msg = "Homework or Student not exists."; res.redirect '/home'

  router.post '/grade/:hwid/:stuid', is-authenticated, (req, res)!->
    HomeworkUpload.findById {homeworkName: req.params.hwid, student: req.params.stuid}, (result)!->
      if result
        HomeworkUpload.updateGrades {homeworkName: req.params.hwid, student: req.params.stuid}, req.body.grades
      else console.log msg = "Homework or Student not exists."
      res.redirect '/check/'+req.params.hwid


  router.get '/download/:hwid/:stuid', is-authenticated, (req, res)!->
    if req.user.role isnt 'teacher' and req.user.username isnt req.params.stuid then res.redirect '/home'
    else HomeworkUpload.findById {homeworkName: req.params.hwid, student: req.params.stuid}, (result)!->
      if result
        #res.download path.join __dirname, '../public/stuhomeworks/', result.filename
        res.download path.join __dirname, '../../stuhomeworks/', result.filename
      else console.log msg = "Homework or Student not exists."; res.redirect '/teacher'
