require! ['./teacherhome', './issue', './studenthome', './submission', './grade', './getsubmitlist', './deleteissue', './editissue']

module.exports = {
    teacher     : teacherhome    # 教师端的首页
    issue       : issue          # 老师发布作业
    student     : studenthome    # 学生端首页
    submit      : submission     # 学生提交作业
    grade       : grade          # 老师打分
    submit-list : getsubmitlist  # 老师获得所有人的提交列表
    del         : deleteissue    # 老师删除发布的作业
    edit        : editissue      # 老师编辑发布的作业
}