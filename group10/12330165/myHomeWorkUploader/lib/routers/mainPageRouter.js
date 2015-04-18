/**
 * Created by Kira on 4/10/15.
 */

var express = require('express');
var router = express.Router();
var StudentController = require('../controllers/studentController');
var HomeworkController = require('../controllers/homeworkController');

router.get('/getAllStudents', StudentController.rGetAllStudents);


router.post('/checkIfUploaded', StudentController.rCheckIfUploaded);

router.get('/allhomeworkInfo', HomeworkController.rGetAllHomework);

router.post('/homework', HomeworkController.rPostNewHomework);

router.post('/upload', StudentController.uploadFile);

module.exports = router;