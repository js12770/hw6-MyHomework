/**
 * Created by Kira on 4/10/15.
 */

var express = require('express');
var router = express.Router();
var StudentController = require('../controllers/studentController');

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

router.post('/upload', StudentController.uploadFile);

module.exports = router;