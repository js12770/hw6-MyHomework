(function(){
  var express, router, isAuthenticated;
  express = require('express');
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
    return router.get('/signout', function(req, res){
      req.logout();
      res.redirect('/');
    });
  };
}).call(this);
