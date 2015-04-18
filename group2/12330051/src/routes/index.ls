require! {Work:'../models/homework',Assignment:'../models/assignment'}
require! ['express']
router = express.Router! 
is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'
is-deadline =(deadline) !-> 
   predate = new Date deadline
   if predate.getTime! < Date.now! then return true
   return false 
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
         Work.findOne {title:'only'}, (error,work) !->
             if not work
                work = new Work {
                  title : 'only'
                  requirment:'目前未有新作业'
                  deadline:'待定'
                }
             if req.user.identity is 'student'
                Assignment.findOne {id_:req.user.id_}  (error,assignment_)!->
                   if not assignment_
                      assignment_ = new Assignment {
                         title:'only'
                         name:req.user.username
                         assignment:'尚未提交作业'
                         score:'未评分'
                      }  
                   res.render 'home', {user: req.user,homework: work,assign:assignment_}
             else
                if work.deadline is '待定'
                   deadlined_ = false
                else
                   deadlined_ = is-deadline work.deadline
                Assignment.find {title:'only'}  (error,assignments)!->
                      res.render 'home', {user: req.user,homework: work,assigns:assignments,deadlined: deadlined_}
  router.get '/signout', (req, res)!-> 
    req.logout!
    res.redirect '/'
  router.post '/modify-requirment', (req, res)!-> 
      Work.findOne {title:'only'}, (error,work)!->
         if not is-deadline work.deadline 
           Work.update {title:"only"}, {$set:{requirment:req.param('requirment')}}, (error)!->
      res.redirect '/home'
  router.post '/modify-deadline', (req, res)!-> 
    Work.findOne {title:'only'}, (error,work)!->
        if not is-deadline work.deadline 
           Work.update {title:"only"}, {$set:{deadline:req.param('deadline')}},(error)!->
    res.redirect '/home'
  router.post '/update-homework', (req, res)!-> 
    Work.findOne {title:'only'}, (error,work) !->
        if work
            Assignment.findOne {id_:req.param('id')} (error,assignment_)!->
               if assignment_ 
                  if not is-deadline work.deadline
                     Assignment.update {id_:req.param('id')}, {$set:{assignment:req.param('homework')}},(error)!->
               else
                   new-assignment = new Assignment {
                   id_:req.param('id')
                   title:'only'
                   name:req.param('username')
                   assignment:req.param('homework')
                   score:'未评分'
                   }  
                   new-assignment.save(error) ->
                     if error
                       console.log "Error in saving user: ", error
                       throw error
                     else
                       res.render 'home', {homework: work,assign:assignment_}
    res.redirect '/home'

  router.post '/push-a-homework', (req, res)!->
     Work.findOne {title:'only'}, (error,homework)!->
       if homework
         Work.update {title:'only'},{$set:{requirment:req.param('onlyrequirment'),deadline:req.param('onlydeadline')}},(error)!->
       else
         new-homework = new Work {
           title:'only'
           requirment:req.param('onlyrequirment')
           deadline:req.param('onlydeadline')
         }   
         new-homework.save (error)->
            if error
               console.log "Error in saving user: ", error
               throw error
     Assignment.remove {title:'only'}, (error)!->
     res.redirect '/home' 
  router.post '/score', (req, res)!-> 
       i = 0
       finialscore = []
       for scores in req.param('score')
         finialscore[i++] = scores
       i = 0  
       for ids in req.param('id')
           Assignment.update {id_:ids}, {$set:{score:finialscore[i++]}},(error)!-> 
       res.redirect '/home'
 
          