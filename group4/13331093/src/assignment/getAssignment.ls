require! {Assignment:'../models/assignment'}
require! moment

# 获取作业，作业列表
module.exports = (req, res, id?, teacher?) !->
  if teacher
  #读出作业详情传递给老师修改作业的页面
    Assignment.findById id, (err, doc)!->
      # 判断是否到达截止时间，若超过则无法修改
      valid = doc.deadline > (moment new Date()).format 'YYYY-MM-DD HH:mm'
      if not valid
        console.log '该作业已超过截止时间'
        req.flash 'message', '该作业已超过截止时间'
        res.redirect '/assignment'
      else
        res.render 'setAssignment', user: req.user, title: doc.title, deadline: doc.deadline, content: doc.content, msg: req.flash 'message'
  else if id
  # 发布的作业详细页
    Assignment.findById id, (err, doc)!->
      valid = doc.deadline > (moment new Date()).format 'YYYY-MM-DD HH:mm'
      res.render 'assignmentDetail', user: req.user, assignment: doc, aid: id, isvalid: valid, msg: req.flash 'message'
  else
  # 作业列表
    Assignment.find (err,assi) !->
      assi.sort (a,b) !-> return a.deadline > b.deadline
      res.render 'assignment', user: req.user, assignments: assi, msg: req.flash 'message'
