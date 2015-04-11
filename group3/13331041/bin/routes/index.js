(function(){
  var express, Homework, HW, router, isAuthenticated;
  express = require('express');
  Homework = require('../models/homework');
  HW = require('../models/hw');
  router = express.Router();
  isAuthenticated = function(req, res, next){
    if (req.isAuthenticated()) {
      return next();
    } else {
      return res.redirect('/');
    }
  };
  module.exports = function(passport){
    router.get('/', function(req, res){
      res.render('index', {
        message: req.flash('message')
      });
    });
    router.get('/student', isAuthenticated, function(req, res){
      res.render('student', {
        user: req.user
      });
    });
    router.post('/login', passport.authenticate('login', {
      successRedirect: '/home',
      failureRedirect: '/',
      failureFlash: true
    }));
    router.get('/teacher', isAuthenticated, function(req, res){
      res.render('teacher', {
        user: req.user
      });
    });
    router.get('/student', isAuthenticated, function(req, res){
      res.render('teacher', {
        user: req.user
      });
    });
    router.get('/profile', isAuthenticated, function(req, res){
      res.render('profile', {
        user: req.user
      });
    });
    router.get('/create', isAuthenticated, function(req, res){
      res.render('create', {
        user: req.user
      });
    });
    router.get('/signup', function(req, res){
      res.render('register', {
        message: req.flash('message')
      });
    });
    router.post('/signup', passport.authenticate('signup', {
      successRedirect: '/home',
      failureRedirect: '/signup',
      failureFlash: true
    }));
    router.get('/home', isAuthenticated, function(req, res){
      res.render('home', {
        user: req.user
      });
    });
    router.get('/signout', function(req, res){
      req.logout();
      res.redirect('/');
    });
    router.post('/create', isAuthenticated, function(req, res){
      var newHomework;
      newHomework = new Homework({
        deadline: req.param('deadline'),
        homework: req.param('homework'),
        course: req.param('course'),
        detail: req.param('detail'),
        author: req.param('author')
      });
      newHomework.save(function(error){
        if (error) {
          console.log("Error in saving user: ", error);
          throw error;
        } else {
          console.log("User registration success");
          return res.redirect('/home');
        }
      });
    });
    router.get('/homework', isAuthenticated, function(req, res){
      var value, hw;
      value = req.query;
      hw = value['id'];
      Homework.findOne({
        _id: hw
      }, function(err, result){
        return res.render('change', {
          user: req.user,
          homework: result
        });
      });
    });
    router.get('/submit', isAuthenticated, function(req, res){
      var value, hw;
      value = req.query;
      hw = value['id'];
      Homework.findOne({
        homework: hw
      }, function(err, result){
        return res.render('submit', {
          user: req.user,
          homework: result
        });
      });
    });
    router.post('/homework', isAuthenticated, function(req, res){
      Homework.findOneAndUpdate({
        homework: req.param('homework')
      }, {
        $set: {
          deadline: req.param('deadline')
        }
      });
      Homework.findOneAndUpdate({
        homework: req.param('homework')
      }, {
        $set: {
          detail: req.param('detail')
        }
      });
      res.redirect('/history');
    });
    router.get('/history', isAuthenticated, function(req, res){
      var history, year, month, day, date;
      history = new Date();
      year = history.getFullYear();
      month = history.getMonth() + 1;
      if (month < 10) {
        month = '0' + month.toString();
      }
      day = history.getDate();
      if (day < 10) {
        day = '0' + day.toString();
      }
      date = year + '-' + month + '-' + day;
      Homework.find(function(err, result){
        return res.render('history', {
          user: req.user,
          homework: result,
          date: date
        });
      });
    });
    router.post('/submit', isAuthenticated, function(req, res){
      var newHomework;
      newHomework = new HW({
        deadline: req.param('deadline'),
        homework: req.param('homework'),
        course: req.param('course'),
        detail: req.param('detail'),
        student: req.param('student'),
        content: req.param('content'),
        grade: 0
      });
      newHomework.save(function(error){
        if (error) {
          console.log("Error in saving user: ", error);
          throw error;
        } else {
          console.log("User registration success");
          return res.redirect('/home');
        }
      });
    });
    router.get('/stu_homework', isAuthenticated, function(req, res){
      HW.find(function(err, result){
        return res.render('hw', {
          user: req.user,
          homework: result
        });
      });
    });
    router.get('/my_homework', isAuthenticated, function(req, res){
      var history, year, month, day, date;
      history = new Date();
      year = history.getFullYear();
      month = history.getMonth() + 1;
      if (month < 10) {
        month = '0' + month.toString();
      }
      day = history.getDate();
      if (day < 10) {
        day = '0' + day.toString();
      }
      date = year + '-' + month + '-' + day;
      HW.find({
        student: req.user.username
      }, function(err, result){
        return res.render('hw', {
          user: req.user,
          homework: result,
          date: date
        });
      });
    });
    router.get('/change', isAuthenticated, function(req, res){
      var value, hw;
      value = req.query;
      hw = value['id'];
      HW.findOne({
        _id: hw
      }, function(err, result){
        return res.render('homework', {
          user: req.user,
          homework: result
        });
      });
    });
    router.get('/outofdate', isAuthenticated, function(req, res){
      var value, hw;
      value = req.query;
      hw = value['id'];
      HW.findOne({
        _id: hw
      }, function(err, result){
        return res.render('outofdate', {
          user: req.user,
          homework: result
        });
      });
    });
    router.post('/change', isAuthenticated, function(req, res){
      HW.findOneAndUpdate({
        _update: req.param('id')
      }, {
        $set: {
          content: req.param('content')
        }
      });
      res.redirect('/my_homework');
    });
    router.get('/view', isAuthenticated, function(req, res){
      var value, hw;
      value = req.query;
      hw = value['id'];
      HW.findOne({
        _id: hw
      }, function(err, result){
        return res.render('view', {
          user: req.user,
          homework: result
        });
      });
    });
    router.post('/view', isAuthenticated, function(req, res){
      HW.findOneAndUpdate({
        _id: req.param('id')
      }, {
        $set: {
          grade: req.param('grade')
        }
      });
      res.redirect('/stu_homework');
    });
    router.get('/resubmit', isAuthenticated, function(req, res){
      var history, year, month, day, date, value, hw;
      history = new Date();
      year = history.getFullYear();
      month = history.getMonth() + 1;
      if (month < 10) {
        month = '0' + month.toString();
      }
      day = history.getDate();
      if (day < 10) {
        day = '0' + day.toString();
      }
      date = year + '-' + month + '-' + day;
      value = req.query;
      hw = value['id'];
      HW.findOne({
        _id: hw
      }, function(err, result){
        return res.render('view', {
          user: req.user,
          homework: result,
          date: date
        });
      });
    });
    return router.post('/resubmit', isAuthenticated, function(req, res){
      HW.findOneAndUpdate({
        _id: req.param('id')
      }, {
        $set: {
          content: req.param('content')
        }
      });
      res.redirect('/my_homework');
    });
  };
}).call(this);
