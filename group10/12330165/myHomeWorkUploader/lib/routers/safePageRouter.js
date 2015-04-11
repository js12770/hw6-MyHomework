/**
 * Created by Kira on 4/10/15.
 */

var express = require('express');
var router = express.Router();
var StudentController = require('../controllers/studentController');

router.get('/', function(req, res) {
    res.render('safe');
});

router.get('/register', function(req, res) {
    res.render('register');
});

router.post('/register', StudentController.rPostNewStudent);

router.get('/returnPW', function(req, res) {
    res.render('returnPW');
});

module.exports = router;