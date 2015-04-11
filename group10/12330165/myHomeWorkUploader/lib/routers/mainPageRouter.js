/**
 * Created by Kira on 4/10/15.
 */

var express = require('express');
var router = express.Router();
var StudentController = require('../controllers/studentController');
var HomeworkController = require('../controllers/homeworkController');

router.get('/', function(req, res) {
    res.render('index');
});

router.get('/students', function(req, res) {
    res.render('studentList');
});

router.get('/getAllStudents', StudentController.rGetAllStudents);

router.get('/upload', function(req, res) {
    res.render('uploader');
});

router.get('/allhomework', function(req, res) {
    res.render('allhomework');
});

router.get('/status', function(req, res) {
    res.render('status');
});

router.get('/submitHW', function(req, res) {
    res.render('submitHW');
});

router.get('/homework', function(req, res) {
    res.render('homework');
});

router.post('/checkIfUploaded', StudentController.rCheckIfUploaded);

router.get('/allhomeworkInfo', HomeworkController.rGetAllHomework);

router.post('/homework', HomeworkController.rPostNewHomework);

router.post('/upload', StudentController.uploadFile);

module.exports = router;