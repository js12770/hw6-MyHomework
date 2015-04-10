/**
 * Created by Kira on 4/10/15.
 */

var mongoose = require('mongoose');
var Student = mongoose.model('Student');
var fs = require('fs');
var formidable = require('formidable');
var File = mongoose.model('File');

exports.rGetAllStudents = function(req, res) {
    if (!req.session.user) {
        var responseData = {
            type: 0
        }
        res.send(JSON.stringify(responseData));
    } else {
        Student.find({}, function (err, students) {
            if (err) console.log(err)
            else res.send(JSON.stringify(students));
        });
    }
}

exports.rPostNewStudent = function(req, res) {
    var student = new Student({
        studentID: req.body.studentID,
        password: req.body.password,
        name: req.body.name,
        sexprefer: req.body.sexprefer,
        group: req.body.group,
        phonenumber: req.body.phonenumber,
        email: req.body.email
    });

    student.save(function(err) {
        var responseData = {
            type: 0,
            message: ""
        }
        if (err) {
            console.log(err);
            responseData.message = "服务器出现错误！";
            res.send(JSON.stringify(responseData));
        } else {
            responseData.type = 1;
            responseData.message = "注册成功";
            res.send(JSON.stringify(responseData));
        }
    })
}

exports.rCheckUser = function(req, res) {
    var responseData = {
        type : 0,
        message : ""
    }
    Student.findOne({studentID: req.body.studentID, password: req.body.password}, function(err, student) {
        if (err) {
            console.log(err);
            responseData.message = "服务器出现错误！";
            res.send(JSON.stringify(responseData));
        } else if (!student) {
            responseData.message = "不存在这个学号或者密码错误";
            res.send(JSON.stringify(responseData));
        } else {
            req.session.user = student;
            responseData.type = 1;
            responseData.message = "登陆成功!";
            res.send(JSON.stringify(responseData));
        }
    });
}

exports.rLogout = function(req, res) {
    var responseData = {
        type : 1,
        message : "登出成功!"
    }
    req.session = null;
    res.send(JSON.stringify(responseData));
}

exports.uploadFile = function(req, res) {
    var form = new formidable.IncomingForm();
    form.uploadDir = 'lib/tmp';
    form.parse(req, function(err, data, file) {
        if (err) console.log(err);
        file = file.file;
        var tmp_path = file.path;
        var time = new Date().getTime();
        console.log(file);
        data.filename = time + '.' + file.name.split('.').pop();
        var database_path = 'files/';
        var new_path = 'app/' + database_path;
        setTimeout(function() {
            var new_name = new_path + data.filename;
            var database_name = database_path + data.filename;
            fs.renameSync(tmp_path, new_name);
            Student.findOne({studentID: req.session.user.studentID}, function(err, student) {
                var file = new File({
                    fileName : database_name,
                    fileRoute : database_path
                });
                var responseData = {
                    type : 0,
                    message : ""
                }
                student.file.push(file);
                student.save(function(err) {
                    if (err) {
                        console.log(err);
                        responseData.message = "服务器出现错误！";
                        res.send(JSON.stringify(responseData));
                    } else {
                        responseData.type = 1;
                        responseData.message = "上传成功";
                        res.send(JSON.stringify(responseData));
                    }
                });
            });
        }, 500);
    });
}

