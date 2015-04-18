require! {'express', Homework:'../models/homework', Announcement:'../models/announcement'}

class db
  @find-all-announcements-at-home = (req, res)!->
    Announcement.find {}, (error, docs)!->
      if error then throw error
      res.render 'home', user: req.user, announcement: docs

  @create-new-homework-return-to-view = (req, res)!->
    title = req.param 'produced-question-title'
    content = req.param 'produced-question-content'
    createTime = new Date!
    _ddl = req.param 'produced-question-date'
    ddl = _ddl.slice(0, 10) + ' ' + _ddl.slice(11, 16)
    homework = new Homework {
      title         : title
      producerID    : req.user.username
      producerName  : req.user.firstName + '.' + req.user.lastName
      question      : content
      createTime    : createTime
      ddl           : ddl
    }
    homework.save (error)!->
      if error
        console.log "Error in publishing homework: ", error
        throw error
      else
        console.log "Homework publish success"
        res.redirect '/hw-view'

  @find-all-homework-at-view = (req, res)!->
    Homework.find {}, (error, docs_1)!->
      if error then throw error
      Announcement.find { username: req.user.username }, (error, docs_2)!->
        if error then throw error
        res.render 'homework-view', user: req.user, hwlist: docs_1, announcement: docs_2, date: new Date!
  
  @find-pointed-homework-and-find-latest-answer = (req, res)!->
    Homework.find { _id: req.params[0] }, (error, docs_1)!->
      if error then throw error
      Announcement.find {
        username : req.user.username
        hw_id    : req.params[0]
      }, (error, docs_2)!-> 
        if error then throw error
        res.render 'homework-answer', user: req.user, question: docs_1[0], announcement: docs_2, date: new Date!

  @create-or-update-latest-announcement-return-to-home = (req, res)!->
    hw_id = req.param 'answer-question-id'
    answer = req.param 'answer-question-content'
    Homework.find { _id: hw_id }, (error, docs)!->
      if error
        console.log 'Can not find answered homework:' + error
        throw error
      else
        if (new Date!) > docs[0].ddl
          res.redirect '/hw-view'
          return
        newdate = new Date!
        Announcement.update {
          hw_id      : hw_id
          username   : req.user.username
        }, {
          question   : docs[0].question
          answer     : answer
          commitTime : newdate
          $inc: {nth : 1}
        }, (error, numberAffected, raw)!->
          if error
            console.log 'Error in updating announcement answer:' + error
            throw error
          else if numberAffected is 0
            announcement = new Announcement {
              username   : req.user.username
              firstName  : req.user.firstName
              lastName   : req.user.lastName
              producerID : docs[0].producerID
              hw_id      : docs[0]._id
              title      : docs[0].title
              question   : docs[0].question
              answer     : answer
              commitTime : newdate
            }
            announcement.save (error)!->
              if error
                console.log 'Error in saving new announcement answer:' + error
                throw error
            console.log 'Create an announcement success'
            res.redirect '/home'
          else
            console.log 'Update an announcement success'
            res.redirect '/home'

  @find-pointed-homework-ready-to-modify = (req, res)!->
    Homework.find { _id: req.params[0] }, (error, docs)!->
      if error then throw error
      res.render 'homework-modify', user: req.user, question: docs[0], flag: req.params[1], date: new Date!

  @update-homework-content-return-to-view = (req, res)!->
    id = req.param 'modified-question-id'
    content = req.param 'modified-question-content'
    Homework.update {
      _id      : id
    }, {
      question : content
    }, (error, numberAffected, raw)!->
      if error
        console.log 'Error in updating homework content modification:' + error
        throw error
      else
        res.redirect '/hw-view'

  @update-homework-ddl-return-to-view = (req, res)!->
    id = req.param 'modified-question-id'
    _ddl = req.param 'modified-question-date'
    ddl = _ddl.slice(0, 10) + ' ' + _ddl.slice(11, 16)
    Homework.update {
      _id : id
    }, {
      ddl : ddl
    }, (error, numberAffected, raw)!->
      if error
        console.log 'Error in updating homework ddl modification:' + error
        throw error
      else
        res.redirect '/hw-view'

  @find-all-annoucements-of-pointed-homework-at-check = (req, res)!->
    Announcement.find { hw_id: req.params[0] }, (error, docs)!->
      if error
        console.log 'Error in finding hw-check:' + error
        throw error
      else
        res.render 'homework-check', user: req.user, announcement: docs

  @find-pointed-announcement-at-grade = (req, res)!->
    id = req.params[0]
    hw_id = req.params[1]
    Announcement.find { _id: id}, (error, docs_1)!->
      if error or docs_1.length is 0
        console.log 'Error in grading announcement:' + error
        res.redirect '/hw-check/' + hw_id
      else
        Homework.find { _id: docs_1[0].hw_id }, (error, docs_2)!->
          if error then throw error
          res.render 'homework-grade', user: req.user, announcement: docs_1[0], question: docs_2[0], date: new Date!

  @update-announcement-grade-return-to-check = (req, res)!->
    id = req.params[0]
    hw_id = req.params[1]
    grade = req.param 'checked-announcement-grade'
    Announcement.update {
      _id   : id
    }, {
      grade : grade
    }, (error, numberAffected, raw)!->
      if error
        console.log 'Error in updating announcement grade:' + error
        res.redirect '/hw-check/' + hw_id
      else
        res.redirect '/hw-check/' + hw_id

module.exports = db