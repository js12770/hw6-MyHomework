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
    #若验证身份为老师
    identity = req.user.identity
    if identity == 'teacher'
      Homework.find {}, (err, homeworks) !->
        res.render 'home', user: req.user, homework : homeworks
    #若验证身份为学生
    else if identity == 'student'
      current = new Date!
      passHomework = {}
      unPassHomework = {}
      Homework.find {'deadline':{ $gte:current}}, (err, homework) !->
        unPassHomework := homework
      Homework.find {'deadline':{ $lt:current}}, (err, homework) !->
        passHomework := homework
        res.render 'home', user: req.user, passHomework : passHomework, unPassHomework : unPassHomework

  router.post '/newHomework', is-authenticated, (req, res) ->
    username = req.user.username
    title = req.param 'title'
    description = req.param 'description'
    deadline = req.param 'deadline'
    if (username && title && description && deadline)
      new-homework = new Homework {
        teacher : username,
        title : title,
        description : description,
        deadline : deadline
      }
      new-homework.save (error)->
        if error
          console.log 'falid to save'
        else
          console.log 'success to save'
          res.redirect '/home'
    else
      console.log 'error in the form'

  router.post '/upload/:_id', is-authenticated, (req, res) ->
    form = new multiparty.Form uploadDir: 'bin/public/files/'
    form.parse req, (err, fields, files) !->
      files-tmp = JSON.stringify(files,null,2)
      if (err)
        console.log 'parse error: ' + err
      else
        input-file = files.file[0]
        up-loaded-path = input-file.path
        if input-file.original-filename
          static-path = '../' + up-loaded-path.replace('bin', '').replace('public','')
          Homework.find req.params, (err, homeworks) !->

            attachment = {
              name : req.user.username,
              time : new Date(),
              mark : "未评分",
              url : static-path
              fujian : input-file.original-filename,
            }
            temp = homeworks[0].attachment
            if attachment.length != 0
              flag = 0
              for i from 0 to temp.length - 1
                if temp[i].name == req.user.username
                  temp[i].time = new Date()
                  temp[i].fujian = input-file.original-filename
                  temp[i].url = static-path
                  flag = 1
                  break
              if flag == 0
                temp.push attachment
            else
              temp.push attachment
            homeworks[0].save!
        res.redirect '/home'

  router.post '/remark/', is-authenticated, (req, res) !->
    homework-id = req.body.homework-id
    student-id = req.body.student-id
    mark = req.body.mark
    homework-id = {_id:homework-id}
    Homework.find homework-id, (err, homeworks) !->
      attachment = homeworks[0].attachment
      username = req.user.username
      for i to attachment.length - 1
        temp = attachment[i]
        if String(temp._id) == student-id
          temp.mark = mark
      homeworks[0].save!
    res.redirect '/home/'

  router.get '/modifyHomework/:_id', is-authenticated, (req, res) !->
    console.log req.params
    Homework.find req.params, (err, homeworks) !->
      temp = homeworks[0]
      res.render 'modifyHomework', user: req.user, homework : homeworks[0]
  
  router.post '/modify/:_id', is-authenticated, (req, res) !->
    Homework.find req.params, (err, homeworks) !->
      username = req.user.username
      title = req.param 'title'
      description = req.param 'description'
      deadline = req.param 'deadline'
      temp = homeworks[0]
      if (deadline and title and description)
        temp.title = title
        temp.description = description
        temp.deadline = deadline
        homeworks[0].save!
        res.redirect '/home'
      else
        console.log 'error in the form'

  router.get '/home/:_id', is-authenticated, (req, res) !->
    Homework.find req.params, (err, homeworks) !->
      dead-or-not = homeworks[0].deadline.value-of! > new Date().value-of!
      res.render 'detail', user: req.user, homework : homeworks[0], dead-or-not: dead-or-not

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

