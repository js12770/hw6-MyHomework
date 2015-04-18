require! {'express', Homework:'../models/homework', Finished:'../models/finished', 'fs', 'multiparty', 'util'}
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
    Homework.find {}, (err, homework) !->
      homework.sort (a, b)->
        return b.deadline.getTime! - a.deadline.getTime!
      res.render 'home', user: req.user, hwlist: homework

  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'

  router.post '/add', is-authenticated, (req, res)!->
    ddl-str = req.param 'deadline'
    ddl-str =  ddl-str.replace /-/g, '/'
    ddl-str = ddl-str.replace 'T', ' '
    ddl-date = new Date ddl-str
    new-homework = new Homework {
      name: req.param 'homeworkname'
      discription: req.param 'discription'
      deadline: ddl-date
      sponsor: req.user.name
    }
    new-homework.save (err)->
      if err
        console.log "error in add homework"
        throw err
      else
        console.log "success in add homework: new-homework"
        res.redirect '/home'

  router.get '/hwdetail/:hwid', is-authenticated, (req, res)!->
    hwid = req.param 'hwid'
    Homework.findOne {"_id": hwid}, (err, hwitem)!->
      if err
        console.log 'error'
      else
        if req.user.identity is 'teacher'
          Finished.find {"finished_workid": hwid}, (err, finishedwork)!->
            res.render 'hwdetail', user: req.user, hwitem: hwitem, finishedwork: finishedwork
        else
          Finished.findOne {"finished_workid": hwid, "finished_user": req.user.name}, (err, finishedwork)!->
            res.render 'hwdetail', user: req.user, hwitem: hwitem, finishedwork: finishedwork

  router.post '/upload', is-authenticated, (req, res)!->
    form = new multiparty.Form({uploadDir: './src/public/homework/'});
    form.parse req, (err, fields, files)!->
      if err
        console.log 'parse error: '+ err
      else
        console.log 'parse files: ' + JSON.stringify(files, null, 2)
        console.log 'parse fields: ' + JSON.stringify(fields, null, 2)
        input-file = files.finishedwork[0]
        uploaded-path = input-file.path
        dst-path = './src/public/homework/' + input-file.original-filename
        console.log 'path: ' + dst-path
        fs.rename uploaded-path, dst-path, (err)!->
          if err
            console.log('rename error: ' + err);
          else
            hwid = fields.hwid[0]
            Homework.findOne {"_id": hwid}, (err, hwitem)!->
              Finished.findOne {"finished_workid": hwid, "finished_user": req.user.name}, (err, finisheditem)!->
                if finisheditem is null
                  new-finished = new Finished {
                    finished_workid: hwitem._id,
                    finished_user: req.user.name,
                    finished_time: new Date!,
                    hw_name: input-file.original-filename
                  }
                  new-finished.save (err)!->
                    if err
                      console.log "error in upload homework"
                      throw err
                    else
                      console.log "success in upload homework"
                      res.redirect "/hwdetail/#{hwid}"
                else
                  finisheditem.hw_name = input-file.original-filename
                  finisheditem.save (err)!->
                    if err
                      console.log "error in upload homework"
                      throw err
                    else
                      console.log "success in upload homework"
                      res.redirect "/hwdetail/#{hwid}"
  router.get '/download/:hw_name', is-authenticated, (req, res)!->
    hw_name = req.param 'hw_name'
    console.log hw_name
    res.download "./src/public/homework/#{hw_name}", hw_name, (err)!->
      if err
        console.log err
        throw err
      else
        console.log 'upload success'

  router.post '/modify', is-authenticated, (req, res)!->
    hwid = req.param 'hwid'
    Homework.findOne {"_id": hwid}, (err, hwitem)!->
      hwitem.name = req.param 'homeworkname'
      hwitem.discription = req.param 'discription'
      ddl-str = req.param 'deadline'
      ddl-str =  ddl-str.replace /-/g, '/'
      ddl-str = ddl-str.replace 'T', ' '
      ddl-date = new Date ddl-str
      hwitem.deadline = ddl-date
      hwitem.save (err)!->
        if err
          console.log "error in upload homework"
          throw err
        else
          console.log "success in upload homework"
          res.redirect "/hwdetail/#{hwid}"

  router.post '/mark', is-authenticated, (req, res)!->
    uploadId = req.param 'uploadId'
    Finished.findOne {'_id': uploadId} (err, item)!->
      item.score = req.param 'score'
      item.save (err)!->
        if err
          console.log 'err in change score'
          throw err
        else
          res.redirect "/hwdetail/#{item.finished_workid}"