(function(){
  var mongoose;
  mongoose = require('mongoose');
  module.exports = mongoose.model('Homework', {
    id: String,
    courseId: String,
    name: String,
    instruction: String,
    studentHandedId: [String],
    deadline: Date,
    contentId: [String]
  });
}).call(this);
