(function(){
  var mongoose;
  mongoose = require('mongoose');
  module.exports = mongoose.model('Homework', {
    detail: String,
    deadline: String,
    course: String,
    homework: String,
    author: String
  });
}).call(this);
