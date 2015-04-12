require! {Issue:'../models/issue'}
require! {Submission:'../models/submission'}
require! {User:'../models/user'}
require! moment

module.exports = (req, res) !->
    <- Submission.remove({title: req.param 'title', username: req.user.lastName + req.user.firstName})
    new-submit = new Submission {
      id        : req.param 'id'
      username  : req.user.lastName + req.user.firstName
      submittime: (moment new Date()).format 'YYYY-MM-DD HH:mm'
      score     : 'None'
      title     : req.param 'title'
      content   : req.param 'content'
    }
    new-submit.save (error)->
      if error
        console.log "Error in saving submit: ", error
        throw error
      else
        console.log "submit save success"
    #req.flash 'message', 'Issue successfully!'
    res.redirect '/home'