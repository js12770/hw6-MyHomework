require! {myAssignment:'../models/myassignment'}
require! moment
# 老师/学生获取提交的作业的列表
module.exports = (req, res) !->
  #判断是老师还是学生
  now = (moment new Date()).format 'YYYY-MM-DD HH:mm'
  if req.user.identity is 'student'
    myAssignment.find {'userid': req.user._id} (err,doc) !->
      doc.sort (a,b) !->
        if a['status'] == b['status']
          return  a['deadline'] <= b['deadline']
        else
          return a['status'] < b['status']
      res.render 'getAssignmentList', user: req.user, assignments: doc, time: now, msg: req.flash 'message'
  else
    myAssignment.find (err,allAssi) !->
      allAssi.sort (a,b) !->
        if a['status'] == b['status']
          return  a['deadline'] <= b['deadline']
        else
          return a['status'] < b['status']
      res.render 'getAssignmentList', user: req.user, assignments: allAssi, time: now, msg: req.flash 'message'