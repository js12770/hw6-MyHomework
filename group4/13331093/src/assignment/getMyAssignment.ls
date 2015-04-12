require! {myAssignment:'../models/myassignment'}

# 获取学生提交的作业详情
module.exports = (req, res) !->
  id = req.params.id
  myAssignment.findById id, (err, doc)!->
    res.render 'myAssignmentDetail', user: req.user, assignment: doc
