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
    course_id = req.param('course');
    Course.findOne({
      _id: course_id
    }, function(err, course){
      var homeworks;
      console.log(course);
      homeworks = Homework.find({}).where("_id")['in'](course.homeworkId).exec(function(err, homeworks){
        console.log(homeworks);
        res.render('homeworkList', {
          homeworks: homeworks,
          user: req.user
        });
      });
    });
  });
  router.get('/:homeworkId', isAuthenticated, function(req, res){
    var user, homework;
    user = req.user;
    homework = Homework.findOne({
      id: homeworkId
    });
    res.render('homeworkDetail', {
      homework: homework,
      user: user
    });
  });
  router.get('/create', isAuthenticated, isTeacher, function(req, res){
    return render('createHomework');
  });
  router.get('/create', isAuthenticated, isTeacher, function(req, res){
    return Homework.findOne({
      name: req.params.name
    }, function(err, homework){
      var newHomework;
      if (homework) {
        res.write("This homework has existed!");
      } else {
        newHomework = new Homework({
          name: req.params.name,
          content: req.params.content
        });
      }
    });
  });
  router.get('/:homeworkId/edit', isAuthenticated, isTeacher, function(req, res){
    if (!homework) {
      res.write('The homework doesn'.t(exist()['res.end!elseres.render '].editHomework[', homework:homework, user:userrouter.get "/:homeworkId/check", is-authenticated, is-teacher, (req, res)->contents = Content.find {homework-id:req.params.homework-id}res.render '].homeworkContentList[', contents:contentsrouter.get "/:homeworkId/enscore", is-authenticated, is-teacher, (req, res)->content = Content.find-one {id: req.params.content-id}res.render '].enscoreHomework[', content:contentrouter.post "/:homeworkId/enscore", is-authenticated, is-teacher, (req, res)->content = Content.find-one {id: req.params.homework-id}router.post "/:homeworkId/edit", is-authenticated, is-teacher, (req, res)->homework = Homework.find-one {id: homeworkId}if not homeworkres.write '].The(homework(doesn['t exist!']))));
      return res.end();
    } else {
      homework.deadline = req.param('deadline');
      homework.instruction = req.param('instruction');
      homework.name = req.param('name');
      return homeworks.save();
    }
  });
  router.get('/:homeworkId/write', isAuthenticated, isStudent, function(req, res){
    var content, course;
    content = Content.findOne({
      writerId: req.user.id,
      homeworkId: req.params.homeworkId
    });
    course = Course.findOne({
      id: req.params.id
    });
    if (!content) {
      content = new Content({
        courseId: req.params.id,
        homeworkId: req.params.homeworkId,
        content: '',
        writerId: 'req.user.id'
      });
      content.save();
    }
    return res.render('writeHomework', {
      user: user != null
        ? user
        : req.user,
      courseName: courseName != null
        ? courseName
        : course.name,
      content: content != null ? content : content
    });
  });
  router.post('/:homeworkId/write', isAuthenticated, isStudent, function(req, res){
    var content;
    content = Content.findOne({
      writerId: req.user.id,
      homeworkId: req.params.homeworkId
    });
    if (!content) {
      res.write('Error');
      return res.end();
    } else {
      content.content = req.params('content');
      return content.save();
    }
  });
}).call(this);
