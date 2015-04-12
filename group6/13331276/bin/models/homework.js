(function(){
  var mongoose;
  mongoose = require('mongoose');
  module.exports = mongoose.model('Homework', {
    name: String,
    deadline: String,
    requirement: String,
    submitedUser: submitedUser,
    Array: Array
  });
}).call(this);
