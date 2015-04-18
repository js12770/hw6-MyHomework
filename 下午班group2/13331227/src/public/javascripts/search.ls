getAllTables = ->
  t = document.getElementsByTagName 'table'
  t

makeAllTablesFilterable = (tables) -> (document.getElementById 'searchbutton').addEventListener 'click', Filter

Filter = ->
  s = (document.getElementById 'appendedInputButtons').value
  table = (document.getElementsByTagName 'table').0
  swap = table
  (document.getElementById 'appendedInputButtons').placeholder = ''
  remoteHightlight table
  if not (s.length is 0)
    l = 1
    while l < table.rows.length
      if table.rows[l].innerHTML.match s
        table.rows[l].style.display = ''
        c = 0
        while c < table.rows[l].cells.length
          cellValue = table.rows[l].cells[c].innerHTML
          position = cellValue.search s
          former = string 0, position, cellValue
          key = string position, position + s.length, cellValue
          latter = string position + s.length, cellValue.length, cellValue
          table.rows[l].cells[c].innerHTML = former + '<font color=red>' + key + '</font>' + latter
          c++
      else
        table.rows[l].style.display = 'none'
      l++
  else
    l = 1
    while l < table.rows.length
      table.rows[l].style.display = ''
      l++

remoteHightlight = (table) ->
  l = 1
  while l < table.rows.length
    table.rows[l].style.display = ''
    c = 0
    while c < table.rows[l].cells.length
      temp = table.rows[l].cells[c].innerHTML.replace //<.+?>//g, ''
      table.rows[l].cells[c].innerHTML = temp
      c++
    l++

string = (num1, num2, content) ->
  str = ''
  num = num1
  while num < num2
    str += content.charAt num
    num++
  str

window.onload = ->
  tables = getAllTables!
  makeAllTablesFilterable tables