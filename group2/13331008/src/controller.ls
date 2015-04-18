require! {mongoose, './models/homeworkPublish', './models/homeworkSubmit'}

module.exports =
  is-before-deadline: (req, res, callback)!->
    Homework-publish = mongoose.model 'HomeworkPublish'

    Homework-publish.find-one title: req.body.belong-to, (error, homework-publish)!->
      console.log 'in-is-before-deadline-callback-start-----------------------'

      today = new Date!
      deadline = new Date homework-publish.deadline

      console.log today <= deadline

      if today <= deadline then callback req, res

      console.log 'in-is-before-deadline-callback-start-----------------------'

  is-after-deadline: (req, res, callback)!->
    Homework-publish = mongoose.model 'HomeworkPublish'

    console.log 'here----------------'
    console.log req.body.belong-to
    console.log 'here----------------'

    Homework-publish.find-one title: req.body.belong-to, (error, homework-publish)!->
      console.log 'in-is-after-deadline-callback-start-----------------------'

      today = new Date!
      deadline = new Date homework-publish.deadline

      console.log today > deadline

      if today > deadline then callback req, res

      console.log 'in-is-after-deadline-callback-start-----------------------'

  publish: (req, res)!->
    Homework-publish = mongoose.model 'HomeworkPublish'

    Homework-publish-options =
      title: req.body.title
      description: req.body.description
      deadline: req.body.deadline
      publisher: req.user.username

    new-homework-publish = new Homework-publish Homework-publish-options

    new-homework-publish.save (err, new-homework-publish)!->
      if err then console.log err
      else console.log 'save success'


  show-homework-publish: (req, res)!->
    Homework-publish = mongoose.model 'HomeworkPublish'

    Homework-publish.find (error, homework-publish-list)!->
      res.render 'home', user: req.user, homework-publish-list: homework-publish-list

  show-homework-submit: (req, res)!->
    Homework-submit = mongoose.model 'HomeworkSubmit'

    Homework-submit.find belong-to: req.query.belong-to, (error, homework-submit-list)!->
      if req.user.type is 'student'
        homework-submit-list = [homework for homework in homework-submit-list when homework.submitter is req.user.username]

      res.render 'submitlist', user: req.user, homework-submit-list: homework-submit-list, belong-to: req.query.belong-to, deadline: req.query.deadline

  grade-homework-submit: (req, res)!->
    Homework-submit = mongoose.model 'HomeworkSubmit'

    grade-options = $set: score: req.body.score

    Homework-submit.update belong-to: req.body.belong-to, submitter: req.body.submitter, grade-options, (err, grade-homework-submit)!->
      if err then console.log err
      else console.log 'score success'

  modify: (req, res)!->
    Homework-publish = mongoose.model 'HomeworkPublish'

    Homework-publish-options =
      $set:
        title: req.body.title
        description: req.body.description
        deadline: req.body.deadline

    Homework-publish .update title: req.body.belong-to, Homework-publish-options, (err, modify-homework-publish)!->
      if err then console.log err
      else console.log 'modify success'

  submit: (req, res)!->
    Homework-submit = mongoose.model 'HomeworkSubmit'

    Homework-submit.find-one-and-remove belong-to: req.body.belong-to, submitter: req.user.username, (error, homework-submit-list)!->

      Homework-submit-options =
        title: req.body.title
        content: req.body.content
        belong-to: req.body.belong-to
        submitter: req.user.username
        score: -1

      new-homework-submit = new Homework-submit Homework-submit-options
      new-homework-submit.save (err, new-homework-submit)!->
        if err then console.log err
        else console.log 'submit-homework save success'