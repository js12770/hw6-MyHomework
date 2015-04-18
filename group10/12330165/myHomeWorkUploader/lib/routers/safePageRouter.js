/**
 * Created by Kira on 4/10/15.
 */

var express = require('express');
var router = express.Router();
var StudentController = require('../controllers/studentController');


router.post('/register', StudentController.rPostNewStudent);

module.exports = router;