require! {fs, Issue:'../models/issue'}

module.exports = (req, res) !->
    return console.log 'No authority to do that!' if req.user.role isnt 'teacher'
    filename = 'None'
    if req.files.file
      upload-file = req.files.file
      temp-path = upload-file.path
      new-path = "uploads/issue/#{upload-file.originalname}"
      filename := upload-file.originalname
      (error) <- fs.rename temp-path, new-path
      console.log error if error
    new-issue = new Issue {
      username  : req.user.username
      deadline  : req.param 'deadline'
      title     : req.param 'title'
      content   : req.param 'content'
      filename  : filename
    }
    (error)<- new-issue.save 
    if error
      console.log "Error in saving issue: ", error
      throw error
    else
      console.log "Issue save success"
      req.flash 'message', 'Issue homework successfully!'
      res.redirect '/home'