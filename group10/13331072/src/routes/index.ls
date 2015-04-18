require! {'express',Homeworkrequest:'../models/homeworkrequest',Homework:'../models/homework'}
#require! {Homeworkrequest:'../models/homeworkrequest'}
#require! {Homework:'../models/homework'}
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
    if req.user.isteacher is 'yes'
      Homework.find (err, homeworks)->
        Homeworkrequest.find (err,  homeworkrequests)->
          res.render 'home', user: req.user, homeworkrequests: homeworkrequests, homeworks: homeworks
    else
      Homeworkrequest.find  (err,  homeworkrequests)->
        Homework.find {uploader: req.user.username}, (err, homeworks)->
          res.render 'home', user: req.user, homeworkrequests: homeworkrequests, homeworks: homeworks

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  router.post '/addrequest', is-authenticated, (req, res)!->
      Homeworkrequest.find-one {name: req.param 'add_name'}, (err, ifok)->
        if ifok
          deadline = new Date(ifok.ddl)
          today = new Date!
          if deadline < today
            console.log msg = "The deadline has passed"
            res.render 'message', user: req.user, message: msg
          else
            ifok.request =  req.param 'add_request'
            ifok.ddl = req.param 'add_ddl'
            ifok.save (error)->
              if error
                console.log "Error in saving homework: ", error
                throw error
              else
                console.log msg = "create successfully"
                res.redirect '/home'
        else
          newone = new Homeworkrequest {
            name: req.param 'add_name'
            request: req.param 'add_request'
            ddl: req.param('add_ddl')
          }
          newone.save (error)->
            if error
              console.log "Error in saving homework: ", error
              throw error
            else
              console.log msg = "create successfully"
              res.redirect '/home'

  router.post '/changeddl', is-authenticated, (req, res)!->
      Homeworkrequest.find-one {name: req.param 'change_name'}, (err, ifok)->
        if !ifok
          console.log msg = "Invalid Name"
          res.render 'message', user: req.user, message: msg
        else
        ifok.ddl = req.param('change_ddl')
        ifok.save (error)->
          if error
            console.log "Error in saving request deadline: ", error
          else
            console.log msg = "change deadline successfully"
            res.redirect '/home'

  router.post '/uploadhomework', is-authenticated, (req, res)->
      Homeworkrequest.find-one {name: req.param('up_name')}, (err, ifok)->
        if !ifok
          console.log msg = "Invalid Name"
          res.render 'message', user: req.user, message: msg
        else
          Homework.find-one {name: req.param('up_name'), uploader: req.user.username}, (err, ifok2)->
            if ifok2
              deadline = new Date(ifok.ddl)
              today = new Date!
              if deadline < today
                console.log msg = "The deadline has passed"
                res.render 'message', user: req.user, message: msg
              else
                ifok2.content = req.param 'up_content'
                ifok2.save (error)->
                  if error
                    console.log "Error in updating homework", error
                  else
                    console.log msg = "upda succeffsully"
                    res.redirect '/home'
            else
              deadline = new Date(ifok.ddl)
              today = new Date!
              if deadline < today
                console.log msg = "The deadline has passed"
                res.render 'message', user: req.user, message: msg
              else
                newone = new Homework {
                  name: req.param('up_name')
                  content: req.param('up_content')
                  uploader: req.user.username
                  score: "none"
                }
                newone.save (error)->
                  if error
                    console.log "Error in saving homework", error
                  else
                    console.log msg = "create succeffsully"
                    res.redirect '/home'

  router.post '/scoring', is-authenticated, (req, res)->
      Homework.find-one {name: req.param('request_name'), uploader: req.param('student_name')}, (err, ifok2)->
        if ifok2
          Homeworkrequest.find-one {name: req.param('request_name')}, (err, ifok)->
            deadline = new Date(ifok.ddl)
            today = new Date!
            if deadline > today
              console.log msg = "The deadline has not passed"
              res.render 'message', user: req.user, message: msg
            else
              ifok2.score = req.param('score')
              ifok2.save (error)->
                if error
                 console.log "Error in saving socre: ", error
                else
                  console.log msg = "scoring successfully"
                  res.redirect '/home'
        else
          console.log msg = "Invalid Name"
          res.render 'message', user: req.user, message: msg