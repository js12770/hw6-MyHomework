require! {Issue:'../models/issue'}
require! moment

module.exports = (req, res) !->
    (error, issues) <- Issue.find {username: req.user.username}
    return (console.log "Error: ", error) if error
    now-time = (moment new Date()).format 'YYYY-MM-DD HH:mm'
    res.render 'teacher', user: req.user, issues: issues, now-time: now-time, message: req.flash 'message'
