require! './setAssignment'
require! './getAssignment'
require! './submitAssignment'
require! './deleteAssignment'
require! './editAssignment'
require! './getMyAssignment'
require! './getAssignmentList'
require! './rateAssignment'
require! './getMyAssignmentJson'

# 获取发布的作业详情/发布的作业详细页/读出作业详情传递给修改作业页面
module.exports.get = getAssignment
# 老师发布作业
module.exports.set = setAssignment
# 学生提交作业
module.exports.submit = submitAssignment
# 老师删除作业
module.exports.delete = deleteAssignment
# 老师编辑作业
module.exports.edit = editAssignment
# 获取学生提交的作业详情
module.exports.myAssignment = getMyAssignment
# 老师/学生获取提交的作业的列表
module.exports.getAssignmentList = getAssignmentList
# 老师给作业评分
module.exports.rateAssignment = rateAssignment
# 获取作业详情的JSON格式
module.exports.getMyAssignmentJson = getMyAssignmentJson