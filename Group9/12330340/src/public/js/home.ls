$ window .load ->
  teacher-add-requirements!
  show-specific-buttons!
  teacher-edit-requirements!
  student-submit-homework!
  student-change-answer!
  teacher-grade!

teacher-add-requirements = !->
  console.log 'add homework'
  $ '#reqSub' .click !->
    ddls = $ '#deadline' .val!
    ddl = ddls.split '-'
    if $ '#requirement' .val! == ''
      if !$ 'p' .has-class 'alert-req'
        $ '#requirement' .after '<p class=alert-req>*please input requirement</p>'
    else
      if $ 'p' .has-class 'alert-req'
        $ '.alert-req' .remove!

    if ddl.length != 3
      if !$ 'p' .has-class 'alert-format'
        $ '#deadline' .after '<p class=alert-format>*please input valid date</p>'
    else
      if $ 'p' .has-class 'alert-format'
        $ '.alert-format' .remove!

    if ddl.length == 3 && $ '#requirement' .val! != ''
      hw = {
        requires : $ '#requirement' .val!
        deadline : $ '#deadline' .val!
        user : $ '#username' .text!
      }
      $.ajax method : 'post', url : '/home/addHw', data : hw, dataType: "json", success : trans hw, error : !~> console.log 'error'


trans = (hw)!->
  console.log 'test'
  $ '#requirement' .val('')
  $ '#deadline' .val('')
  $ '#homeworks' .append('<div class=homework-box><div>'+hw.requires+'</div><span class=deadline>Deadline</span><span class=date>'+hw.deadline+'</span><br><button class="edit btn btn-mini btn-primary">Edit</div>')
  show-specific-buttons!

show-specific-buttons = !->
  buttons = $ '.edit'
  if 0 == buttons.length
    buttons = $ '.show-submit'
  deadline = $ '.date'

  for i from 0 to buttons.length-1 by 1
    ddls = deadline.eq i .text!
    ddl = ddls.split '-'
    mydate = new Date!
    mydate.set-full-year ddl[0],ddl[1]-1,ddl[2]
    today = new Date!
    if today <= mydate
      buttons.eq i .css 'cssText','display: inherit!important'

teacher-edit-requirements = !->
  edit-buttons = $ '.edit'
  requires-html = '<textarea id=reedit-reqs name=requires class=form-control required autofocus>'
  deadline-html = '<input id=reedit-ddl name=deadline class=form-control required>'
  button-html = '<button id=reedit-button class="btn btn-mini btn-primary btn-block">Submit'
  for let i from 0 to edit-buttons.length-1 by 1
    edit-buttons.eq i .click !~>
      hw-text = edit-buttons.eq i .siblings '.homework-requirement' .text!
      ddl-text = edit-buttons.eq i .siblings '.date' .text!
      edit-buttons.eq i .siblings '.homework-requirement' .replace-with requires-html
      edit-buttons.eq i .siblings '.date' .replace-with deadline-html
      edit-buttons.eq i .replace-with button-html
      $ '#reedit-reqs' .val hw-text
      $ '#reedit-ddl' .val ddl-text
      # submit reedited content
      $ '#reedit-button' .click !->
        hw = {
          requires : $ '#reedit-reqs' .val!
          deadline : $ '#reedit-ddl' .val!
          user : $ '#username' .text!
          ex-req : hw-text
          ex-ddl : ddl-text
        }
        $.ajax method : 'post', url : '/home/reeditHw', data : hw, dataType : "json", success : reedit-success hw, error : !~> console.log 'error'

reedit-success = (hw)!->
  $ '#reedit-reqs' .remove!
  $ '#reedit-ddl' .remove!
  $ '#reedit-button' .prev! .remove!
  $ '#reedit-button' .prev! .remove!
  $ '#reedit-button' .replace-with '<div class=homework-requirement>'+hw.requires+'</div><span class=deadline>Deadline</span><span class=date>'+hw.deadline+'</span><br><button class="edit btn btn-mini btn-primary">Edit'
  show-specific-buttons!
  teacher-edit-requirements!

