require! {Assignment:'../models/assignment'}

# 老师发布作业
module.exports = (req, res) !->
  assigment-infor = req.body
  new-assignment = new Assignment {
    id: String
    author: req.user.username
    deadline: assigment-infor.deadline
    title: assigment-infor.title
    content: assigment-infor.content
  }
  new-assignment.save (error) ->
    if error
        console.log "发布作业失败", error
        req.flash 'message', '发布失败'
    else
        console.log "成功发布作业", new-assignment
        req.flash 'message', '发布成功'
    res.redirect '/assignment'
