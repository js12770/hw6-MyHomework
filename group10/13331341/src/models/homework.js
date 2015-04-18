var mongoose = require('mongoose');
var HomeworkSchema = require('../schemas/newhomework');
var Homework = mongoose.model('Homework', HomeworkSchema);

module.exports = Homework;