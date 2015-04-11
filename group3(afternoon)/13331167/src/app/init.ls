require! {'./login', './signup', User: '../models/user', Assignment: '../models/assignment', 'bcrypt-nodejs'}

hash = (password)-> bcrypt-nodejs.hash-sync password, (bcrypt-nodejs.gen-salt-sync 10), null

module.exports = (passport)-> 
  passport.serialize-user (user, done)->
    console.log 'serialize user: ', user
    done null, user._id

  passport.deserialize-user (id, done)-> User.find-by-id id, (error, user)!->
    console.log 'deserialize user: ', user
    done error, user

  Assignment.fetch (err, assignments)!->
    if err
      console.log err
    if assignments.length is 0
      _assignment = new Assignment {
        name:        'MyHomework'
        description: 'MyHomework 是一个基于ExpressJS的Web 2.0应用，老师可以发布作业，学生可以提交作业。\r\n\r\n角色: 学生，老师。\r\n访问管理：\r\n只有选定了本课程老师和学生才能够访问使用本系统。\r\n老师可以看到所有的作业要求和所有学生提交的作业。\r\n学生能看到所有的作业要求，但只能够看到自己的作业。\r\n发布作业要求：老师可以发布作业要求，也可以修改一个已发布但是尚未截止的作业要求。\r\n提交作业：学生可以提交作业（可以多次提交作业，系统将保留最新的版本）。\r\ndeadline：老师可以设定/修改作业要求的截止时间，截止时间到达后，任何学生都将无法提交作业。\r\n作业评分: 截止时间到达之后，老师可以批改作业给出分数。\r\n'
        deadline:    '6.9'
        teacher:     '王青'
      }
      _assignment.save (err)!->
        if err
          console.log err

      _teacher = new User {
        username  : 'admin'
        password  : hash 'admin'
        email     : 'admin@126.com'
        firstName : '王青'
        lastName  : '王青'
        role      : 'teacher'
      }
      _teacher.save (error)->
        if error
          console.log "Error in saving user: ", error
          throw error

  login passport
  signup passport
