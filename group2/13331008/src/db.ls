require! {$: './public/scripts/jquery.min' ,mongoose}

module.exports =
  url: 'mongodb://localhost/my-homework'

  publish: (homework-input-info, publisher)!->
    console.log 'here is db-publish'


    db = mongoose.connection

    Homework-publish = mongoose.model 'HomeworkPublish'

    Homework-publish-option =
      title: homework-input-info.title
      description: homework-input-info.description
      deadline: homework-input-info.deadline
      publisher: publisher

    new-homework-publish = new Homework-publish Homework-publish-option

    new-homework-publish.save (err, new-homework-publish)!->
      if err then console.log err
      else console.log 'save success'


  show-homework-publish: (req, res)!->
    db = mongoose.connection

    Homework-publish = mongoose.model 'HomeworkPublish'

    Homework-publish.find (error, homework-publish-list)!->
      console.log 'db-show-error-before-------------------'

      if error then console.log error

      console.log 'db-show-error-after-------------------'

      console.log homework-publish-list

      console.log 'db-show-list-after---------------------'

      res.render 'home', user: req.user, homework-publish-list: homework-publish-list
      # 大坑，注意 homework-publish-list 会被编译成 homeworkPublishList

  show-homework-submit: (req, res)!->
    db = mongoose.connection

    Homework-submit = mongoose.model 'HomeworkSubmit'

    Homework-submit.find (error, homework-submit-list)!->
      console.log 'db-show-submit-error-before-------------------'

      if error then console.log error

      console.log 'db-show-submit-error-after-------------------'

      console.log homework-submit-list

      console.log 'db-show-submit-list-after---------------------'

      res.render 'submitlist', user: req.user, homework-submit-list: homework-submit-list

  modify: (homework-input-info)!->
    console.log 'here is db-modify-------------------'

    db = mongoose.connection

    Homework-publish = mongoose.model 'HomeworkPublish'

    Homework-publish-option =
      $set:
        title: homework-input-info.title
        description: homework-input-info.description
        deadline: homework-input-info.deadline

    console.log homework-input-info.modify
    console.log 'here is db-modify-after-option-----------'

    try
      Homework-publish .update title: homework-input-info.modify, Homework-publish-option, (err, modify-homework-publish)!->
        console.log 'here is modify callback---------------------------'
        if err
          console.log err
          console.log 'here is modify callback-after--------------------'
        else console.log 'modify success'
    catch err
      console.log 'modify-err----------'
      console.log err

  submit: (homework-submit-info, submitter)!->
    console.log 'here is db-submit'

    db = mongoose.connection

    Homework-submit = mongoose.model 'HomeworkSubmit'

    Homework-submit.find-one-and-remove belong-to: homework-submit-info.belong-to, submitter: submitter, (error, homework-submit-list)!->

      console.log 'here s db-remove-callback'

      Homework-submit-option =
        title: homework-submit-info.title
        content: homework-submit-info.content
        belong-to: homework-submit-info.belong-to
        submitter: submitter

      new-homework-submit = new Homework-submit Homework-submit-option
      new-homework-submit.save (err, new-homework-submit)!->
        if err then console.log err
        else console.log 'submit-homework save success'
