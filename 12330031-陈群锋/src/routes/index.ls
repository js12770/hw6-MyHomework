require! {Homework:'../models/homeworkList', 'express'}
router = express.Router! 
require! ['mongoose']
multiparty = require('multiparty')
fs = require('fs')

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
    if req.user.identity == 'teacher'
      Homework.find {}, (err, homeworks) !->
        res.render 'home', user: req.user, homework : homeworks
    else if req.user.identity == 'student'
      current = new Date!
      Homework.find {'deadline':{ $gte:current}}, (err, new-homework) !->
        res.render 'home', user: req.user, new-homework : new-homework, homework : {}
  router.post '/homework' , (req, res) ->
    new-homework = new Homework {
      teacher : req.user.username
      title : req.param 'title'
      description : req.param 'description'
      deadline : req.param 'deadline',
    }
    new-homework.save (error)->
      if error
        console.log 'error'
      else
        console.log 'success'
        res.redirect '/home'

  router.post '/upload/:_id', (req, res) ->
    dstPath = ""
    form = new multiparty.Form uploadDir: 'bin/public/files/'
    form.parse req, (err, fields, files) !->
      filesTmp = JSON.stringify(files,null,2)
      if (err)
        console.log 'parse error: ' + err
      else
        console.log 'parse files: ' + filesTmp
        inputFile = files.file[0]
        uploadedPath = inputFile.path
        staticPath = uploadedPath.replace('bin', '').replace('public','')
        console.log staticPath
        dstPath := 'files/' + inputFile.originalFilename
        Homework.find req.params, (err, homeworks) !->
          console.log '-------------------------------'
          attachment = {
            name : req.user.username,
            time : new Date(),
            mark : "未评分",
            url : '../'+staticPath
            fujian : inputFile.originalFilename,
          }
          console.log attachment
          if (homeworks[0].attachment.length != 0)
            flag = 0
            for i from 0 to homeworks[0].attachment.length - 1
              if homeworks[0].attachment[i].name == req.user.username
                homeworks[0].attachment[i].time = new Date()
                homeworks[0].attachment[i].fujian = inputFile.originalFilename
                homeworks[0].attachment[i].url = '../'+staticPath
                flag = 1
                break
            if flag == 0
              console.log 123
              homeworks[0].attachment.push attachment
          else
            homeworks[0].attachment.push attachment
          homeworks[0].save!
        
        fs.rename uploadedPath, dstPath, (err) !->
          if (err)
            console.log 'rename error: ' + err
          else
            console.log 'rename ok'
        res.redirect '/home'


  router.get '/home/:_id', is-authenticated, (req, res) !->
    Homework.find req.params, (err, homeworks) !->
      res.render 'detail', user: req.user, homework : homeworks[0]

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

