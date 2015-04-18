# requirements
require! [express, path, multer, fs]
require! {
  Homework: '../models/homework'
}

router = express.Router! 

# tmp err handler
e4 = (res)!-> res.status(400).end!
e5 = (res)!-> res.status(500).end!

# authentication middleware
is-authenticated = (req, res, next)!-> if req.is-authenticated! then next! else res.redirect '/'

is-authenticated-post = (req, res, next)!-> if req.is-authenticated! then next! else e4 res

# paths
const ROOT = path.join __dirname, '..', '..'
const SUBMITS_PATH = path.join ROOT, 'submits'

# routes
module.exports = (passport)->
  router.get '/', (req, res)!-> res.render 'index', message: req.flash 'message'

  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/home', failure-redirect: '/', failure-flash: true
  }

  router.get '/signup', (req, res)!-> res.render 'register', message: req.flash 'message'

  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: '/home', failure-redirect: '/signup', failure-flash: true
  }

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  router.get '/home', is-authenticated, (req, res)!-> res.render 'home', user: req.user

  router.get '/create-homework', is-authenticated, (req, res)!->
    role = req.user.role
    # only for teachers
    if role != 'teacher'
      res.redirect '/'
    else
      res.render 'create-homework'

  router.get '/homeworks', is-authenticated, (req, res)!->
    # check homeworks
    Homework.find null .sort date: -1 .exec (err, homeworks)!->
      if err
        e5 res
      else
        res.render 'homeworks',
          is-teacher: req.user.role == 'teacher'
          homeworks: homeworks

  router.get '/homework/:homework-id', is-authenticated, (req, res)!->
    homework-id = req.params.homework-id
    # check homework
    Homework.find-by-id homework-id, (err, homework)!->
      if err
        e5 res
      else
        user = req.user
        role = user.role
        out-of-deadline = homework.deadline < new Date!
        # is teacher
        if role == 'teacher'
          homework = homework.toObject!
          # sort submits by date
          if homework.submits
            homework.submits.sort (b, a)-> a.date - b.date
          res.render 'homework',
            is-teacher: true
            out-of-deadline: out-of-deadline
            homework: homework
        # not teacher
        else
          username = user.username
          # find the submit
          my-submit = null
          for submit in homework.submits.toObject!
            if submit.username == username
              my-submit = submit
              break
          res.render 'homework',
            is-teacher: false
            username: username
            out-of-deadline: out-of-deadline
            homework: homework
            my-submit: my-submit

  router.get '/submits/:homeworkId/:username', is-authenticated, (req, res, next)!->
    # params
    homework-id = req.params.homework-id
    req-username= req.params.username
    user = req.user
    role = user.role
    username = user.username
    # authentication
    if role == 'teacher' or username == req-username
      req.url += '.zip'
      # init a static middleware
      static-middleware = express.static ROOT
      # call the static middleware
      static-middleware req, res, next
    else
      res.redirect '/home'

  # edit a homework
  router.get '/edit-homework/:homeworkId', is-authenticated, (req, res, next)!->
    role = req.user.role
    # authentication
    if role != 'teacher'
      res.redirect '/home'
    else
      # params
      homework-id = req.params.homework-id
      # check homework
      Homework.find-by-id homework-id, (err, homework)!->
        if err
          e5 res
        # homework not exists
        else if not homework
          res.redirect '/homeworks'
        else
          res.render 'edit-homework', homework: homework

  # Web Services
 
  # submit a homework
  router.post '/s-submit/:homeworkId/:username', is-authenticated-post, (req, res)!->
    #params
    homework-id = req.params.homework-id
    req-username= req.params.username
    user = req.user
    role = user.role
    username = user.username
    # authentication
    if role = 'student' and req-username == username
      # check homework
      Homework.find-by-id homework-id,  (err, homework)!->
        if err
          e5 res
        # homework not exists
        else if not homework
          e4 res
        else
          # init a multer middleware
          multer-middleware = multer do
            dest: path.join SUBMITS_PATH, homework-id
            rename: -> username
            on-file-upload-start: (file, req, res)->
              # extension is not zip
              if file.extension != 'zip'
                # stop upload and return a 400
                e4 res
                false
              else
                true
            on-file-upload-complete: (file, req, res)!->
              submits = homework.submits.toObject!
              new-submit = true
              # check if new submit
              for submit in submits
                # not new submit
                if submit.username == username
                  new-submit = false
                  submit.date = new Date!
              # new submit
              if new-submit
                submits.push do
                  score: null
                  username: username
                  date: new Date!
              # update
              Homework.find-by-id-and-update homework-id,
                $set:
                  submits: submits
              , (err)!->
                if err
                  # rollback
                  fs.unlink file.path, (err)!->
                    if err
                      console.log err
                  e4 res
                else
                  res.redirect "/homework/#{homework-id}"
          # call the multer middleware
          multer-middleware req, res, !-> "pass"
    else
      e4 res
 
  # grade a submit
  router.get '/s-grade/:homeworkId/:username', is-authenticated, (req, res, next)!->
    # params
    role = req.user.role
    homework-id = req.params.homework-id
    username = req.params.username
    score = parseInt req.query.score
    # bad format
    if not score
      e4 res
    # authentication
    else if role != 'teacher'
      e4 res
    else
      # check homework
      Homework.find-by-id homework-id, (err, homework)!->
        if err
          e5 res
        # homework not exists
        else if not homework
          e4 res
        else
          submits = homework.submits.toObject!
          # update
          for submit in submits
            if username == submit.username
              submit.score = score
              Homework.find-by-id-and-update homework-id,
                $set:
                  submits: submits
              , (err)!->
                if err
                  e5 res
                else
                  res.redirect "/homework/#{homework-id}"
              return
          # user not exists
          e4 res

  # create a homework
  router.post '/s-create-homework', is-authenticated-post, (req, res)!->
    role = req.user.role
    # authentication
    if role != 'teacher'
      e4 res
    else
      # params
      title = req.body.title
      requirement = req.body.requirement
      deadline = req.body.deadline
      date = new Date!
      # insert
      homework = 
        title: title
        requirement: requirement
        deadline: deadline
        date: date
      Homework.create homework, (err, homework)!->
        if err
          e5 res
        else
          # mkdir for submits
          fs.mkdir path.join(ROOT, 'submits', homework._id.toString!), (err)!->
            if err
              e5 res
            else
              res.redirect '/homeworks'

  # edit a homework
  router.post '/s-edit-homework/:homeworkId', is-authenticated, (req, res, next)!->
    role = req.user.role
    # not teacher
    if role != 'teacher'
      e4 res
    else
      # params
      homework-id = req.params.homework-id
      title = req.body.title
      requirement = req.body.requirement
      deadline = req.body.deadline
      # check homework
      Homework.find-by-id homework-id, (err, homework)!->
        if err
          e5 res
        # homework not exists
        else if not homework
          e4 res
        # out-of-deadline
        else if homework.deadline < new Date!
          e4 res
        else
          # update
          Homework.find-by-id-and-update homework-id,
            $set:
              title: title
              requirement: requirement
              deadline: deadline
          , (err)!->
            if err
              e5 res
            else
              res.redirect '/homework/' + homework-id
