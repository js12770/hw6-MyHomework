(function(){
  var express, Assignment, StudentWork, router, isAuthenticated;
  express = require('express');
  Assignment = require('../models/assignment');
  StudentWork = require('../models/studentwork');
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
      Assignment.find(function(error, assignments){
        return res.render('home', {
          user: req.user,
          assignments: assignments
        });
      });
    });
    router.post('/add-asgn', isAuthenticated, function(req, res){
      Assignment.findOne({
        asgnname: req.param('asgnname')
      }, function(error, asgn){
        var newAsgn;
        if (!asgn) {
          newAsgn = new Assignment({
            asgnname: req.param('asgnname'),
            deadline: req.param('deadline'),
            requirement: req.param('requirement')
          });
          newAsgn.save();
        } else {
          Assignment.update({
            asgnname: req.param('asgnname')
          }, {
            $set: {
              requirement: req.param('requirement')
            }
          }, function(err, num, raw){
            return res.redirect('/home');
          });
        }
        return res.redirect('/home');
      });
    });
    router.post('/add-stuwork', isAuthenticated, function(req, res){
      StudentWork.findOne({
        asgnment: req.param('asgnment', {
          student: req.user.username
        })
      }, function(error, stuw){
        var newStuwork;
        if (!stuw) {
          newStuwork = new StudentWork({
            asgnment: req.param('asgnment'),
            student: req.user.username,
            content: req.param('content')
          });
          return newStuwork.save();
        } else {
          return StudentWork.updata({
            asgnment: req.param('asgnment', {
              student: req.user.username
            })
          }, {
            $set: {
              content: req.param('content')
            }
          }, function(err, num, raw){
            return res.redirect('/home');
          });
        }
      });
    });
    /*
    router.get '/details', is-authenticated, (req, res)!->
          if req.user.identity == 'teacher'
              Assignment.find {asgnname: 
    */
    return router.get('/signout', function(req, res){
      req.logout();
      res.redirect('/');
    });
  };
}).call(this);
