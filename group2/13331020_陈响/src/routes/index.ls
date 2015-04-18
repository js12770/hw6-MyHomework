require! ['express']
require! {HwPublish:'../models/hwPublish'}
require! {HwSubmit:'../models/hwSubmit'}
router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

#显示所有的作业
show-HwPublish = (req, res, next)!->
  all-HwPublish = {}
  if req.user.identity == 'teacher'
    all-HwPublish = {teacher: req.user.username}

  #按老师来查找作业
  HwPublish.find all-HwPublish, (error, hwPublish)!->
    if hwPublish
      if req.user.identity == 'teacher'
        #老师进入作业修改或发布新作业界面
        res.render 'publishhw', {
          HwPublish: hwPublish,
        }
      else
      #学生进入作业提交页面
        res.render 'submithw', {
          HwPublish: hwPublish,
        }

#显示所有提交的作业
show-HwSubmit = (req, res, next)!->
  all-HwSubmit = {}
  if req.user.identity == 'student'
    all-HwSubmit = {student: req.user.username}
    
  #按学生名字来查找作业
  HwSubmit.find all-HwSubmit, (error, hwSubmit)!->
    #对每个提交的作业，进入评分界面
    res.render 'getscore' {
      HwSubmit: hwSubmit,
      #传递当前用户的信息，以判断是学生还是老师
      user: req.user,
    }


#存储新发布或修改的作业
Save-publishedHW = (req, res, next)!->
  all-HwPublish = {hwid: req.param 'hwid'}

  new-HwPublish-data = {
    hwid: req.param 'hwid'
    requirement: req.param 'requirement'
    teacher: req.user.username
    deadline: req.param 'deadline'
  }
  #查询现有的所有作业
  HwPublish.find all-HwPublish, (err, hwPublish)!->
    #发现id重复的作业，进行修改
    if hwPublish.length != 0
      HwPublish.update all-HwPublish, new-HwPublish-data, (err, HwPublish1)!->
        console.log "Update the homework publish"
        show-HwPublish req, res
    #没有重复的作业，即为新发布的作业，存储新作业
    else
      new-HwPublish = new HwPublish new-HwPublish-data
      new-HwPublish.save (error)->
        if error
          console.log "Error in publish homework", error
          throw error
        else
          console.log "Homework publish success", new-HwPublish
          show-HwPublish req, res

#存储学生提交或修改的作业
Save-submitedHW = (req, res, next)!-> 
  all-HwSubmit = {student: req.user.username, hwid: req.param 'hwid'}

  new-HwSubmit-data = {
    content: req.param 'content'
    hwid: req.param 'hwid'
    student: req.user.username
    submittime: new Date()
  }

  #查询该作业的截止日期，判断可否修改
  query-hwid-deadline = {hwid: req.param 'hwid'}
  HwPublish.find query-hwid-deadline, (err, hwPublish)!->
    #作业列表无该id
    if hwPublish.length == 0
      show-HwPublish req, res

    else
      submittime = new Date()
      #已过时，则什么也不做，返回现实作业列表
      if submittime > Date(hwPublish.deadline)
        show-HwPublish req, res
      #没有过时
      else
        HwSubmit.find all-HwSubmit, (err, hwSubmit)!->
          #没有相同id下的作业，则提交作业
          if hwSubmit.length == 0
            new-HwSubmit = new HwSubmit new-HwSubmit-data
            new-HwSubmit.save (error)->
              if error
                console.log "Error in submit homework", error
                throw error
              else
                console.log "Homework submit success", new-HwSubmit
                show-HwSubmit req, res

          #已有该id下提交的作业，则进行修改
          else
           console.log "old one", hwSubmit
           HwSubmit.update all-HwSubmit, new-HwSubmit-data, (err, HwSubmit1)!->
            console.log "Homework update success", new-HwSubmit-data
            show-HwSubmit req, res      

#给分
givehwscore = (req, res, next)!-> 
  #查询作业相关信息
  score = req.param 'score'
  hwid: req.param 'hwid'
  student: req.param 'student'

  all-HwSubmit = 
                      student: req.param 'student'
                      hwid: req.param 'hwid'

  #找到该作业并进行更改
  HwSubmit.update all-HwSubmit, {$set: {score:score}} (err, HwSubmit1)!->
    console.log "Homework give score success", score
    show-HwSubmit req, res



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

  router.get '/hwsubmit', is-authenticated, (req, res)!-> show-HwPublish req, res

  router.post '/hwsubmit', is-authenticated, (req, res)!-> Save-submitedHW req, res

  router.get '/hwpublish', is-authenticated, (req, res)!-> show-HwPublish req, res

  router.post '/hwpublish', is-authenticated, (req, res)!-> Save-publishedHW req, res

  router.get '/hwscore', is-authenticated, (req, res)!-> show-HwSubmit req, res

  router.post '/hwscore', is-authenticated, (req, res)!-> givehwscore req, res