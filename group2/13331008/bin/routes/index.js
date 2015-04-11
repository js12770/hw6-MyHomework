(function(){
  var express, db, router, isAuthenticated;
  express = require('express');
  db = require('../db');
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
      var err;
      try {
        db.showHomeworkPublish(req, res);
      } catch (e$) {
        err = e$;
        console.log(err);
      }
    });
    router.get('/signout', function(req, res){
      req.logout();
      res.redirect('/');
    });
    router.get('/publish', isAuthenticated, function(req, res){
      console.log('test-modify---------------------');
      console.log(req.query.modify);
      if (req.query.modify) {
        res.render('publish', {
          user: req.user,
          modify: req.query.modify
        });
      } else {
        console.log('test-else---------------');
        res.render('publish', {
          user: req.user
        });
      }
    });
    router.post('/publish', function(req, res){
      var error, err;
      console.log('--------------------here-------------------------');
      console.log(req.body);
      console.log('--------------------here-------------------------');
      if (req.body.modify) {
        console.log('modify-branch--------------');
        try {
          db.modify(req.body);
        } catch (e$) {
          error = e$;
        }
      } else {
        try {
          db.publish(req.body, req.user.username);
        } catch (e$) {
          err = e$;
          console.log(err);
        }
      }
      res.redirect('/home');
    });
    router.get('/submitList', isAuthenticated, function(req, res){
      var err;
      try {
        db.showHomeworkSubmit(req, res);
      } catch (e$) {
        err = e$;
        console.log(err);
      }
    });
    router.get('/submit', isAuthenticated, function(req, res){
      console.log('in-get-submit-------------------');
      console.log(req.user);
      console.log(req.query.belongTo);
      res.render('submit', {
        user: req.user,
        belongTo: req.query.belongTo
      });
    });
    return router.post('/submit', isAuthenticated, function(req, res){
      var err;
      console.log('--------------------submit-------------------------');
      console.log(req.body);
      console.log('--------------------submit-------------------------');
      try {
        db.submit(req.body, req.user.username);
      } catch (e$) {
        err = e$;
        console.log(err);
      }
      res.redirect('/submitList');
    });
  };
}).call(this);
