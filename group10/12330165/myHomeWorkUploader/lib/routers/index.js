var express = require('express');
var router = express.Router();
var mainPageRouter = require('./mainPageRouter');
var safePageRouter = require('./safePageRouter');
var StudentController = require('../controllers/studentController');

router.get('/', function(req, res) {
   res.redirect('/login');
});

router.get('/login', function(req, res) {
   res.render('login');
});

router.post('/login', StudentController.rCheckUser);
router.post('/logout', StudentController.rLogout);

router.use('/main', mainPageRouter);

router.use('/safe', safePageRouter);

module.exports = router;
