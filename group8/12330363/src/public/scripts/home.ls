$ ->
  init!

init = !->
  init-new-spec!
  init-new-hw!
  get-spec-and-render!
  get-hw-and-render!

  #init-btns-edit-spec!
  #init-btns-grade-hw!
  #init-btns-edit-hw!

init-new-spec = !->
  $ '#new-spec' .click !->
    $ '#new-spec-input' .remove-class 'hidden'
    $ '#new-spec' .add-class 'disabled'

  $ '#save-new-spec' .click !->
    spec-info = ($ '#new-spec-input .form-control')
    $.post '/post_specification',
      title: ($ spec-info[0]) .val!,
      deadline: ($ spec-info[1]) .val!,
      content: ($ spec-info[2]) .val!
    get-spec-and-render!
    $ '#new-spec-input' .add-class 'hidden'
    $ '#new-spec' .remove-class 'disabled'

  $ '#cancel-new-spec' .click !->
    $ '#new-spec-input' .add-class 'hidden'
    $ '#new-spec' .remove-class 'disabled'

init-new-hw = !->
  $ '#new-hw' .click !->
    $ '#new-hw-input' .remove-class 'hidden'
    $ '#new-hw' .add-class 'disabled'

  $ '#save-new-hw' .click !->
    hw-info = ($ '#new-hw-input .form-control')
    $.post '/submit_homework',
      title: ($ hw-info[0]) .val!,
      content: ($ hw-info[1]) .val!
    get-hw-and-render!
    $ '#new-hw-input' .add-class 'hidden'
    $ '#new-hw' .remove-class 'disabled'

  $ '#cancel-new-hw' .click !->
    $ '#new-hw-input' .add-class 'hidden'
    $ '#new-hw' .remove-class 'disabled'

init-btns-edit-spec = !->
  # TODO

init-btns-grade-hw = !->
  # TODO


init-btns-edit-hw = !->
  # TODO

get-spec-and-render = !->
  $.getJSON '/get_specification', (specs) !~>
    render-string = ''
    for spec in specs
      row-string = '<tr>'
      btn-string = '<td><button class="btn btn-sm btn-primary edit-spec">Edit</button></td>'
      row-string += btn-string
      for attr in [spec.title, spec.version, new Date(spec.deadline).toLocaleString!, spec.author, spec.content]
        row-string += '<td>' + attr + '</td>'
      row-string += '</tr>'
      render-string += row-string
    $ '#specification tbody' .html render-string


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

