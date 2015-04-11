(function(){
  var mongoose;
  mongoose = require('mongoose');
  module.exports = mongoose.model('Course', {
    id: String,
    name: String,
    studentId: [String],
    teacherId: String,
    homeworkId: [String]
  });
}).call(this);
