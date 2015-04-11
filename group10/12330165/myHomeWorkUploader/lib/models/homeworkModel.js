/**
 * Created by Kira on 4/11/15.
 */

var mongoose = require("mongoose");
var Schema = mongoose.Schema;

var homeworkSchema = new Schema({
    studentID: [String],
    title: String,
    content: String,
    deadline: String
});

mongoose.model('Homework', homeworkSchema);