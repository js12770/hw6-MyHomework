var express = require('express');
var router = express.Router();
var mainPageRouter = require('./mainPageRouter');
var safePageRouter = require('./safePageRouter');
var StudentController = require('../controllers/studentController');

router.post('/login', StudentController.rCheckUser);

router.post('/logout', StudentController.rLogout);

router.get('/', function(req, res) {
    res.render('index');
});

router.use('/main', mainPageRouter);
router.use('/safe', safePageRouter);

module.exports = router;
