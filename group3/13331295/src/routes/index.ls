require! {'express', User:'../models/user', Homework:'../models/homework', fs, path, Uphomework:'../models/uphomework'}
router = express.Router! 

gettheDate = ->
  present = new Date()
  year = present.getFullYear!
  month = present.getMonth!+1
  if month < 10
    month = '0'+month.toString!
  day = present.getDate!
  if day < 10
    day = '0'+day.toString!
  date = year+'-'+month+'-'+day

mkdirsSync = (dirpath, mode, callback) ->
  if fs.existsSync dirpath then true
  else
    if mkdirsSync path.dirname(dirpath), mode
      fs.mkdirSync(dirpath, mode)
      true;

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
    if req.user.identity is 'Teacher'
      res.render 'home_for_teacher', user: req.user
    else
      res.render 'home_for_student', user: req.user

  router.get '/create_homework', is-authenticated, (req, res)!-> res.render 'create_homework'

  router.post '/create_homework', is-authenticated, (req, res)!->
    new-homework = new Homework {
      teacherName: req.user.username
      homeworkName: req.param 'new-homework'
      homeworkDemand: req.param 'new-homework-demand'
      homeworkDeadline: req.param 'homework-deadline-date'
    }
    new-homework.save (error)->
      if error
        console.log "Error in creating homework: ", error
        throw error
      else
        console.log "Create homework success"
        res.redirect '/home'

  router.get '/view_all_homework', is-authenticated, (req, res)!->
    Homework.find {teacherName: req.user.username}, (error, all_homework) !->
      res.render 'view_all_homework', homeworks: all_homework, date:gettheDate()

  router.get '/edit_homework', is-authenticated, (req, res)!->
    value = req.query
    homework_id = value['id']
    Homework.find-one {_id:homework_id} (error, homework)!->
      res.render 'edit_homework', homework: homework

  router.post '/edit_homework', is-authenticated, (req, res)!->
    Homework.findOneAndUpdate {_id:req.param 'id'},{$set:{homeworkDeadline:req.param 'homework-deadline-date'}} (err)!->
      Homework.findOneAndUpdate {_id:req.param 'id'},{$set:{homeworkDemand:req.param 'homework-demand'}} (err)!->
        res.redirect '/view_all_homework'

  router.get '/homework_detail', is-authenticated, (req, res)!->
    value = req.query
    homework_id = value['id']
    Homework.find-one {_id: homework_id} (error, homework)!->
      Uphomework.find {uphomeworkName:homework.homeworkName} (error, all_uphomework)!->
        res.render 'homework_detail', uphomeworks: all_uphomework, homework:homework, date:gettheDate()

  router.post '/homework_detail', is-authenticated, (req, res)!->
    uphomeworkid = req.param 'homework-corrected-id'
    studentName = req.param 'homework-corrected-student'
    Uphomework.findOneAndUpdate {uphomeworkid:uphomeworkid, studentName:studentName}, {$set:{score: req.param 'score'}} (err)!->
      res.redirect '/homework_detail?id='+uphomeworkid

  router.get '/homework-list', is-authenticated, (req, res)!->
    studentName = req.user.username
    Homework.find (error, all_homework) !->
      Uphomework.find (error, all_uphomework)!->
        res.render 'homework-list', homeworks: all_homework, date: gettheDate(), uphomeworks: all_uphomework, studentName:studentName

  router.get '/upload', is-authenticated, (req, res)!->
    value = req.query
    homework_id = value['id']
    Homework.find-one {_id:homework_id} (error, homework)!->
      Uphomework.find-one {uphomeworkName: homework.homeworkName, studentName: req.user.username} (error, result)!->
        res.render 'upload', lastest: result, homework: homework

  router.post '/upload', is-authenticated, (req, res)!->
    obj = req.files.uphomework
    tmp-path = obj.path
    new-path = './src/public/uploads/'+req.param 'homeworkName'
    new-path += (req.param 'homeworkId') + '/'
    mkdirsSync new-path
    [head, tail] = obj.name.split '.'
    new-path += (req.param 'homeworkName') + req.user.username + '.' + tail
    fs.rename tmp-path, new-path, (err)!-> if err then throw err
    Uphomework.find-one {studentName: req.user.username, uphomeworkName: req.param 'homeworkName'} (err, result)!->
      if result
        Uphomework.update {studentName:result.studentName, uphomeworkName: result.uphomeworkName}, {$set: {extend: tail, date: new Date()}}, (err)!->
          res.redirect '/homework-list'
      else
        new-homework = new Uphomework {
          uphomeworkid: req.param 'homeworkId'
          uphomeworkName: req.param 'homeworkName'
          studentName: req.user.username
          extend: tail,
        }
        new-homework.save (err)->
          if err
            throw err
          else 
            res.redirect '/homework-list'

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'
