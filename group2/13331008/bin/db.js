(function(){
  var $, mongoose;
  $ = require('./public/scripts/jquery.min');
  mongoose = require('mongoose');
  module.exports = {
    url: 'mongodb://localhost/my-homework',
    publish: function(homeworkInputInfo, publisher){
      var db, HomeworkPublish, HomeworkPublishOption, newHomeworkPublish;
      console.log('here is db-publish');
      db = mongoose.connection;
      HomeworkPublish = mongoose.model('HomeworkPublish');
      HomeworkPublishOption = {
        title: homeworkInputInfo.title,
        description: homeworkInputInfo.description,
        deadline: homeworkInputInfo.deadline,
        publisher: publisher
      };
      newHomeworkPublish = new HomeworkPublish(HomeworkPublishOption);
      newHomeworkPublish.save(function(err, newHomeworkPublish){
        if (err) {
          console.log(err);
        } else {
          console.log('save success');
        }
      });
    },
    showHomeworkPublish: function(req, res){
      var db, HomeworkPublish;
      db = mongoose.connection;
      HomeworkPublish = mongoose.model('HomeworkPublish');
      HomeworkPublish.find(function(error, homeworkPublishList){
        console.log('db-show-error-before-------------------');
        if (error) {
          console.log(error);
        }
        console.log('db-show-error-after-------------------');
        console.log(homeworkPublishList);
        console.log('db-show-list-after---------------------');
        res.render('home', {
          user: req.user,
          homeworkPublishList: homeworkPublishList
        });
      });
    },
    showHomeworkSubmit: function(req, res){
      var db, HomeworkSubmit;
      db = mongoose.connection;
      HomeworkSubmit = mongoose.model('HomeworkSubmit');
      HomeworkSubmit.find(function(error, homeworkSubmitList){
        console.log('db-show-submit-error-before-------------------');
        if (error) {
          console.log(error);
        }
        console.log('db-show-submit-error-after-------------------');
        console.log(homeworkSubmitList);
        console.log('db-show-submit-list-after---------------------');
        res.render('submitlist', {
          user: req.user,
          homeworkSubmitList: homeworkSubmitList
        });
      });
    },
    modify: function(homeworkInputInfo){
      var db, HomeworkPublish, HomeworkPublishOption, err;
      console.log('here is db-modify-------------------');
      db = mongoose.connection;
      HomeworkPublish = mongoose.model('HomeworkPublish');
      HomeworkPublishOption = {
        $set: {
          title: homeworkInputInfo.title,
          description: homeworkInputInfo.description,
          deadline: homeworkInputInfo.deadline
        }
      };
      console.log(homeworkInputInfo.modify);
      console.log('here is db-modify-after-option-----------');
      try {
        HomeworkPublish.update({
          title: homeworkInputInfo.modify
        }, HomeworkPublishOption, function(err, modifyHomeworkPublish){
          console.log('here is modify callback---------------------------');
          if (err) {
            console.log(err);
            console.log('here is modify callback-after--------------------');
          } else {
            console.log('modify success');
          }
        });
      } catch (e$) {
        err = e$;
        console.log('modify-err----------');
        console.log(err);
      }
    },
    submit: function(homeworkSubmitInfo, submitter){
      var db, HomeworkSubmit;
      console.log('here is db-submit');
      db = mongoose.connection;
      HomeworkSubmit = mongoose.model('HomeworkSubmit');
      HomeworkSubmit.findOneAndRemove({
        belongTo: homeworkSubmitInfo.belongTo,
        submitter: submitter
      }, function(error, homeworkSubmitList){
        var HomeworkSubmitOption, newHomeworkSubmit;
        console.log('here s db-remove-callback');
        HomeworkSubmitOption = {
          title: homeworkSubmitInfo.title,
          content: homeworkSubmitInfo.content,
          belongTo: homeworkSubmitInfo.belongTo,
          submitter: submitter
        };
        newHomeworkSubmit = new HomeworkSubmit(HomeworkSubmitOption);
        newHomeworkSubmit.save(function(err, newHomeworkSubmit){
          if (err) {
            console.log(err);
          } else {
            console.log('submit-homework save success');
          }
        });
      });
    }
  };
}).call(this);
