require! {Submission:'../models/submission'}

module.exports = (req, res) !->
    return console.log 'No authority to do that!' if req.user.role isnt 'teacher'
    submit-id = req.param 'id'
    score = req.param 'score'
    (err) <- Submission.update {_id: submit-id}, {$set: {score : score}}
    return console.log "Error in grade #{err}" if err
    req.flash 'message', 'Grade successfully!'
    res.redirect "/grade?title=#{req.param 'title'}"