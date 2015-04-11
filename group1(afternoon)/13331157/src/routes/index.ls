require! ['express']
require! {Homework: '../models/homework', Submit:'../models/submit'}

router = express.Router! 
is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/login'

formate-date = (date)->
  y = date.getFullYear!
  m = date.getMonth!+1
  d = date.getDate!
  if m < 10
    m = '0'+m
  if d < 10
    d = '0'+d
  return y+'-'+m+'-'+d

markdown = require 'markdown' .markdown

module.exports = (passport)->
# index页面
  router.get '/', is-authenticated, (req, res)!->
    Homework.find (err, obj) ->
      if err
        console.log "error"
      else
        date = new Date
        for item in obj
          item.description = markdown.toHTML item.description
          item.startDate = formate-date item.start
          item.endDate = formate-date item.end
        res.render 'index', {
          user: req.user
          homeworks: obj
          date: date
        }
# 登陆
  router.get '/login', (req, res)!-> res.render 'login', message: req.flash 'message'
  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/', failure-redirect: '/login', failure-flash: true
  }
# 注册
  router.get '/signup', (req, res)!-> res.render 'register', message: req.flash 'message'
  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: '/', failure-redirect: '/signup', failure-flash: true
  }
# home页面
  router.get '/home', is-authenticated, (req, res)!->
    if req.user.type == 'student'
      Submit.find {author:req.user.username},(err, obj)->
        for item in obj
          item.description = markdown.toHTML item.description
        res.render 'home', {user: req.user,submits:obj,homeworks:null}
    else if req.user.type == 'teacher'
      Homework.find {},(err, obj)->
        for item in obj
          item.description = markdown.toHTML item.description
        res.render 'home', {user: req.user,submits:null,homeworks:obj}
# 登出
  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/login'
# 发布新作业
  router.get '/post', is-authenticated, (req, res)!->
    if req.user.type == 'teacher'        # 只允许老师访问
      res.render 'post', {user: req.user, homework:null}
    else
      res.redirect '/'

  router.post '/post', is-authenticated, (req, res)!->
    if req.user.type == 'teacher'
      homework = new Homework(
        title       : req.param 'title'
        description : req.param 'description'
        start       : req.param 'start'
        end         : req.param 'end'
        submits     : '0' )
      console.log homework
      homework.save (error)!->
        if error
          console.log "Error in saving homework: ", error
          throw error
        else
          console.log "Homework registration success"
          res.redirect '/'
    else
      res.redirect '/'
# 重新编辑已发布的作业
  router.get '/post/:title' (req, res)!->
    if req.user.type == 'teacher'
      Homework.find-one {title:req.params.title},(err, obj)->
        overtime = null
        date = new Date
        if obj == null || obj.end < date
          overtime = false
        else
          overtime = true
        obj.startDate = formate-date obj.start
        obj.endDate = formate-date obj.end
        res.render 'post', {user:req.user, homework:obj, overtime:overtime}
    else
      res.redirect '/'

  router.post '/post/:_title', is-authenticated, (req, res)!->
    if req.user.type == 'teacher'
      Homework.remove {title:req.param '_title'}, (error)!->
        if error
          console.log "error"
          throw error
      homework = new Homework(
        title       : req.param 'title'
        description : req.param 'description'
        start       : req.param 'start'
        end         : req.param 'end'
        submits     : '0'
      )
      homework.save (error)->
        if error
          console.log "error"
          throw error
        else
          res.redirect '/'
    else
      res.redirect '/'

# 学生发布作业解答
  router.get '/submit/:_title', is-authenticated, (req, res) !->
    title = req.param '_title'
    date = new Date
    Homework.find-one {title:title},(err, hom) ->
      overtime = null
      if hom = null || hom.end > date
        overtime = true
      else
        overtime = false
      Submit.find-one {author:req.user.username, homework:req.param '_title'},(err, obj)!->
        res.render 'submit' {overtime : overtime, sub:obj, title:req.param '_title'}

  router.post '/submit/:_title', is-authenticated, (req, res) !->
    Submit.remove {author:req.user.username, homework:req.param '_title',}, (error)!->
      if error
        console.log "error"
        throw error
    date = new Date()
    submit = new Submit(
      author      : req.user.username
      homework    : req.param '_title'
      title       : req.param 'title'
      description : req.param 'description'
      grade       : null
      time        : date
    )
    submit.save (error) ->
      if error
        console.log 'error'
        throw error
    res.redirect '/'

# 查看、检查学生所发布的作业
  router.get '/homework/:_title', is-authenticated, (req,res)!->
    date = new Date
    Homework.find-one {title:req.param '_title'},(err, hom) ->
      overtime = null
      if hom = null || hom.end > date
        overtime = true
      else
        overtime = false
      Submit.find {homework:req.param '_title'},(error, obj)-> 
        for item in obj
          item.description = markdown.toHTML item.description
        res.render 'homework' {user:req.user, submits:obj, , overtime:overtime, title:req.param '_title'}

  router.get '/homework/:_title/:_author', is-authenticated, (req,res)!->
    name = req.param '_author'
    homework = req.param '_title'
    Submit.find {homework:homework, author:name},(error, obj)-> 
      console.log obj
      for item in obj
        item.description = markdown.toHTML item.description
      res.render 'homework' {user:req.user,submits:obj, title: req.param '_title'}

# 设置分数
  router.post '/grades/:_author/:_title', is-authenticated, (req, res)!->
    if req.type == 'teacher'
      update = ($set:{grade: req.param 'grade'})
      author = req.param '_author'
      homework = req.param '_title'
      Submit.update {author:author, homework:homework},update,(err, num,raw)->
        if err
          throw err
        else
          res.redirect '/homework/'+req.param '_title'
    else
      res.redirect '/'