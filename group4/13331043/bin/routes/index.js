(function(){
  var express, Assignment, Homework, fs, router, isAuthenticated;
  express = require('express');
  Assignment = require('../models/assignment');
  Homework = require('../models/homework');
  fs = require('fs');
  router = express.Router();
  isAuthenticated = function(req, res, next){
    if (req.isAuthenticated()) {
      return next();
    } else {
      return res.redirect("/");
    }
  };
  module.exports = function(passport){
    router.get("/", function(req, res){
      res.render("index", {
        message: req.flash("message")
      });
    });
    router.post("/login", passport.authenticate("login", {
      successRedirect: "/home",
      failureRedirect: "/",
      failureFlash: true
    }));
    router.get("/signup", function(req, res){
      res.render("register", {
        message: req.flash("message")
      });
    });
    router.post("/signup", passport.authenticate("signup", {
      successRedirect: "/home",
      failureRedirect: "/signup",
      failureFlash: true
    }));
    router.get("/home", isAuthenticated, function(req, res){
      res.render("home", {
        user: req.user
      });
    });
    router.get("/signout", function(req, res){
      req.logout();
      res.redirect("/");
    });
    router.get("/assign", isAuthenticated, function(req, res){
      res.render("assign", {
        user: req.user
      });
    });
    router.post("/assign", isAuthenticated, function(req, res){
      var newAssignment;
      newAssignment = new Assignment();
      newAssignment.title = req.param("title");
      newAssignment.description = req.param("description");
      newAssignment.deadline = new Date(req.param("deadline").replace("T", " ")).valueOf();
      newAssignment.teacherId = req.user._id;
      newAssignment.save(function(err){
        if (err) {
          return console.log("保存作业时出错啦: ", err);
        } else {
          return Assignment.findById(newAssignment, function(err, doc){
            if (err) {
              console.log("跳转到作业页面出错！");
            } else {
              res.redirect("/assignments/" + doc._id);
            }
          });
        }
      });
    });
    router.get("/assignments", isAuthenticated, function(req, res){
      if (req.user.identity === "1") {
        Assignment.find(function(err, allAssignments){
          if (err) {
            console.log("查询所有作业有误！");
          }
          res.render("manyAss", {
            assignments: allAssignments,
            user: req.user
          });
        });
      } else {
        Assignment.find({
          teacherId: req.user._id
        }, function(err, thisTeacherAssignments){
          if (err) {
            console.log("查询该老师发布的作业有误");
          }
          res.render("manyAss", {
            assignments: thisTeacherAssignments,
            user: req.user
          });
        });
      }
    });
    router.get("/assignments/:id/:hwid?", isAuthenticated, function(req, res){
      var assignmentId;
      if (!req.params.hwid) {
        assignmentId = req.params.id;
        Assignment.findById(assignmentId, function(err, doc){
          if (err) {
            console.log("找不到这个id的作业");
          } else {
            Homework.find({
              assignmentId: assignmentId
            }, function(err, allHomeworks){
              var outOfDate;
              if (err) {
                console.log("拿所有作业时错误");
              }
              outOfDate = doc.deadline <= Date.now() ? true : false;
              res.render("singleAss", {
                assignment: doc,
                homeworks: allHomeworks,
                user: req.user,
                outOfDate: outOfDate
              });
            });
          }
        });
      } else {
        Homework.findOne({
          _id: req.params.hwid
        }, function(err, doc){
          if (err) {
            console.log("拿出作业时错误");
          }
          res.render("homework", {
            homework: doc,
            user: req.user
          });
        });
      }
    });
    router.post("/post", isAuthenticated, function(req, res){
      Homework.findOne({
        assignmentId: req.param("assignment_id"),
        studentId: req.user._id
      }, function(err, doc){
        var newHomework;
        if (doc) {
          Homework.update({
            _id: doc._id
          }, {
            $set: {
              text: req.param("hw"),
              postTime: Date.now(),
              grade: -1
            }
          }, function(err){
            if (err) {
              console.log("更新作业时发生错误");
            } else {
              res.redirect("/assignments/" + doc.assignmentId + "/" + doc._id);
            }
          });
        } else {
          newHomework = new Homework();
          newHomework.assignmentId = req.param("assignment_id");
          newHomework.assignmentTitle = req.param("assignment_title");
          newHomework.studentId = req.user._id;
          newHomework.studentName = req.user.lastName + req.user.firstName;
          newHomework.text = req.param("hw");
          newHomework.save(function(err){
            if (err) {
              return console.log("保存作业时出错");
            } else {
              return Homework.findById(newHomework, function(err, thisHomework){
                res.redirect("/assignments/" + thisHomework.assignmentId + "/" + thisHomework._id);
              });
            }
          });
        }
      });
    });
    router.post("/grade", isAuthenticated, function(req, res){
      Homework.update({
        _id: req.param("homework_id")
      }, {
        $set: {
          grade: req.param("grade")
        }
      }, function(err){
        if (err) {
          console.log("err", err);
        }
        return Homework.findById(req.param("homework_id"), function(err, doc){
          if (err) {
            console.log(err);
          } else {
            res.redirect("/assignments" + "/" + doc.assignmentId + "/" + doc._id);
          }
        });
      });
    });
    return router.post("/modify", isAuthenticated, function(req, res){
      if (req.param("change_description")) {
        Assignment.update({
          _id: req.param("assignment_id")
        }, {
          $set: {
            description: req.param("change_description")
          }
        }, function(err){
          if (err) {
            console.log(err);
          }
        });
      }
      if (req.param("deadline")) {
        Assignment.update({
          _id: req.param("assignment_id")
        }, {
          $set: {
            deadline: new Date(req.param("deadline").replace("T", " ")).valueOf()
          }
        }, function(err){
          if (err) {
            console.log(err);
          }
        });
      }
      Assignment.findById(req.param("assignment_id"), function(err, doc){
        if (err) {
          console.log(err);
        } else {
          res.redirect("/assignments" + "/" + doc._id);
        }
      });
    });
  };
}).call(this);
