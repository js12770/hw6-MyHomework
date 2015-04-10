(function(){
  var express, Homework, router, isAuthenticated;
  express = require('express');
  Homework = require('../models/homework');
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
    router.post('/login', passport.authenticate('login', {
      successRedirect: '/home',
      failureRedirect: '/',
      failureFlash: true
    }));
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
      Homework.find({
        forList: true
      }, function(err, homeworks){
        if (req.user.isTeacher) {
          return Homework.find({
            forList: false
          }, function(err, handedinhomeworks){
            return res.render('home', {
              user: req.user,
              homeworks: homeworks,
              handedinhomeworks: handedinhomeworks
            });
          });
        } else {
          return Homework.find({
            author: req.user.username
          }, function(err, handedinhomeworks){
            return res.render('home', {
              user: req.user,
              homeworks: homeworks,
              handedinhomeworks: handedinhomeworks
            });
          });
        }
      });
    });
    router.get('/signout', function(req, res){
      req.logout();
      res.redirect('/');
    });
    router.post('/createhomework', isAuthenticated, function(req, res){
      var msg;
      if (!req.user.isTeacher) {
        console.log(msg = "only teacher has permission to create homework");
        res.render('home', {
          user: req.user,
          message: msg
        });
      } else {
        Homework.count({}, function(err, count){
          var newHomework;
          newHomework = new Homework({
            id: count,
            content: req.param('content'),
            author: req.user.username,
            deadline: new Date(req.param('deadline')),
            forList: true
          });
          return newHomework.save(function(error){
            var msg;
            if (error) {
              console.log("Error in saving hw: ", error);
              throw error;
            } else {
              console.log(msg = "create successfully");
              return res.redirect('/home');
            }
          });
        });
      }
    });
    router.post('/changedeadline', isAuthenticated, function(req, res){
      var msg;
      if (!req.user.isTeacher) {
        console.log(msg = "only teacher has permission to change deadline");
        res.render('home', {
          user: req.user,
          message: msg
        });
      } else {
        Homework.findOne({
          id: req.param('id')
        }, function(err, homework){
          var msg;
          if (!homework) {
            console.log(msg = "invalid id");
            return res.render('home', {
              user: req.user,
              message: msg
            });
          } else {
            homework.deadline = new Date(req.param('deadline'));
            return homework.save(function(){
              res.redirect('/home');
            });
          }
        });
      }
    });
    router.post('/handinhomework', isAuthenticated, function(req, res){
      var msg;
      if (req.user.isTeacher) {
        console.log(msg = "only student has permission to hand in hw");
        return res.render('home', {
          user: req.user,
          message: msg
        });
      } else {
        return Homework.findOne({
          id: req.param('id')
        }, function(err, homework){
          var msg;
          if (!homework) {
            console.log(msg = "invalid id");
            return res.render('home', {
              user: req.user,
              message: msg
            });
          } else {
            if (homework.deadline > new Date()) {
              return Homework.count({}, function(err, count){
                var newHomework;
                newHomework = new Homework({
                  id: parseInt(req.param('id')) * -1,
                  content: req.param('content'),
                  author: req.user.username,
                  forList: false
                });
                return newHomework.save(function(error){
                  var msg;
                  if (error) {
                    console.log("Error in saving hw: ", error);
                    throw error;
                  } else {
                    console.log(msg = "create successfully");
                    return res.redirect('/home');
                  }
                });
              });
            } else {
              console.log(msg = "deadline passed");
              return res.render('home', {
                user: req.user,
                message: msg
              });
            }
          }
        });
      }
    });
    return router.post('/givescore', isAuthenticated, function(req, res){
      var msg;
      if (!req.user.isTeacher) {
        console.log(msg = "only teacher has permission to give a score");
        res.render('home', {
          user: req.user,
          message: msg
        });
      } else {
        Homework.findOne({
          id: parseInt(req.param('id')) * -1
        }, function(err, homework){
          var msg;
          if (homework.deadline < new Date()) {
            return Homework.findOne({
              id: req.param('id'),
              author: req.param('studentname')
            }, function(err, homework){
              var msg;
              if (!homework) {
                console.log(msg = "invalid id or student name");
                return res.render('home', {
                  user: req.user,
                  message: msg
                });
              } else {
                homework.score = parseInt(req.param('score'));
                return homework.save(function(){
                  res.redirect('/home');
                });
              }
            });
          } else {
            console.log(msg = "the deadline is sometime in the future");
            return res.render('home', {
              user: req.user,
              message: msg
            });
          }
        });
      }
    });
  };
}).call(this);
