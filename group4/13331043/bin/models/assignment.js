(function(){
  var mongoose;
  mongoose = require('mongoose');
  module.exports = mongoose.model('Assignment', {
    title: String,
    description: String,
    deadline: String,
    teacherId: String
  });
}).call(this);
