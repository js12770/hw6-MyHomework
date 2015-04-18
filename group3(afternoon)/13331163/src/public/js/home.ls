$ ->
  add-set-up-course-button!
  add-add-homework-button!
  add-submit-homework-button!

add-set-up-course-button = ->
  $ '#SetUpCourse' .click -> create-form-and-show!

create-form-and-show = ->

  $ '#show' .add-class 'well' .html "<form id=\'addcourse\' style=\'margin: 5em auto\' role=\'form\' action=\'\/addcourse\' method=\'post\' class=\'unvisiable\'><div class=\'form-group\'><label>课程名<input type=\'text\' name=\'coursename\' placeholder=\'请输入开设的课程名\' class=\'form-control\'><\/label><\/div><button type=\'submit\' class=\'btn btn-default\'>提交<\/button><\/form>"


add-add-homework-button = ->
  $ '#AddHomework' .click ->
    create-add-homework-form-and-show!

create-add-homework-form-and-show = ->
  $ '#show' .add-class 'well' .html "<form role=\'form\' action=\'\/addhomework\' method=\'post\' style=\'margin: 5em\'><div class=\'form-group\'><label>课程名<input type=\'text\' name=\'coursename\' placeholder=\'请输入课程名\' class=\'form-control\'><\/label><\/div><div class=\'form-group\'><label>作业名<input type=\'text\' name=\'requirementname\' placeholder=\'请输入作业名\' class=\'form-control\'><\/label><\/div><div class=\'form-group\'><label>截止时间<br/><input type=\'datetime-local\' style=\'size: 30\' name=\'deadline\'><\/label><\/div><div class=\'form-group\'><label>作业要求<textarea rows=\'5\' cols=\'100%\' name=\'requirementcontent\' placeholder=\'请输入作业要求\' class=\'form-control\'\/><\/label><\/div><button type=\'submit\' class=\'btn btn-default\'>提交<\/button></form>"
  console.log ($ '#show' .html)

add-submit-homework-button = ->
  $ '#SubmitHomework' .click -> create-submit-homework-form-and-show!

create-submit-homework-form-and-show = ->
  $ '#show' .add-class 'well' .html "<form role=\'form\' action=\'\/submithomework\' method=\'post\' style=\'margin: 5em auto\'><div class=\'form-group\'><label>课程名<input type=\'text\' name=\'coursename\' placeholder=\'请输入课程名\' class=\'form-control\'><\/label><\/div><div class=\'form-group\'><label>作业名<input type=\'text\' name=\'requirementname\' placeholder=\'请输入作业名\' class=\'form-control\'><\/label><\/div><div class=\'form-group\'><label>你的作业<textarea rows=\'5\' cols=\'100%\'name=\'content\' placeholder=\'请输入你的作业\' class=\'form-control\'\/><\/label><\/div><button type=\'submit\' class=\'btn btn-default\'>提交<\/button><\/form>"
