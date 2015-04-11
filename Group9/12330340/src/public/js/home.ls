$ window .load ->
  teacher-add-requirements!
  student-submit!

teacher-add-requirements = !->
  console.log 'haha'
  $ '#reqSub' .click !->
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
  $ '#homeworks' .append('<div class=homework-box><div>'+hw.requires+'</div><span class=deadline>Deadline</span><span class=date>'+hw.deadline+'</span></div>')

student-submit = !->
  console.log 'lala'