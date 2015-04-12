require! {Submission:'../models/submission'}

module.exports = (req, res) !->
    submit-id = req.param 'id'
    score = req.param 'score'
    (err) <- Submission.update {_id: submit-id}, {$set: {score : score}}
    console.log "Error in grade #{err}" if err
    res.redirect "/grade?title=#{req.param 'title'}"