student-submit-homework = !->
  submit-button = $ '.show-submit'
  answer-html = '<div class=answer></div>'
  for let i from 0 to submit-button.length-1 by 1
    if submit-button.eq i .siblings '.answer' .text! != ''
      submit-button.eq i .siblings '.show-change' .css 'cssText','display: inherit!important'
      submit-button.eq i .css 'cssText','display: none!important'
    submit-button.eq i .click !~>
      if submit-button.eq i .siblings '.answer' .text! == ''
        submit-button.eq i .css 'cssText','display: none!important'
        submit-button.eq i .siblings '.submit-box-stu' .css 'cssText','display:inherit'
        submit-button.eq i .before answer-html
        question = submit-button.eq i .siblings '.homework-requirement' .text!
        submit-button.eq i .siblings '.submit-box-stu' .children 'button' .click !->
          ans = {
            user : $ '#username' .text!
            content : submit-button.eq i .siblings '.submit-box-stu' .children 'textarea' .val!
            requires : question
            teacher : submit-button.eq i .siblings '.tea-info' .text!
          }
          $.ajax method : 'post', url : '/home/submitHw', data : ans, dataType : 'json', success : submit-ok(ans,submit-button.eq i), error : !~> console.log 'error'

submit-ok = (ans, dom) !->
  dom.siblings '.submit-box-stu' .css 'cssText','display:none!important'
  dom.siblings '.answer' .css 'display', 'inherit'
  dom.siblings '.answer' .text ans.content
  dom.siblings '.show-change' .css 'cssText', 'display: inherit!important'
  console.log ans.content

student-change-answer = !->
  change-button = $ '.show-change'
  for let i from 0 to change-button.length-1 by 1
    change-button.eq i .click !~>
      ex-answer = change-button.eq i .siblings '.answer' .text!
      change-button.eq i .css 'cssText','display: none!important'
      change-button.eq i .siblings '.submit-box-stu' .css 'cssText','display:inherit'
      change-button.eq i .siblings '.answer' .css 'display','none'
      change-button.eq i .siblings '.submit-box-stu' .children 'textarea' .val ex-answer
      question = change-button.eq i .siblings '.homework-requirement' .text!
      change-button.eq i .siblings '.submit-box-stu' .children 'button' .click !->
        if change-button.eq i .siblings '.submit-box-stu' .children 'textarea' .val! != ''
          ans = {
            user : $ '#username' .text!
            content : change-button.eq i .siblings '.submit-box-stu' .children 'textarea' .val!
            requires : question
            teacher : change-button.eq i .siblings '.tea-info' .text!
          }
          $.ajax method : 'post', url : '/home/changeHw', data : ans, dataType : 'json', success : change-ok(ans,change-button.eq i), error : !~> console.log 'error'

change-ok = (ans, dom) !->
  dom.siblings '.submit-box-stu' .css 'cssText','display:none!important'
  dom.siblings '.answer' .css 'display', 'inherit'
  dom.siblings '.answer' .text ans.content
  dom.css 'cssText', 'display: inherit!important'
  console.log ans.content

teacher-grade = !->
  grade-button = $ '.grading'
  for let i from 0 to grade-button.length-1 by 1
    deadline = grade-button.eq i .parent! .siblings '.date' .text!
    ddl = deadline.split '-'
    mydate = new Date!
    mydate.set-full-year ddl[0],ddl[1]-1,ddl[2]
    today = new Date!
    console.log deadline
    if today <= mydate
      grade-button.eq i .siblings '.student-grade' .text 'Unable to grade'
      grade-button.eq i .css 'cssText','display:none!important'
    else if grade-button.eq i .siblings '.student-grade' .text! != 'Not graded yet'
      grade-button.eq i .css 'cssText','display:none!important'
    else
      grade-button.eq i .click !~>
        grade-button.eq i .siblings '.grade' .css 'cssText','display:inherit!important'
        grade-button.eq i .click !~>
          grade = {
            teacher : $ '#username' .text!
            student : grade-button.eq i .siblings '.student-name' .text!
            requires : grade-button.eq i .parent! .siblings '.homework-requirement' .text!
            grade : grade-button.eq i .siblings '.grade' .val!
          }
          $.ajax method : 'post', url : '/home/grade', data : grade, dataType : 'json', success : grade-ok(grade,grade-button.eq i), error : !~> console.log 'error'

grade-ok = (grade, dom) !->
  dom.css 'cssText','display:none!important'
  dom.siblings '.grade' .css 'cssText','display:none!important'
  dom.siblings '.student-grade' .text 'Grade: '+grade.grade