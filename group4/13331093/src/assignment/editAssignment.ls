require! {myAssignment:'../models/myassignment'}
require! {Assignment:'../models/assignment'}


# 老师编辑作业
module.exports = (req, res) !->
  assigment-infor = req.body
  
  new-assignment =  {
    deadline: assigment-infor.deadline
    title: assigment-infor.title
    content: assigment-infor.content
  }
  Assignment.update {_id: req.query.aid}, new-assignment, {}, (err) ->
    #更新相关作业的学生的提交
    myAssignment.where {'assignmentid': req.query.aid} .setOptions { multi: true } .update { deadline: assigment-infor.deadline, title: assigment-infor.title }, (err) !->
      console.log err if err
    if err
      console.log "编辑失败" 
      req.flash 'message', '编辑失败'
    else
      req.flash 'message', '编辑成功'
    res.redirect '/assignment'