$ !->
  today = new Date!
  date = today.get-date!.to-string!
  month = (today.get-month! + 1).to-string!
  year = today.get-full-year!

  if date.length is 1 then date = '0' + date
  if month.length is 1 then month = '0' + month

  today = year + '-' + month + '-' + date
  console.log today

  $ 'input[name=deadline]' .val today

  $ "form" .submit ->
    if ($ 'input[name=title]' .val!) is ''
      alert 'The title can\'t be empty'
      return false
    if ($ 'textarea' .val!) is ''
      alert 'The description can\'t be empty'
      return false

    today = new Date!
    deadline = new Date (document .get-elements-by-name 'deadline')[0].value
    console.log deadline

    if deadline < today
      alert 'The deadline can\'t be earlier than today'
      return false

    return true
