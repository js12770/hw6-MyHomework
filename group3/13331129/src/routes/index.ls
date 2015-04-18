require! ['express']
require! {Homework:'../models/homework'}
require! {Assignment:'../models/assignment'}
router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

getDate = ->
  date = new Date!
  day = ("0" + date.getDate!) .slice -2
  month = ("0" + (date.getMonth! + 1)) .slice -2
  str = date.getFullYear! + '/' + month + '/' + day

module.exports = (passport)->
  router.get '/', (req, res)!-> res.render 'index', message: req.flash 'message'

  router.post '/login', passport.authenticate 'login', {
    success-redirect: '/home', failure-redirect: '/', failure-flash: true
  }

  router.post '/homework', (req, res) !-> 
    str = getDate!
    Assignment.find-one({_id:req.body.assignment}, (err, doc) !->
      if doc.date > str
        Homework.find-one({student:req.body.student, assignment: req.body.assignment}, (err, doc) !->
          if doc isnt null
            doc.url = req.files.file.path
            doc.name = req.files.file.originalname
            doc.save (error) !->
              if error
                console.log "Error in upload: ", error
                throw error
              else
                console.log "homework updated success"
                res.send {path: req.files.file.path, name:req.files.file.originalname}
          else
            new-homework = new Homework {
              name: req.files.file.originalname
              url: req.files.file.path
              student: req.body.student
              assignment: req.body.assignment
              grade: "---"
            }
            new-homework.save (error) !->
              if error
                console.log "Error in upload: ", error
                throw error
              else
                console.log "homework uploaded success"
                res.send {path: req.files.file.path, name:req.files.file.originalname}
              )
      else
        res.send 'timeout'
      )

  router.post '/assignment', (req, res) !-> 
    new-assignment = new Assignment {
        title: req.body.title
        description: req.body.description
        date: req.body.date
    }
    new-assignment.save (error) !->
      if error
        console.log "Error in upload: ", error
        throw error
      else
        console.log "assignment uploaded success"
        res.send {title: req.body.title, description:req.body.description, date: req.body.date, _id: new-assignment._id}


  router.post '/getHomeworks', (req, res) !-> 
    assignment = req.body.assignment
    str = getDate!
    Assignment.find-one({_id: assignment}, (err, doc) !->
      if err
        console.log "error"
      else
        Homework.find({assignment:assignment}, (err, docs) !->
          if doc.date > str
            if err
              console.log "error occured"
            else
              if docs is null
                res.end!
              res.send {docs, grade: 0}
          else
            if docs is null
              res.end!
            res.send {docs, grade: 1}
          )
      )

  
  router.post '/delete', (req, res) !-> 
    assignment = req.body.assignment
    Assignment.remove({_id:assignment}, (err) !->
      if err
        console.log "error occured"
      else
        Homework.remove({assignment:assignment}, (err) !->
          if err
            console.log "error occured in remove homeworks"
          else
            console.log "delete successfully"
            res.end!
            )
      )

  router.get '/signup', (req, res)!-> res.render 'register', message: req.flash 'message'

  router.post '/signup', passport.authenticate 'signup', {
    success-redirect: "/home", failure-redirect: '/signup', failure-flash: true
  }

  router.get '/home', is-authenticated, (req, res)!->
        items = []
        id = req.user._id
        count = 0
        var docs
        Assignment.find({}, (err, docs__) !->
          if docs__ isnt null
            docs := docs__
            for let doc, i in docs
              Homework.find-one({student: id, assignment: doc._id}, (err, item) !->
                ++count
                console.log item
                items[i] = item
                if count is docs.length
                  console.log docs
                  res.render 'home', user: req.user, docs:docs, items:items
                )
            else
              res.render 'home', user:req.user
            )

  router.get '/uploads/:file(*)', (req, res)!->
    file = req.params.file
    path = __dirname - '/bin/routes' + '/uploads/' + file
    console.log path
    res.download(path)

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  router.post '/modify', (req, res) !-> 
    Assignment.find-one({_id:req.body.assignment}, (err, doc) !->
      doc.title = req.body.title
      doc.description = req.body.description
      doc.date = req.body.date
      doc.save (error) !->
        if error
          console.log  "error:", error
          throw error
        else
          res.end!
      )

  router.post '/grade', (req, res) !-> 
    items = req.body.items
    for let i from 0 to items.length - 1
      Homework.find-one({_id:JSON.parse(items[i]).id}, (err, doc) !->
        doc.grade = JSON.parse(items[i]).grade
        doc.save (error) !->
          if error
            console.log  "error:", error
            throw error
          else
            if i is items.length - 1
              res.end!
        )