(function(){
  var mongoose;
  mongoose = require('mongoose');
  module.exports = mongoose.model('Requirement', {
    master: String,
    id: String,
    Head: String,
    ddl: String,
    content: String
  });
}).call(this);
