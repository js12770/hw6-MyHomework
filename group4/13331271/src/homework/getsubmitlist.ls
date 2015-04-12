require! {Submission:'../models/submission'}

module.exports = (req, res) !->
    (error, submit-list) <- Submission.find {title: req.param 'title'}
    console.log 'run'
    return (console.log "Error: ", error) if error
    res.render 'grade', user: req.user, submit-list: submit-list, title: req.param 'title'