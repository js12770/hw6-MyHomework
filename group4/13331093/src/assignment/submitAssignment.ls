require! {myAssignment:'../models/myassignment'}
require! {Assignment:'../models/assignment'}
require! moment

# 学生提交作业
module.exports = (req, res) !->
  assigment-infor = req.body
  console.log "用户：", req.user, "提交作业：", assigment-infor

  Assignment.findById req.params.id, (err, doc)!->
      assititle = doc['title']
      #判断是否超过截止日期,如果是的话则无法提交
      valid = doc['deadline'] > (moment new Date()).format 'YYYY-MM-DD HH:mm'
      console.log "是否有效:", valid
      if not valid
        req.flash 'message', '已超过截止日期'
        res.redirect '/assignment'
      else
        condition = {'assignmentid': req.params.id, 'userid': req.user._id.toString!}
        #检查是否已存在作业，如果是就覆盖
        myAssignment.count condition, (err, number)!->
          # 首次提交
          if number is 0
            console.log "首次提交"
            new-assignment = new myAssignment {
              userid: req.user._id,
              username: req.user.username,
              content: assigment-infor.content,
              assignmentid: req.params.id,
              deadline: doc['deadline'],
              title: assititle,
              status: '已提交',
            }
            new-assignment.save (error) ->
              if error
                  console.log "提交作业失败", error
                  req.flash 'message', '提交失败'
              else
                  console.log "提交作业成功", new-assignment
                  req.flash 'message', '提交成功'
              res.redirect '/myassignment'
          # 已提交过的话，覆盖原作业
          else
            myAssignment.where condition .update { content: assigment-infor.content }, (err) !->
              console.log err if err
              req.flash 'message', '提示：已提交过，覆盖原作业'
              res.redirect '/myassignment'