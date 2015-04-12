require! ['express','fs','formidable','../controller/homeworkHandler','../controller/requestHandler']
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
    res.render 'home',{user : req.user}

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  router.get '/submit',is-authenticated,(req, res)!->
    res.render 'submit',{user:{username : req.session.uername,role : req.session.role}}

  router.post '/submit',(req, res)!->
    if !req.session.username is true
      res.write JSON.stringify({err:true,msg:'Session is timeout!'})
      res.end()
      return
    form = new formidable.IncomingForm()
    destFilePath = 'bin/public/homework/'
    tmpFilePath = 'bin/public/tmp'
    form.uploadDir = tmpFilePath
    form.parse req,(err,fileds,files) !->
      fs.renameSync files.Filedata.path,destFilePath + files.Filedata.name
      params = {
        username : req.session.username,
        filename : files.Filedata.name,
        time : new Date()
      }
      homeworkHandler.create(params)
    res.end JSON.stringify({err:false})

  router.get '/homework',is-authenticated,(req,res) !->
    params = {
      username : req.session.username,
      role : req.session.role
    }
    homeworkHandler.get params,res
  
  router.post '/createRequest',(req,res) !->
    if !req.session.username is true
      res.write JSON.stringify({err:true,msg:'Session is timeout!'})
      res.end()
      return
    params = {
      username : req.session.username
      deadline : req.param 'deadline'
      content : req.param 'content'
      title : req.param 'title'
      id : req.param 'id'
    }
    requestHandler.create params
    res.end JSON.stringify({err:false})


  router.post '/viewRequest',(req,res) !->
    params = {
      _id : req.param 'id'
    }
    requestHandler.get params,req.user,res