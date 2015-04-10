/**
 * Created by Kira on 4/10/15.
 */

var mongoose = require("mongoose");
var Schema = mongoose.Schema;

var fileSchema = new Schema({
    fileName: String,
    fileRoute: String
});

var studentSchema = new Schema({
    studentID: String,
    password: String,
    name: String,
    sexprefer: String,
    group: Number,
    phonenumber: Number,
    email: String,
    file: [fileSchema]
});

mongoose.model('File', fileSchema);
mongoose.model('Student', studentSchema);