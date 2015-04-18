require! {myAssignment:'../models/myassignment'}
require! moment

# 获取提交的作业详细信息(JSON格式)
module.exports = (req, res) !->
  myAssignment.findById req.query.aid, (err, doc)!->
    valid = doc.deadline > (moment new Date()).format 'YYYY-MM-DD HH:mm'
    ret = {assignment: doc, aid: req.query.aid, isvalid: valid}
    res.json ret
