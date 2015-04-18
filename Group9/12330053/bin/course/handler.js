var Course = require('../models/course');
var User = require('../models/user');
var Upload = require('../models/upload');

module.exports = function(req,res){
        this.upload = function(req, res) {
            // Display the Login page with any flash message, if any
            console.log(req.query.id);
            User.findOne({"_id":req.query.id}).exec(function(err,doc){
                Course.find().exec(function(err,docs){
                    console.log(doc);
                    res.render('upload', {
                        courses:docs,
                        schoolId:doc.schoolId,
                        student:doc.username
                    });
                });
            });
        }
}