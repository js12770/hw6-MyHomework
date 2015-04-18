/**
 * Created by Kira on 4/10/15.
 */

var mongoose = require("mongoose");
var Schema = mongoose.Schema;

var fileSchema = new Schema({
    title: String,
    time: String,
    path: String
});

var studentSchema = new Schema({
    studentID: String,
    password: String,
    name: String,
    sexprefer: String,
    group: Number,
    phonenumber: Number,
    email: String,
    file: [fileSchema],
    privilege: Number
});

mongoose.model('File', fileSchema);
var Student = mongoose.model('Student', studentSchema);

var teacher = new Student({
    studentID: "teacher",
    password: "teacher",
    name: "我是老师",
    sexprefer: "女",
    group: 0,
    phonenumber: 15521377400,
    email: "woshilaoshi@qq.com",
    privilege: 1
});

Student.findOne({studentID: "teacher"}, function(err, data) {
    if (err) console.log(err);
    else if (data) {
        console.log("老师数据已存在");
    }
    else {
        teacher.save(function(err) {
            if (err) console.log(err);
            else console.log("老师数据已初始化");
        });
    }
});
