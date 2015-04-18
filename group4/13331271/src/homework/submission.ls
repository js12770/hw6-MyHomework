require! {Issue:'../models/issue'}
require! {Submission:'../models/submission'}
require! {User:'../models/user'}
require! moment
require! fs

module.exports = (req, res) !->
    filename = 'None'
    if req.files.file
      upload-file = req.files.file
      temp-path = upload-file.path
      new-path = "uploads/submit/#{upload-file.originalname}"
      filename := upload-file.originalname
      (error) <- fs.rename temp-path, new-path
      console.log error if error
    <- Submission.remove {title: req.param('title'), username: (req.user.lastName + req.user.firstName)}
    new-submit = new Submission {
      id        : req.param 'id'
      username  : req.user.lastName + req.user.firstName
      submittime: (moment new Date()).format 'YYYY-MM-DD HH:mm'
      score     : 'None'
      title     : req.param 'title'
      content   : req.param 'content'
      filename  : filename
    }
    (error) <- new-submit.save!
    if error
      console.log "Error in saving submit: ", error
      throw error
    else
      console.log "submit save success"
      req.flash 'message', 'Submit homework successfully!'
      res.redirect '/home'