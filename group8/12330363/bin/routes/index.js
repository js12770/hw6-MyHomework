(function(){
  var express, User, Specification, Homework, router, isAuthenticated, setUserFlag;
  express = require('express');
  User = require('../models/user');
  Specification = require('../models/specification');
  Homework = require('../models/homework');
  router = express.Router();
  isAuthenticated = function(req, res, next){
    if (req.isAuthenticated()) {
      return next();
    } else {
      return res.redirect('/');
    }
  };
  setUserFlag = function(req){
    if (10 === req.user.userType) {
      return true;
    } else {
      return false;
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
      var flag;
      flag = setUserFlag(req);
      res.render('home', {
        user: req.user,
        user_flag: flag
      });
    });
    router.get('/signout', function(req, res){
      req.logout();
      res.redirect('/');
    });
    router.get('/get_specification', isAuthenticated, function(req, res){
      Specification.find(function(err, specs){
        res.json(specs);
      });
    });
    router.get('/get_homework', isAuthenticated, function(req, res){
      var flag;
      flag = setUserFlag(req);
      Homework.find(!flag ? {
        'authorId': req.user.id
      } : null, function(err, hws){
        res.json(hws);
      });
    });
    router.post('/submit_homework', isAuthenticated, function(req, res){
      var newHomework;
      if (!setUserFlag(req)) {
        newHomework = new Homework({
          specTitle: req.body.title,
          version: 1,
          content: req.body.content,
          modifiedDate: new Date(),
          author: req.user.username
        });
        newHomework.save(function(error){
          if (error) {
            console.log('Error in saving homework', error);
            throw error;
          }
        });
      }
    });
    router.post('/post_specification', isAuthenticated, function(req, res){
      if (setUserFlag(req)) {
        Specification.findOne({
          title: req.body.title
        }, function(error, doc){
          var newSpecification;
          if (error) {
            throw error;
          } else if (!doc) {
            newSpecification = new Specification({
              title: req.body.title,
              version: 1,
              deadline: new Date(req.body.deadline),
              content: req.body.content,
              author: req.user.username
            });
            newSpecification.save(function(error){
              if (error) {
                console.log('Error in saving specification', error);
                throw error;
              }
            });
          } else {
            Specification.update({
              _id: doc._id
            }, {
              $set: {
                title: req.body.title,
                version: req.body.version + 1,
                deadline: req.body.deadline,
                content: req.body.content
              }
            });
          }
        });
      }
    });
    return router.post('/grade_homework', isAuthenticated, function(req, res){
      if (!setUserFlag(req)) {
        Homework.update({
          specTitle: req.body.title
        }, {
          grades: req.body.grades
        }, function(error){
          if (error) {
            throw error;
          }
        });
      }
    });
  };
}).call(this);
