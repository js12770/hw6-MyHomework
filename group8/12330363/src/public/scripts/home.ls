$ ->
  init!

init = !->
  get-spec-and-render!
  get-hw-and-render!

  init-new-spec!
  init-new-hw!
  init-btns-grade-hw!


init-new-spec = !->
  $ '#new-spec' .click !->
    ($ 'h4.modal-title') .text 'New Homework Specification'
    input-rows = $ '.form-control'
    ($ input-rows[0]) .val 'Homework title'
    ($ input-rows[1]) .val 'Deadline (YYYY-MM-DD HH:MM:SS)'
    $ 'textarea' .val 'Homework content here...'
    $ '#editor' .modal 'show'

  init-btn-save-specification!

init-new-hw = !->
  $ '#new-hw' .click !->
    ($ 'h4.modal-title') .text 'New Homework'
    input-rows = $ '.form-control'
    ($ input-rows[0]) .val 'Homework title'
    ($ input-rows[1]) .hide!
    $ 'textarea' .val 'Homework content here...'
    $ '#editor' .modal 'show'

  init-btn-save-homework!

init-btns-edit-spec = !->
  for let btn, i in $ '.edit-spec'
    ($ btn).click !->
      # Load contents to the modal
      tds = ($ btn .parent!) .siblings!
      ($ 'h4.modal-title') .text 'Edit Homework Specification'
      input-rows = $ '.form-control'
      ($ input-rows[0]) .val ($ tds[0] .text!)
      ($ input-rows[1]) .val ($ tds[2] .text!)
      ($ 'textarea') .val ($ tds[4] .text!)
      $ '#editor' .modal 'show'

  init-btn-save-specification!

init-btns-grade-hw = !->
  for let btn, i in $ '.grade-hw'
    ($ btn).click !->
      # Load contents to the modal
      ($ 'h4.modal-title') .text 'Grading'
      input-rows = $ '.form-control'
      ($ input-rows[0]) .val 'Grade: 0 - 100'
      ($ input-rows[1]) .hide!
      $ 'textarea' .val ''
      $ '#editor' .modal 'show'
      # post grade
      $.post '/grade_homework',
        title: 'todo',
        grades: ($ input-rows[0]) .val!

init-btns-edit-hw = !->
  for let btn, i in $ '.edit-hw'
    ($ btn).click !->
      # Load contents to the modal
      tds = ($ btn .parent!) .siblings!
      ($ 'h4.modal-title') .text 'Edit Homework'
      input-rows = $ '.form-control'
      ($ input-rows[0]) .val ($ tds[0] .text!)
      ($ input-rows[1]) .hide!
      ($ 'textarea') .val ($ tds[4] .text!)
      $ '#editor' .modal 'show'

  init-btn-save-homework!


# Use for simple rendering
get-spec-and-render = !->
  $.getJSON '/get_specification', (specs) !~>
    render-string = ''
    for spec in specs
      row-string = '<tr>'
      if $ '#homework' .has-class 'true'
      then btn-string = '<td><button class="btn btn-sm btn-primary edit-spec">Edit</button></td>'
      row-string += btn-string
      for attr in [spec.title, spec.version, new Date(spec.deadline).toLocaleString!, spec.author, spec.content]
        row-string += '<td>' + attr + '</td>'
      row-string += '</tr>'
      render-string += row-string
    $ '#specification tbody' .html render-string

    init-btns-edit-spec!

# Use for simple rendering
get-hw-and-render = !->
  $.getJSON '/get_homework', (hws) !~>
    render-string = ''
    for hw in hws
      row-string = '<tr>'
      if $ '#homework' .has-class 'true'
      then btn-string = '<td><button class="btn btn-sm btn-primary grade-hw">Grade</button></td>'
      else if $ '#homework' .has-class 'false'
      then btn-string = '<td><button class="btn btn-sm btn-primary edit-hw">Edit</button></td>'

      row-string += btn-string
      for attr in [hw.specTitle, hw.version, new Date(hw.modifiedDate).toLocaleString!, hw.author, hw.content, hw.grades]
        row-string += '<td>' + attr + '</td>'
      row-string += '</tr>'
      render-string += row-string
    $ '#homework tbody' .html render-string

    if $ '#homework' .has-class 'true'
      init-btns-grade-hw!
    else if $ '#homework' .has-class 'false'
      init-btns-edit-hw!


init-btn-save-specification = !->
  $ '#save' .click !->
    input-rows = $ '.form-control'
    $.post '/post_specification',
      title: ($ input-rows[0]) .val!,
      deadline: new Date(($ input-rows[1]) .val!),
      content: ($ 'textarea') .val!
    get-spec-and-render!

init-btn-save-homework = !->
  $ '#save' .click !->
    input-rows = $ '.form-control'
    $.post '/submit_homework',
      title: ($ input-rows[0]) .val!,
      deadline: new Date(($ input-rows[1]) .val!),
      content: ($ 'textarea') .val!
    get-hw-and-render!
