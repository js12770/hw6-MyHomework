var mongodb = require('./db');
var markdown = require('markdown').markdown;

function Hw(stu_name, tc_name, title, requirement, post, score) {
  this.stu_name = stu_name;
  this.tc_name = tc_name;
  this.title = title;
  this.requirement = requirement;
  this.post = post;
  this.score = score;
}

module.exports = Hw;

//存储一份作业及其相关信息
Hw.prototype.save = function(callback) {
  var date = new Date();
  //存储各种时间格式，方便以后扩展
  var time = {
      date: date,
      year : date.getFullYear(),
      month : date.getFullYear() + "-" + (date.getMonth() + 1),
      day : date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate(),
      minute : date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate() + " " + 
      date.getHours() + ":" + (date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes()) 
  }
  //要存入数据库的文档
  var hw = {
      stu_name: this.stu_name,
      tc_name: this.tc_name,
      time: time,
      title: this.title,
      requirement: this.requirement,
      post: this.post,
      score: this.score
  };
  //打开数据库
  mongodb.open(function (err, db) {
    if (err) {
      return callback(err);
    }
    //读取 hws 集合
    db.collection('hws', function (err, collection) {
      if (err) {
        mongodb.close();
        return callback(err);
      }
      //将文档插入 hws 集合
      collection.insert(hw, {
        safe: true
      }, function (err) {
        mongodb.close();
        if (err) {
          return callback(err);//失败！返回 err
        }
        callback(null);//返回 err 为 null
      });
    });
  });
};

//读取作业及其相关信息
Hw.getAll = function(title, callback) {
  //打开数据库
  mongodb.open(function (err, db) {
    if (err) {
      return callback(err);
    }
    //读取 hws 集合
    db.collection('hws', function(err, collection) {
      if (err) {
        mongodb.close();
        return callback(err);
      }
      var query = {};
      if (title) {
        query.title = title;
      }
      //根据 query 对象查作业
      collection.find(query).sort({
        time: -1
      }).toArray(function (err, docs) {
        mongodb.close();
        if (err) {
          return callback(err);//失败！返回 err
        }
                //解析 markdown 为 html
        docs.forEach(function (doc) {
          doc.post = markdown.toHTML(doc.post);
        });
        callback(null, docs);//成功！以数组形式返回查询的结果
      });
    });
  });
};

// //获取一篇文章
// Post.getOne = function(name, day, title, callback) {
//   //打开数据库
//   mongodb.open(function (err, db) {
//     if (err) {
//       return callback(err);
//     }
//     //读取 posts 集合
//     db.collection('posts', function (err, collection) {
//       if (err) {
//         mongodb.close();
//         return callback(err);
//       }
//       //根据用户名、发表日期及文章名进行查询
//       collection.findOne({
//         "name": name,
//         "time.day": day,
//         "title": title
//       }, function (err, doc) {
//         mongodb.close();
//         if (err) {
//           return callback(err);
//         }
//         //解析 markdown 为 html
//         doc.post = markdown.toHTML(doc.post);
//         callback(null, doc);//返回查询的一篇文章
//       });
//     });
//   });
// };

// //返回原始发表的内容（markdown 格式）
// Post.edit = function(name, day, title, callback) {
//   //打开数据库
//   mongodb.open(function (err, db) {
//     if (err) {
//       return callback(err);
//     }
//     //读取 posts 集合
//     db.collection('posts', function (err, collection) {
//       if (err) {
//         mongodb.close();
//         return callback(err);
//       }
//       //根据用户名、发表日期及文章名进行查询
//       collection.findOne({
//         "name": name,
//         "time.day": day,
//         "title": title
//       }, function (err, doc) {
//         mongodb.close();
//         if (err) {
//           return callback(err);
//         }
//         callback(null, doc);//返回查询的一篇文章（markdown 格式）
//       });
//     });
//   });
// };

// //更新一篇文章及其相关信息
// Post.update = function(name, day, title, ddl, post, callback) {
//   //打开数据库
//   mongodb.open(function (err, db) {
//     if (err) {
//       return callback(err);
//     }
//     //读取 posts 集合
//     db.collection('posts', function (err, collection) {
//       if (err) {
//         mongodb.close();
//         return callback(err);
//       }
//       //更新文章内容
//       collection.update({
//         "name": name,
//         "time.day": day,
//         "title": title
//       }, {
//         $set: {ddl: ddl, post: post}
//       }, function (err) {
//         mongodb.close();
//         if (err) {
//           return callback(err);
//         }
//         callback(null);
//       });
//     });
//   });
// };

// //删除一篇文章
// Post.remove = function(name, day, title, callback) {
//   //打开数据库
//   mongodb.open(function (err, db) {
//     if (err) {
//       return callback(err);
//     }
//     //读取 posts 集合
//     db.collection('posts', function (err, collection) {
//       if (err) {
//         mongodb.close();
//         return callback(err);
//       }
//       //根据用户名、日期和标题查找并删除一篇文章
//       collection.remove({
//         "name": name,
//         "time.day": day,
//         "title": title
//       }, {
//         w: 1
//       }, function (err) {
//         mongodb.close();
//         if (err) {
//           return callback(err);
//         }
//         callback(null);
//       });
//     });
//   });
// };