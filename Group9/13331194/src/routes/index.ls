require! ['express']
require! {Homework: '../models/homework', Request:'../models/request'}
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

  router.get '/home', is-authenticated, (req, res)!-> res.render 'home', user: req.user

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  # My Addtion Realization

  # Request
  router.get '/request', is-authenticated, (req, res)!->
    Request.find (err, all-request)->
      current-time = get-current-time-and-change-into-string!
      res.render 'request', user: req.user, request: all-request, current-time: current-time
    
  # Homework
  router.get '/homework', is-authenticated, (req, res)!->
    current-time = get-current-time-and-change-into-string!
    if req.user.identity == 'T'
      Homework.find (err, all-homework)->
        res.render 'homework', user: req.user, homework: all-homework, current-time: current-time
    else
      Homework.find {student: req.user.username}, (err, my-homework) ->
        res.render 'homework', user: req.user, homework: my-homework, current-time: current-time

  # Publish request
  router.get '/publish', is-authenticated, (req, res)!-> res.render 'publish', user: req.user
  router.post '/publish', is-authenticated, (req, res)!->
    request-existed = Request.find {title: req.param 'title'} .count!
    # console.log request-existed # for debug    
    if request-existed > 0
      console.log "Request existed !"
      res.render 'publish', user: req.user, message: "Request's title exist !"
      return
    new-request = new Request {
      title     : req.param 'title'
      teacher   : req.user.username
      content   : req.param 'content'
      startTime : req.param 'startTime'
      endTime   : req.param 'endTime'
    }
    # Delete the old request versions
    Request.remove {title: req.param 'title'}
    new-request.save (error)->
      if error
        console.log "Error in saving homework request: ", error
        res.render 'publish', user: req.user, message: "Error in saving homework request: " + error
      else
        console.log "New homework request publish success !"
        Request.find (err, all-request)->
          res.render 'request', user: req.user, request: all-request

  # Submit homework
  router.get '/submit/:title', is-authenticated, (req, res)!->
    current-time = get-current-time-and-change-into-string!
    Request.find-one {title: req.param 'title'}, (err, request)->
      if current-time >= request.endTime
        res.render 'home', user: req.user
      else
        res.render 'submit', user: req.user, request: request
  router.post '/submit/:title', is-authenticated, (req, res)!->
    Request.find-one {title: req.param 'title'}, (err, request)->
      new-homework = new Homework {
        title   : req.param 'title'
        start-time : request.startTime
        end-time   : request.endTime
        student : req.user.username
        content : req.param 'content'
        submit-time : get-current-time-and-change-into-string!
        score   : "Not Given"
      }
      # Delete the old submit versions
      Homework.remove {title: req.param 'title'}, (err)-> null
      # console.log new-homework.submit-time # for debug
      new-homework.save (error)->
        if error
          console.log "Error in saving homework submition: ", error
          res.render 'submit', user: req.user, request: request, message: "Error in saving homework submition: " + error
        else
          console.log "New homework submit success !"
          Homework.find {student: req.user.username}, (err, my-homework) ->
              res.render 'homework', user: req.user, homework: my-homework

  router.get '/change/:title', is-authenticated, (req, res)!->
    Request.find-one {title: req.param 'title'}, (err, request)->
      res.render 'change', user: req.user, request: request
  router.post '/change', is-authenticated, (req, res)!->
    # console.log "change begin" # for debug
    # request-existed = Request.find {title: req.param 'title'} .count!
    # # console.log request-existed # for debug    
    # if request-existed > 0
    #   console.log "Request existed !"
    #   res.render 'change', user: req.user, message: "New request's title exist !"
    #   return
    # console.log "change before" # for debug
    new-request = new Request {
      title     : req.param 'title'
      teacher   : req.user.username
      content   : req.param 'content'
      startTime : req.param 'startTime'
      endTime   : req.param 'endTime'
    }
    # Delete the old request versions
    Request.remove {title: req.param 'oldTitle'}, (err)-> null
    # if req.param 'oldTitle' != req.param 'title' 
    #   Homework.remove {title: req.param 'oldTitle'}, (err)-> null
    Request.remove {title: req.param 'title'}, (err)-> null
    Homework.update {title: req.param 'oldTitle'}, {$set:{endTime: req.param 'endTime'}}, (err)-> null
    Homework.update {title: req.param 'oldTitle'}, {$set:{startTime: req.param 'startTime'}}, (err)-> null
    Homework.update {title: req.param 'oldTitle'}, {$set:{title: req.param 'title'}}, (err)-> null
    # console.log "change remove" # for debug
    new-request.save (error)->
      if error
        console.log "Error in changing homework request: ", error
        res.render 'change', user: req.user, message: "Error in saving homework request: " + error
      else
        console.log "Homework request change success !"
        Request.find (err, all-request)->
          res.render 'request', user: req.user, request: all-request

  # Give score
  router.post '/score/:title/:student', is-authenticated, (req, res)!->
    Homework.find-one {title: req.param 'title', student: req.user.username}, (err, my-homework)->
      my-new-homework = new Homework {
        title       : my-homework.title
        start-time  : my-homework.startTime
        end-time    : my-homework.endTime
        student     : my-homework.username
        content     : my-homework.content
        submit-time : my-homework.submitTime
        score       : req.param 'score'
      }
      Homework.remove {title: req.param 'title', student: req.user.username}, (err)-> null
      my-new-homework.save (error)->
        if error
          console.log "Error in giving score: ", error
          res.render 'homework', user: req.user, message: "Error in saving homework submition: " + error
        else
          console.log "Score give success !"
          Homework.find (err, all-homework)->
            res.render 'homework', user: req.user, homework: all-homework
  
  # Edit homework
  router.get '/edit/:title', is-authenticated, (req, res)!->
    current-time = get-current-time-and-change-into-string!
    Homework.find-one {title: req.param 'title', student: req.user.username}, (err, my-submit)->
      if current-time < my-submit.endTime
        res.render 'submit', user: req.user, homework: my-submit
      else
        res.render 'home', user: req.user

get-current-time-and-change-into-string = !->
  # console.log "inside change function begin" # for debug
  current-date = new Date
  # console.log "inside change function before" # for debug

  year   = current-date.get-full-year!  # 4位
  month  = (parse-int current-date.get-month!)+1   # 0-11
  day    = current-date.get-date!       # 1-31
  hour   = current-date.get-hours!      # 0-23
  minute = current-date.get-minutes!    # 0-59
  second = current-date.get-seconds!    # 0-59

  # console.log "inside change function middle" # for debug

  if month < 10
    month = "0" + month
  if day < 10
    day = "0" + day
  if hour < 10
    hour = "0" + hour
  if minute < 10
    minute = "0" + minute
  if second < 10
    second = "0" + second

  # console.log "inside change function after" # for debug

  # current-date = ""+year+'-'+month+'-'+day+' '+hour+':'+minute+':'+second
  # console.log current-date # for debug
  return year+'-'+month+'-'+day+' '+hour+':'+minute+':'+second