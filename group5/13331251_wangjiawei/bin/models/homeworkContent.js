(function(){
  var mongoose;
  mongoose = require('mongoose');
  module.exports = mongoose.model('Content', {
    id: String,
    courseId: String,
    homeworkId: String,
    content: String,
    writerId: String
  });
}).call(this);
