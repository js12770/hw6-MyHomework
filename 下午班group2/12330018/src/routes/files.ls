require('fs');



files.push { name: 'server.js Logo', path: '/server.js'}

files.push { name: 'readme', path: 'readme.txt'}

exports.list req,res ->
  res.render files,{title:'files', files:files}