require! {myAssignment:'../models/myassignment'}
require! {Assignment:'../models/assignment'}

# 老师删除作业
module.exports = (req, res) !->
  console.log "删除作业:", req.query.aid
  Assignment.remove {'_id': req.query.aid}, (err)!->
    # 删除相关题目的学生提交的作业
    myAssignment.remove {'assignmentid': req.query.aid}, (err) !->
      console.log err if err
    if err
      console.log "删除失败" 
      req.flash 'message', '删除失败'
    else
      req.flash 'message', '删除作业成功'
    res.redirect '/assignment'
