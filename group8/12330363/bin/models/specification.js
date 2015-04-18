(function(){
  var mongoose;
  mongoose = require('mongoose');
  module.exports = mongoose.model('Specification', {
    id: Number,
    title: String,
    version: Number,
    deadline: Date,
    content: String,
    author: String,
    authorId: Number
  });
}).call(this);
