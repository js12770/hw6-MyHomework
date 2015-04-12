require! {Issue:'../models/issue'}

module.exports = (req, res) !->
    new-issue = new Issue {
      username  : req.user.username
      deadline  : req.param 'deadline'
      title     : req.param 'title'
      content   : req.param 'content'
    }
    new-issue.save (error)->
      if error
        console.log "Error in saving issue: ", error
        throw error
      else
        console.log "Issue save success"
    #req.flash 'message', 'Issue successfully!'
    res.redirect '/home'