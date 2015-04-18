require! ['express']
require! {Project:'../models/project', 'bcrypt-nodejs', 'passport-local'}
require! {User:'../models/user', 'bcrypt-nodejs', 'passport-local'}
require! {Handin:'../models/handin', 'bcrypt-nodejs', 'passport-local'}

router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

module.exports = (passport) ->
  router.get '/', (req, res)!-> res.render 'index', message: req.flash 'message'

  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/home', failure-redirect: '/', failure-flash: true
  }

  router.get '/signup', (req, res)!-> res.render 'register', message: req.flash 'message'

  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: '/home', failure-redirect: '/signup', failure-flash: true
  }

  router.get '/home', is-authenticated, (req, res)!-> res.render 'home', user: req.user
  is-passed = (mdate) !->
    date-now = new Date()
    return mdate.valueOf() < date-now.valueOf() 

  router.get '/deadline', (req, res)!-> 
    if !req.user
      res.redirect '/'
    pd = []
    d = []
    Project.find {} (err, deadlines)!->
      for i from 0 to deadlines.length-1
        if is-passed deadlines[i].deadline
          pd.push deadlines[i]
          
        else
          d.push deadlines[i]
          
      res.render 'deadline', user: req.user, pd: pd, d:d, error: ''
  
  router.post '/deadline', (req, res)!-> 
    mdate = req.param 'mdate'
    console.log mdate
    name = req.param 'name'
    new-project = new Project {
      name : name
      deadline : mdate
    }
    new-project.save (error) !->
      if error
        console.log "Error in saving deadline: ", error
        throw error
      else
        console.log "Deadline creation success"
      d = []
      pd = []
      Project.find {} (err, deadlines)!->
        for i from 0 to deadlines.length-1
          if is-passed deadlines[i].deadline
            pd.push deadlines[i]
          else
            d.push deadlines[i]
              
        res.render 'deadline', user: req.user, d:d, pd:pd, error: ''

  router.get '/modify/:name', (req, res)!->
    if !req.user
      res.redirect '/'
    name = req.param 'name'
    Project.findOne {name: name}, (err, deadline) !->
      res.render 'modify', user:req.user, deadline:deadline, error:''

  router.post '/modify/:name', (req, res) !->
    mdate = req.param 'mdate'
    console.log mdate
    name = req.param 'name'
    Project.update {name: name}, {$set: {deadline: mdate}}, (error) !->
      d = []
      pd = []
      Project.find {} (err, deadlines)!->
        for i from 0 to deadlines.length-1
          if is-passed deadlines[i].deadline
            pd.push deadlines[i]
          else
            d.push deadlines[i]
            
        res.render 'deadline', user: req.user, d:d, pd:pd, error: ''
    
  router.post '/upload/:name', (req, res) !->
    owner = req.user._id
    file = req.param 'file'
    name = req.param 'name'
    console.log file
    Handin.findOne {deadline: name, owner: owner}, (err, handin) !->
      if handin
        Handin.update {deadline: name, owner: owner}, {$set: {file: file}}, (error) !->
      else
        User.findOne {_id: owner}, (err, stu) !->
          new-handin = new Handin {
            owner: owner
            ownername: stu.username
            deadline: name
            file: file
            grade: ''
            comment: ''
          }
          new-handin.save (error) !->
            if error
              console.log "Error in saving new-handin: ", error
              throw error
            else
              console.log "Handin creation success"
    d = []
    pd = []
    Project.find {} (err, deadlines)!->
      for i from 0 to deadlines.length-1
        if is-passed deadlines[i].deadline
          pd.push deadlines[i]
        else
          d.push deadlines[i]    
      res.render 'deadline', user: req.user, d:d, pd:pd, error: ''
      

  router.get '/upload/:name', (req, res) !->
    if !req.user
      res.redirect '/'
    name = req.param 'name'
    owner = req.user._id
    Handin.findOne {deadline: name, owner: owner}, (err, handin) !->
      if !handin
        file = ''
        console.log 'failfail'
      else
        file = handin.file
      Project.findOne {name: name}, (err, deadline) !->
        res.render 'handin', user:req.user, deadline: deadline, file: file

  router.post '/score/:name', (req, res) !->
    new-score = req.param 'score'
    stu = req.param 'stu'
    comment = req.param 'comment'
    name = req.param 'name'
    Handin.update {deadline: name, owner: stu}, {$set: {grade: new-score, comment:comment}}, (err) !->

    Handin.find {deadline: name}, (err, handins) !->
      res.render 'score', user:req.user, handins:handins

  router.get '/score/:name', (req, res) !->
    if !req.user
      res.redirect '/'
    deadline = req.param 'name'
    Handin.find {deadline: deadline}, (err, handins) !->
      res.render 'score', user:req.user, handins:handins

  router.get '/score/:name/:stu', (req, res) !->
    if !req.user
      res.redirect '/'
    stu = req.param 'stu'
    name = req.param 'name'
    User.findOne {_id: stu}, (error, student) !->
      Handin.findOne {deadline: name, owner:stu}, (err, handin) !->
        res.render 'score_stu', handin:handin, user: req.user, student:student

  router.get '/result/:name', (req, res) !->
    stu = req.user._id
    name = req.param 'name'
    Handin.findOne {owner:stu, deadline:name}, (err, handin) !->
      res.render 'result', handin:handin, user: req.user
  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'
