(function(){
  var express, Course, Content, Homework, router, isStudent, isTeacher, isAuthenticated;
  express = require('express');
  Course = require('../models/courses');
  Content = require('../models/homeworkContent');
  Homework = require('../models/homework');
  router = express.Router();
  isStudent = function(req, res, next){
    if (req.user.character === 'student') {
      return next();
    } else {
      return res.write("You're not student!");
    }
  };
  isTeacher = function(req, res, next){
    if (req.user.character === 'teacher') {
      return next();
    } else {
      return res.write("you're not teacher!");
    }
  };
  isAuthenticated = function(req, res, next){
    if (req.isAuthenticated()) {
      return next();
    } else {
      return res.redirect('/');
    }
  };
  module.exports = router;
  router.get('/', isAuthenticated, function(req, res){
    var course_id;
    course_id = req.query.course;
    console.log(course_id);
    console.log('homework home');
    Course.findOne({
      _id: course_id
    }, function(err, course){
      var homeworks;
      console.log(course);
      homeworks = Homework.find({
        courseId: course._id
      }, function(err, homeworks){
        console.log(homeworks);
        res.render('homeworkList', {
          homeworks: homeworks,
          user: req.user,
          course: course
        });
      });
    });
  });
  router.get('/detail/:homeworkId', isAuthenticated, function(req, res){
    var user;
    user = req.user;
    console.log(user);
    Homework.findOne({
      _id: req.params.homeworkId
    }, function(err, homework){
      if (err) {
        console.log('Failed to find the homework');
      }
      if (user.character === 'teacher') {
        Content.find({
          homeworkId: homework._id
        }, function(err, contents){
          if (err) {
            console.log('No contents');
          }
          res.render('homeworkDetail', {
            contents: contents,
            user: user,
            homework: homework
          });
        });
      } else {
        console.log('homework is');
        console.log(homework._id);
        console.log(user._id);
        Content.findOne({
          homeworkId: homework._id,
          writerId: user._id
        }, function(err, content){
          res.render('homeworkDetail', {
            content: content,
            user: user,
            homework: homework
          });
        });
      }
    });
  });
  router.get('/create', isAuthenticated, isTeacher, function(req, res){
    var courseId;
    courseId = req.query.courseId;
    console.log(courseId);
    return res.render('createHomework', {
      courseId: courseId
    });
  });
  router.post('/create/:courseId', isAuthenticated, isTeacher, function(req, res){
    var courseId;
    courseId = req.param.courseId;
    return Homework.findOne({
      name: req.params.name
    }, function(err, homework){
      var newHomework;
      console.log(req.params.courseId + "...");
      if (homework) {
        res.write("This homework has existed!");
      } else {
        newHomework = new Homework({
          name: req.param('name'),
          deadline: req.param('deadline'),
          content: req.param('content'),
          courseId: req.params.courseId
        });
        newHomework.save();
        res.redirect('/courses');
      }
    });
  });
  router.get('/content/:contentId', isAuthenticated, isTeacher, function(req, res){
    return Content.findOne({
      _id: req.params.contentId
    }, function(err, content){
      if (!content) {
        res.write('The homework doesn\'t exist!');
        res.end();
      } else {
        res.render('homeworkContent', {
          content: content,
          user: req.user
        });
      }
    });
  });
  router.post("/enscore/:contentId", isAuthenticated, isTeacher, function(req, res){
    return Content.findOne({
      _id: req.params.contentId
    }, function(err, content){
      if (!content) {
        res.write('The homework doesn\'t exist!');
        res.end();
      } else {
        Homework.findOne({
          _id: content.homeworkId
        }, function(err, homework){
          var nowDate;
          if ((nowDate = new Date()) < homework.deadline) {
            res.write('It\' s not time to enscore!');
            res.end();
            return;
          }
          content.score = req.param('score');
          content.save();
          res.redirect('/home');
        });
      }
    });
  });
  router.get("/edit/:homeworkId", isAuthenticated, isTeacher, function(req, res){
    return Homework.findOne({
      _id: req.params.homeworkId
    }, function(err, homework){
      var nowDate;
      if (!homework) {
        res.write('The homework doesn\'t exist!');
        res.end();
      } else {
        nowDate = new Date();
        if (nowDate >= homework.deadline) {
          res.write('The deadline has passed!');
          res.end();
        } else {
          res.render('editHomework', {
            user: req.user,
            homework: homework
          });
        }
      }
    });
  });
  router.post("/edit/:homeworkId", isAuthenticated, isTeacher, function(req, res){
    return Homework.findOne({
      _id: req.params.homeworkId
    }, function(err, homework){
      if (!homework) {
        res.write('The homework doesn\'t exist!');
        res.end();
      } else {
        if (nowDate >= homework.deadline) {
          res.write('The deadline has passed!');
          res.end();
        } else {
          homework.deadline = req.param('deadline');
          homework.instruction = req.param('instruction');
          homework.name = req.param('name');
          homework.save();
          res.redirect('/home');
        }
      }
    });
  });
  router.get("/write/:contentId", isAuthenticated, isStudent, function(req, res){
    console.log(req.user);
    return Content.findOne({
      writerId: req.user._id,
      _id: req.params.contentId
    }, function(err, content){
      if (!content) {
        content = new Content({
          homeworkId: req.query.homework,
          content: '',
          writerId: req.user._id,
          score: 'unscored'
        });
        console.log('A new content');
        content.save();
      }
      Homework.findOne({
        _id: content.homeworkId
      }, function(err, homework){
        var nowDate;
        if ((nowDate = new Date()) >= homework.deadline) {
          res.write('The deadline has passed!');
          res.end();
          return;
        }
        Course.findOne({
          _id: homework.courseId
        }, function(err, course){
          res.render('writeHomework', {
            user: req.user,
            courseName: course.name,
            content: content
          });
        });
      });
    });
  });
  router.post('/write/:contentId', isAuthenticated, isStudent, function(req, res){
    var user;
    console.log(req.user);
    console.log('no');
    user = req.user;
    return Content.findOne({
      writerId: req.user._id,
      _id: req.params.contentId
    }, function(err, content){
      if (!content) {
        res.write('Error');
        res.end();
      } else {
        Homework.findOne({
          _id: content.homeworkId
        }, function(err, homework){
          var nowDate;
          if ((nowDate = new Date()) >= homework.deadline) {
            res.write('The deadline has passed!');
            res.end();
            return;
          }
          content.content = req.param('content');
          content.save();
          res.redirect('/home');
        });
      }
    });
  });
}).call(this);
