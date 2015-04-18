(function(){
  var mongoose;
  mongoose = require('mongoose');
  module.exports = mongoose.model('Homework', {
    id: Number,
    specTitle: String,
    author: String,
    content: String,
    version: Number,
    modifiedDate: Date,
    grades: Number
  });
}).call(this);
