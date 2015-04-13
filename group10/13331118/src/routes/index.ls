require! ['express']
Assignment = require '../models/assignment'
User = require '../models/user'
Homework = require '../models/homework'

router = express.Router!

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

module.exports = (passport)->

  ################################################################################
  #                RESTFUL api of a model, learn from ror(ruby on rails)
  #===============================================================================
  #       Prefix Verb      URI Pattern(Endpoint)    Controller#Action
  #-------------------------------------------------------------------------------
  #     xxxxxxxs GET       /xxxxxxxs                xxxxxxxs#index
  #              POST      /xxxxxxxs                xxxxxxxs#create
  #  xxxxxxx-new GET       /xxxxxxxs/new            xxxxxxxs#new
  # xxxxxxx-edit GET       /xxxxxxxs/:id/edit       xxxxxxxs#edit
  #      xxxxxxx GET       /xxxxxxxs/:id            xxxxxxxs#show
  #              PATCH     /xxxxxxxs/:id            xxxxxxxs#update
  #              PUT       /xxxxxxxs/:id            xxxxxxxs#update
  #              DELETE    /xxxxxxxs/:id            xxxxxxxs#destroy
  #################################################################################





  ####################  Begin endpoints of user   ################################

  # endpoint of signup page
  router.get '/signup', (req, res)!-> res.render 'register', {
    title: 'signup'
    message: req.flash 'message'
  }

  # endpoint of new user
  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: '/home', failure-redirect: '/signup', failure-flash: true
  }

  ####################  End endpoints of user     ###################################










  ####################  Begin endpoints of session #################################

  # endpoint of login page
  router.get '/', (req, res)!-> res.render 'index', {
    title: 'login'
    message: req.flash 'message'
  }

  # endpoint of new session
  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/home', failure-redirect: '/', failure-flash: true
  }

  # switch a user to their home according their type
  router.get '/home', is-authenticated, (req, res, next)!->
    res.redirect Assignment.index!

  # endpoint of del session
  router.get '/signout', (req, res)!->
    req.logout!
    res.redirect '/'

  ####################  End endpoints of session  ##########################################












  ####################  Begin endpoints of assignment  #####################################

  router.param 'assignment_id', (req, res, next, id) ->
    (error, assignment)<- Assignment.find-one {_id: id}
    return (console.log "Error in finding assignment: ", error) if error
    if assignment
      req.assignment = assignment
      next!
    else
      console.log msg = "Error in finding assignment"
      req.flash 'message', msg
      err = new Error 'Not found'
      err.status = 404
      next err

  # index
  router.get Assignment.index!, is-authenticated, (req, res, next)!->
    (error, assignments) <- Assignment.find {}
    return (console.log "Error in finding assignments: ", error) if error
    console.log msg = "Success in finding assignments"
    req.flash 'message' msg
    res.render Assignment.index.template!, {
      title: 'assignment'
      index_url: "/assignments"
      new_url: "/assignments/new"
      # Model: Assignment
      user: req.user
      assignments: assignments
      message: req.flash 'message'
    }

  # create
  router.post Assignment.create!, is-authenticated, (req, res, next)!->
    new-assignment = new Assignment {
      createdby: req.user.username
      ddlDate: req.body['ddlDate']
      ddlTime: req.body['ddlTime']
      title: 'assignment'
      detials: req.body['detials']
    }
    (error)<- new-assignment.save
    if error
      console.log msg = "Error in saving assignment: ", error
      throw error
    else
      console.log msg = "Success in saving assignment"
      req.flash 'message', msg
      res.redirect Assignment.index!

  # new
  router.get Assignment.new!, is-authenticated, (req, res, next)!->
    if req.user.usertype is 'student'
      console.log msg = "Yon have no permission create assignment"
      req.flash 'message', msg
      err = new Error 'Forbidden'
      err.status = 403
      next err
    if req.user.usertype is 'teacher'
      console.log msg = "Wiating for user to create assignment"
      req.flash 'message' msg
      res.render Assignment.new.template!, {
        title: 'assignment'
        index_url: "/assignments"
        new_url: "/assignments/new"
        create_url: "/assignments"
        # Model: Assignment
        user: req.user
        message: req.flash 'message'
      }

  # edit
  router.get Assignment.edit!, is-authenticated, (req, res, next)!->
    now = new Date!
    ddl = new Date req.assignment.ddl
    console.log "now: #{now}, ddl: #{ddl}"
    if req.user.usertype is 'student' or now > ddl
      console.log msg = "Yon have no permission edit assignment or ddl past"
      req.flash 'message', msg
      err = new Error 'Forbidden'
      err.status = 403
      next err
    if req.user.usertype is 'teacher'
      console.log msg = "Wiating for user to edit assignment"
      req.flash 'message' msg
      res.render 'assignment-edit' {
      title: 'assignment'
      index_url: req.assignment.index
      # Model: Assignment
      # Entity: req.assignment
      user: req.user
      assignment: req.assignment
      message: req.flash 'message'
      }

  # show
  router.get Assignment.show!, is-authenticated, (req, res, next)!->
    console.log msg = "Success in finding assignment"
    req.flash 'message' msg
    res.render Assignment.show.template!, {
      title: 'assignment'
      index_url: req.assignment.index
      edit_url: req.assignment.edit
      user: req.user
      assignment: req.assignment
      message: req.flash 'message'
    }

  # update
  router.put Assignment.update!, is-authenticated, (req, res, next)!->
    req.assignment.title = req.body.title
    req.assignment.ddlTime = req.body.ddlTime
    req.assignment.ddlDate = req.body.ddlDate
    req.assignment.detials = req.body.detials
    (error)<- req.assignment.save
    if error
      console.log msg = "Error in saving assignment: ", error
      throw error
    else
      console.log msg = "Success in saving assignment"
      req.flash 'message', msg
      res.redirect req.assignment.show


  ####################  End endpoints of assignment  ##########################################











  ####################  Begin endpoints of homework  #####################################

  router.param 'homework_id', (req, res, next, id) ->
    (error, homework)<- Homework.find-one {_id: id}
    return (console.log "Error in finding homework: ", error) if error
    if homework
      req.homework = homework
      next!
    else
      console.log msg = "Error in finding homework"
      req.flash 'message', msg
      req.flash 'message', msg
      err = new Error 'Not found'
      err.status = 404
      next err

  # index
  router.get Homework.index!, is-authenticated, (req, res, next)!->
    (error, homeworks) <- Homework.find {assignment_id: req.assignment['_id']}
    return (console.log "Error in finding homeworks: ", error) if error
    console.log msg = "Success in finding homeworks"
    req.flash 'message' msg
    res.render Homework.index.template!, {
      title: 'homework'
      index_url: "/assignments/#{req.assignment['_id']}/homeworks"
      new_url: "/assignments/#{req.assignment['_id']}/homeworks/new"
      # Model: Homework
      user: req.user
      assignment: sys = req.assignment
      homeworks: homeworks
      message: req.flash 'message'
    }

  # create
  router.post Homework.create!, is-authenticated, (req, res, next)!->
    file-obj = req.files.homework
    (error, homework) <- Homework.find-one({assignment_id: req.assignment['_id'], user_id: req.user['_id']})
    if homework
      homework.path = '/' + file-obj['path'].split('\\').slice(2).join('\/')
    else
      homework = new Homework {
        user_id: req.user['_id']
        assignment_id: req.assignment['_id']
        createdby: req.user.username
        marks: 0
        review: ''
        path: '/' + file-obj['path'].split('\\').slice(2).join('\/')
      }
    (error)<- homework.save
    if error
      console.log msg = "Error in saving homework: ", error
      throw error
    else
      console.log msg = "Success in saving homework"
      req.flash 'message', msg
      res.redirect req.path

  # new
  router.get Homework.new!, is-authenticated, (req, res, next)!->
    now = new Date!
    ddl = new Date req.assignment.ddl
    console.log "now: #{now}, ddl: #{ddl}"
    if req.user.usertype is 'teacher' or now > ddl
      console.log msg = "Yon have no permission create homework or ddl past"
      req.flash 'message', msg
      err = new Error 'Forbidden'
      err.status = 403
      next err
    else
      console.log msg = "Wiating for user to create homework"
      req.flash 'message' msg
      res.render Homework.new.template!, {
        title: 'homework'
        index_url: "/assignments/#{req.assignment['_id']}/homeworks"
        create_url: "/assignments/#{req.assignment['_id']}/homeworks"
        # Model: Homework
        user: req.user
        assignment: req.assignment
        message: req.flash 'message'
      }


  # edit
  router.get Homework.edit!, is-authenticated, (req, res, next)!->
    now = new Date!
    now = "#{now.getFullYear!}-#{now.getMonth! + 1}-#{now.getDate!} #{now.getHours!}:#{now.getMinutes!}}"
    if req.user.usertype is 'student' or now < req.assignment.ddl
      console.log msg = "Yon have no permission edit homework or ddl not past"
      req.flash 'message', msg
      err = new Error 'Forbidden'
      err.status = 403
      next err
    if req.user.usertype is 'teacher' and now >= req.assignment.ddl
      console.log msg = "Wiating for user to edit homework"
      req.flash 'message' msg
      res.render 'homework-edit' {
      title: 'homework'
      index_url: req.homework.index
      update_url: req.homework.update
      # Model: Homework
      # Entity: req.homework
      user: req.user
      assignment: req.assignment
      homework: req.homework
      message: req.flash 'message'
      }

  # show
  router.get Homework.show!, is-authenticated, (req, res, next)!->
    console.log msg = "Success in finding homework"
    req.flash 'message' msg
    res.render Homework.show.template!, {
      title: 'homework'
      index_url: req.homework.index
      edit_url: req.homework.edit
      # Model: Homework
      user: req.user
      assignment: req.assignment
      homework: req.homework
      message: req.flash 'message'
    }

  # update
  router.put Homework.update!, is-authenticated, (req, res, next)!->
    req.homework.marks = req.body.marks
    req.homework.review = req.body.review
    (error)<- req.homework.save
    if error
      console.log msg = "Error in saving homework: ", error
      throw error
    else
      console.log msg = "Success in saving homework"
      req.flash 'message', msg
      res.redirect req.homework.show


 ####################  End endpoints of homework  ##########################################
