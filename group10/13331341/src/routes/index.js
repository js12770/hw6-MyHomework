var express, router, isAuthenticated;
express = require('express');
var User = require('../models/user');
var Homework = require('../models/homework');
var _ = require('underscore');
var Newhomework = require('../models/newhomework');
var Homework = require('../models/homework');
router = express.Router();
var fs = require('fs');
var path = require('path');

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

  router.get('/add', function(req, res) {
    res.render('add', {
      user: req.user,
      newhomework: {
        lesson: '',
        name: '',
        teacher: '',
        requirement: '',
        deadline: '',
        flag: 'able',
        submit: 0
      }
    });
  });
  router.get('/add/modify/:id', function(req, res) {
    var id = req.params.id;
    if (id) {
      Newhomework.findById(id, function(err, newhomework) {
        res.render('add', {
          user: req.user,
          newhomework: newhomework
        });
      });
    }
  });
  router.post('/add/new', function(req, res) {
    var id = req.body.newhomework._id;
    var newhomeworkObj = req.body.newhomework;
    var _newhomework;
    if (id !== 'undefined') {
      Newhomework.findById(id, function(err, newhomework) {
        if (err) {
          console.log(err);
        }
        _newhomework = _.extend(newhomework, newhomeworkObj);
        _newhomework.save(function(err, newhomework) {
          if (err) {
            console.log(err);
          }
          res.redirect('/home');
        });
      });
    } else {
      _newhomework = new Newhomework({
          lesson: newhomeworkObj.lesson,
          name: newhomeworkObj.name,
          teacher: newhomeworkObj.teacher,
          requirement: newhomeworkObj.requirement,
          deadline: newhomeworkObj.deadline,
          flag: 'able',
          submit: 0
      });
      _newhomework.save(function(err, newhomework) {
        if (err) {
          console.log(err);
        }
        res.redirect('/home');
      });
    }
  });

  router.get('/submit/homework/:id', function(req, res) {
    var id = req.params.id;
    if (id) {
      Newhomework.findById(id, function(err, newhomework) {
        res.render('homework', {
          user: req.user,
          newhomework: newhomework,
          homework: []
        });
      });
    }
  });

  router.post('/submit/homework/new', function(req, res) {
    _homework = new Homework({
        lesson: req.body.lesson,
        name: req.body.name,
        answer: req.body.answer,
    });
    _homework.save(function(err, homework) {
      if (err) {
        console.log(err);
      }
      res.redirect('/home');
    });
  });
  /*router.post('/add/new', function(req, res) {
    _newhomework = new Newhomework({
        lesson: req.body.lesson,
        name: req.body.name,
        teacher: req.body.teacher,
        requirement: req.body.requirement,
        content: req.body.content,
        deadline: req.body.deadline,
        flag: 'able',
        submit: 0
    });
    _newhomework.save(function(err, newhomework) {
      if (err) {
        console.log(err);
      }
      res.redirect('/home');
    });
  });*/

  router.get('/home', isAuthenticated, function(req, res){
    Newhomework.fetch(function(err, newhomeworks) {
      if (err) {
        console.log(err);
      }
      if (req.user.identity == 'Teacher') {
          res.render('teacher', {
            user: req.user,
            homework: newhomeworks
          });
      } else if (req.user.identity == 'Student') {
          res.render('student', {
            user: req.user,
            homework: newhomeworks
          });
      }
    });
  });
  return router.get('/signout', function(req, res){
    req.logout();
    res.redirect('/');
  });
};
