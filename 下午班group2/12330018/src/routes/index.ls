require! {Homework:'../models/hwModel', 'express'}
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

  #渲染首页
  router.get '/home', is-authenticated, (req, res)!->
    if req.user.identi == 'teacher' 
      Homework.find {}, (err, homeworks) !->
        res.render 'home', user: req.user, hws : homeworks
    else if req.user.identi == 'student'
      Homework.find {}, (err, homeworks) !->
        subs = []
        for index from 0 to homeworks.length-1
          if (homeworks[index].submmits.length != 0)
            for i from 0 to homeworks[index].submmits.length - 1
              if homeworks[index].submmits[i].student == req.user.username
                temp ={
                  submits : homeworks[index].submmits[i]
                  subname : homeworks[index].title
                }
                console.log '------------------分数------------------------'
                console.log homeworks[index].submmits[i].mark
                console.log homeworks[index].submmits[i]
                subs.push temp
        res.render 'home', user: req.user, hws : homeworks, mysubs : subs

  router.post '/home', (req,res) !->
    console.log 'home'

  #新建一个homework
  router.post '/home/savehw', is-authenticated, (req,res)!->
    if req.user.identi == 'teacher'
      new-homework = new Homework {
        teacher : req.user.username
        title : req.param 'hwname'
        content : req.param 'content'
        ddl : req.param 'ddl',
      }
      new-homework.save (error)->
        if error
          console.log 'error'
        else
          console.log 'success'
          res.redirect '/home'
    else
      res.redirect '/'

  #修改一个homework
  router.post '/home/edithw/:_id', is-authenticated, (req,res)!->
    Homework.find req.params, (err, homeworks) !->
      homeworks[0].title = req.param 'hwname'
      homeworks[0].content = req.param 'content'
      homeworks[0].ddl = req.param 'ddl'
      homeworks[0].save (error)->
        if error
          console.log 'error'
        else
          console.log 'success'
          res.redirect '/home'
  #学生提交作业
  router.post '/home/submithw/:_id', is-authenticated, (req,res)!->
    Homework.find req.params,(err,homeworks) !->
      if (homeworks[0].submmits.length != 0)
        for i from 0 to homeworks[0].submmits.length - 1
          if homeworks[0].submmits[i].student == req.user.username
            homeworks[0].submmits[i].time = new Date()
            homeworks[0].submmits[i].essay = req.param 'essay'
            homeworks[0].save!
            res.redirect '/home'
      new-submit ={
        student : req.user.username
        sid : req.param 'sid'
        time : new Date!
        essay : req.param 'essay'
      }
      homeworks[0].submmits.push new-submit
      homeworks[0].save (error)->
        if error
          console.log 'error'
        else
          console.log 'success'
          res.redirect '/home'

  #老师评分
  router.post '/mark/:_student/:_id',(req, res)!->
    Homework.find {_id : req.param '_id'}, (err,hws)!->
      if(hws.length >0)
        for i from 0 to hws[0].submmits.length - 1
          if(hws[0].submmits[i].student == req.param '_student')
            hws[0].submmits[i].mark = req.param 'mark'
            console.log '------------------mark--------------------'
            console.log req.param 'mark'
            console.log hws[0].submmits[i]
            console.log '--------------------------------------'
            console.log hws[0]
            res.redirect '/home'
  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

