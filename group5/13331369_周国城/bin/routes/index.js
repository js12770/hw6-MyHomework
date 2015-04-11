(function(){
  var express, course, homework, router, isAuthenticated;
  express = require('express');
  course = require('../models/course');
  homework = require('../models/homework');
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
      res.render('register_course', {
        user: req.user
      });
    });
    return router.get('/signout', function(req, res){
      req.logout();
      res.redirect('/');
    });
  };
  router.post('/controllers/course', function(req, res){
    res.render('public_homework', {
      user: req.user
    });
  });
}).call(this);
