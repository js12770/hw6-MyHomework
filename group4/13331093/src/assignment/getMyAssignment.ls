require! {myAssignment:'../models/myassignment'}
require! moment

# 获取学生提交的作业详情
module.exports = (req, res) !->
  id = req.params.id
  now = (moment new Date()).format 'YYYY-MM-DD HH:mm'
  myAssignment.findById id, (err, doc)!->
    res.render 'myAssignmentDetail', user: req.user, assignment: doc, time: now
