require! {Submission:'../models/submission'}
require! moment

module.exports = (req, res) !->
    if req.user.role isnt 'teacher'
        return res.render 'error', message: '你没有权限访问该页面！'
    (error, submit-list) <- Submission.find {title: req.param 'title'}
    return (console.log "Error: ", error) if error
    now-time = (moment new Date()).format 'YYYY-MM-DD HH:mm'
    res.render 'grade', user: req.user, submit-list: submit-list, message: req.flash('message'), now-time: now-time, title: req.param('title')