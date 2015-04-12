require! {Issue:'../models/issue'}

module.exports = (req, res) !->
    (error, issues) <- Issue.find {username: req.user.username}
    return (console.log "Error: ", error) if error
    res.render 'teacher', user: req.user, issues: issues
