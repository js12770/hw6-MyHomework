require! {myAssignment:'../models/myassignment'}

# 老师给作业评分
module.exports = (req, res) !->
  score =  {
    status: req.body.score
  }
  myAssignment.update {_id: req.params.id}, score, {}, (err) ->
    console.log err if err
    res.redirect '/correctassignment'