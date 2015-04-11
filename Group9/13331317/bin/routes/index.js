(function(){
  var express, Requirement, Homework, router, isAuthenticated;
  express = require('express');
  Requirement = require('../models/requirement');
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
      res.render('home', {
        user: req.user
      });
    });
    router.get('/create', isAuthenticated, function(req, res){
      res.render('create', {
        user: req.user
      });
    });
    router.post('/create', function(req, res){
      var newRequirement;
      newRequirement = new Requirement({
        master: req.user.username,
        Head: req.param('Head'),
        ddl: req.param('ddl'),
        content: req.param('content')
      });
      newRequirement.save(function(error){
        if (error) {
          return console.log("Error in saving requirement: ", error);
        } else {
          return console.log("Requirement publish success");
        }
      });
      res.redirect('/home');
    });
    /* 提交作业 */
    router.get('/submit/:title', isAuthenticated, function(req, res){
      Requirement.findOne({
        Head: req.param('title')
      }, function(err, collection){
        return res.render('submit', {
          user: req.user,
          requirement: collection
        });
      });
    });
    router.post('/submit/:title', function(req, res){
      var newHomework;
      newHomework = new Homework({
        student: req.user.username,
        title: req.param('title'),
        answer: req.param('answer')
      });
      newHomework.save(function(error){
        if (error) {
          return console.log("Error in saving homework: ", error);
        } else {
          return console.log("Homework submit success");
        }
      });
      res.redirect('/home');
    });
    /* 修改作业要求 */
    router.get('/modify/:title', isAuthenticated, function(req, res){
      Requirement.findOne({
        Head: req.param('title')
      }, function(err, collection){
        return res.render('modify', {
          user: req.user,
          requirement: collection
        });
      });
    });
    router.post('/modify/:title', function(req, res){
      Requirement.update({
        Head: req.param('title')
      }, {
        $set: {
          content: req.param('content')
        }
      }, function(err, collection){
        return res.redirect('/home');
      });
    });
    /* 重复提交作业 */
    router.get('/update/:title', isAuthenticated, function(req, res){
      Homework.findOne({
        title: req.param('title')
      }, function(err, collection){
        return res.render('update', {
          user: req.user,
          homework: collection
        });
      });
    });
    router.post('/update/:title', function(req, res){
      Homework.update({
        title: req.param('title')
      }, {
        $set: {
          answer: req.param('answer')
        }
      }, function(err, collection){
        return res.redirect('/home');
      });
    });
    router.get('/viewrequirement', isAuthenticated, function(req, res){
      Requirement.find(function(err, collection){
        return res.render('viewrequirement', {
          user: req.user,
          collection: collection
        });
      });
    });
    router.get('/viewhomework', isAuthenticated, function(req, res){
      Homework.find(function(err, collection){
        return res.render('viewhomework', {
          user: req.user,
          collection: collection
        });
      });
    });
    return router.get('/signout', function(req, res){
      req.logout();
      res.redirect('/');
    });
  };
}).call(this);
