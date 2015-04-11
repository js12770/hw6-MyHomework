(function(){
  var Course, Homework, Content, express, homeworks, router, isAuthenticated, isStudent, isTeacher;
  Course = require('../models/courses');
  Homework = require('../models/homework');
  Content = require('../models/homeworkContent');
  express = require('express');
  homeworks = require('./homeworks');
  router = express.Router();
  isAuthenticated = function(req, res, next){
    if (req.isAuthenticated()) {
      return next();
    } else {
      return res.redirect('/');
    }
  };
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
  module.exports = router;
  router.get('/', isAuthenticated, function(req, res){
    var user, courses;
    user = req.user;
    if (user.character === 'teacher') {
      courses = Course.find({}).where('teacherId').equals(user._id).exec(function(err, courses){
        return res.render('courses', {
          user: req.user,
          courses: courses
        });
      });
    } else {
      courses = Course.find({}, function(err, courses){
        console.log(courses);
        return res.render('courses', {
          user: req.user,
          courses: courses
        });
      });
    }
  });
  router.get('/create', isAuthenticated, isTeacher, function(req, res){
    res.render('createCourse', {
      user: req.user
    });
  });
  router.post('/create', isAuthenticated, isTeacher, function(req, res){
    var user, course, newCourse;
    user = req.user;
    course = Course.findOne({
      name: req.param.name
    });
    if (!course) {
      res.write('This course has existed!');
      return res.end();
    } else {
      newCourse = new Course({
        name: req.param('name'),
        studentId: [],
        teacherId: user._id,
        homeworkId: []
      });
      return newCourse.save(function(err){
        if (err) {
          console.log('Create a course failed: ', err);
          return res.write("Failed to create a course: " + err);
        } else {
          console.log('Create a course successed!');
          return res.redirect('/courses');
        }
      });
    }
  });
  router.get('/:id', isAuthenticated, function(req, res){
    console.log(req.params.id);
    Course.findOne({
      _id: req.params.id
    }, function(err, course){
      if (err) {
        return res.write('404 not found!');
      } else {
        console.log('hehe');
        return res.render('courseDetail', {
          course: course
        });
      }
    });
  });
  router.get('/:id/edit', isAuthenticated, isTeacher, function(req, res){
    var course;
    course = Course.findOne({
      id: req.params.id
    });
    if (!course) {
      res.write('404 not found!');
      res.end();
    } else {
      res.render('editCourse', {
        course: course,
        user: req.user
      });
    }
  });
  router.post('/:id/edit', isAuthenticated, isTeacher, function(req, res){
    var course;
    course = Course.findOne({
      id: req.params.id
    });
    if (!course) {
      res.write('This course is not exist!');
      res.end();
    } else {
      course.name = req.param('name');
      course.save();
      res.redirect('../');
    }
  });
  router.get('/:id/delete', isAuthenticated, isTeacher, function(req, res){
    Course.remove({
      id: req.param.id
    }, function(err){
      if (err) {
        res.write('Failed to remove');
        res.end();
      } else {
        console.log('Successed to remove a course!');
        res.redirect('.../');
      }
    });
  });
}).call(this);
