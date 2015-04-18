<-! $
$login-form = $ '.login.form'
$signup-form = $ '.signup.form'
$assignment-form = $ '.assignment.form'
$homework-form = $ '.homework.form'
$message-container = $ '#message-container'

$login-form.form {
  username:
    identifier: 'username'
    rules: [{type: 'empty', prompt: 'Please enter your username'}]
  password:
    identifier: 'password'
    rules: [{type: 'empty', prompt: 'Please enter your password'}]
}

$signup-form.form {
  username:
    identifier: 'username'
    rules: [{type: 'empty', prompt: 'Please enter your username'}]
  password:
    identifier: 'password'
    rules: [{type: 'empty', prompt: 'Please enter your password'}]
  usertype:
    identifier: 'usertype'
    rules: [{type: 'empty', prompt: 'Please enter your usertype'}]
  firstName:
    identifier: 'firstName'
    rules: [{type: 'empty', prompt: 'Please enter your firstName'}]
  lastName:
    identifier: 'lastName'
    rules: [{type: 'empty', prompt: 'Please enter your lastName'}]
}

$assignment-form.form {
  title:
    identifier: 'title'
    rules: [{type: 'empty', prompt: 'Please enter your title'}]
  detials:
    identifier: 'detials'
    rules: [{type: 'empty', prompt: 'Please enter your detials'}]
  assignmentDate:
    identifier: 'assignmentDate'
    rules: [{type: 'empty', prompt: 'Please enter your ddlDate'}]
  ddlTime:
    identifier: 'ddlTime'
    rules: [{type: 'empty', prompt: 'Please enter your ddlTime'}]
}

$homework-form.form {
  homework:
    identifier: 'homework'
    rules: [{type: 'empty', prompt: 'Please enter your homework'}]
}

$message-container.animate wide: 0, 3000, null

($ '.dropdown') .dropdown!

