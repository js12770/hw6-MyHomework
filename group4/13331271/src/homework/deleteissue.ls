require! {Issue:'../models/issue'}

module.exports = (req, res) !->
    return console.log 'No authority to do that!' if req.user.role isnt 'teacher'
    (error) <- Issue.remove({_id: req.param 'id'})
    return (console.log "Error: ", error) if error
    req.flash 'message', 'Delete homework successfully!'
    res.redirect '/home'
