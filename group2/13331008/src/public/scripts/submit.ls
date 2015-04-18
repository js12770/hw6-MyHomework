$ !->
  $ 'form' .on 'submit' !->
    if $ 'input[name=title]' .val! is ''
      alert 'The title can\'t be empty'
      return false

    if $ 'textarea' .val! is ''
      alert 'The content can\'t be empty'
      return false

    return true