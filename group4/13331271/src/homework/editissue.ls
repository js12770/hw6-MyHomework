require! {fs, Issue:'../models/issue'}

module.exports = (req, res) !->
    return console.log 'No authority to do that!' if req.user.role isnt 'teacher'
    console.log "req.files", req.files
    filename = 'None'
    if req.files.file
      upload-file = req.files.file
      temp-path = upload-file.path
      new-path = "uploads/issue/#{upload-file.originalname}"
      filename := upload-file.originalname
      (error) <- fs.rename temp-path, new-path
      console.log error if error
    return console.log 'Edit issue fail!' if req.user.role isnt 'teacher'
    (error) <- Issue.update {title: req.param 'title'}, {$set: {
        deadline: req.param 'deadline'
        content	: req.param 'content'
        filename: filename
    }}
    return (console.log "Error: ", error) if error
    req.flash 'message', 'Modify issue successfully!'
    res.redirect '/home'