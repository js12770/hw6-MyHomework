(function(){
  var mongoose;
  mongoose = require('mongoose');
  module.exports = mongoose.model('Content', {
    id: String,
    homeworkId: String,
    content: String,
    writerId: String,
    score: String
  });
}).call(this);
