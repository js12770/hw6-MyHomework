/**
 * Created by Kira on 4/11/15.
 */

var mongoose = require('mongoose');
var Homework = mongoose.model('Homework');

exports.rPostNewHomework = function(req, res) {
    var homework = new Homework({
        title: req.body.title,
        deadline: req.body.deadline,
        content: req.body.content
    });
    homework.save(function(err) {
        var responseData = {
            type: 0,
            message: ""
        }
        if (err) {
            console.log (err);
            responseData.message = "系统出错！";
            res.send(JSON.stringify(responseData));
        } else {
            responseData.type = 1;
            responseData.message = "成功发布！";
            res.send(JSON.stringify(responseData));
        }
    });
}

exports.rPostHomework = function(title, studentID, res) {
    Homework.findOne({title: title}, function(err, homework) {
        homework.studentID.push(studentID);
        homework.save(function(err) {
            if (err) console.log(err);
        });
    });
}

exports.rGetAllHomework = function(req, res) {
    Homework.find({}, function(err, homeworks) {
        var responseData = {
            type: 0,
            message: "",
            data: []
        }
        if (err) {
            console.log(err);
            responseData.message = "系统出错！";
            res.send(JSON.stringify(responseData));
        } else {
            responseData.type = 1;
            responseData.data = homeworks;
            res.send(JSON.stringify(responseData));
        }
    });
}