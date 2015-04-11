var express = require('express');
var router = express.Router();
var crypto = require('crypto'),
    User = require('../models/user.js'),
    Post = require('../models/post.js'),
    Hw = require('../models/hw.js');

function checkLogin(req, res, next) {
  if (!req.session.user) {
    req.flash('error', '未登录!'); 
    res.redirect('/login');
  }
  next();
}

function checkNotLogin(req, res, next) {
  if (req.session.user) {
      req.flash('error', '已登录!'); 
      res.redirect('back');//返回之前的页面
  }
  next();
}

/* GET home page. */
router.get('/', function (req, res) {
  if (!req.session.user)
    return res.redirect('/login');
  Post.getAll(null, function (err, posts) {
    if (err) {
      posts = [];
    } 
    res.render('index', {
      title: '主页',
      user: req.session.user,
      posts: posts,
      success: req.flash('success').toString(),
      error: req.flash('error').toString()
    });
  });
});

router.get('/reg', checkNotLogin);  // 不是login状态才能去到/reg
router.get('/reg', function (req, res) {
  res.render('reg', {
    title: '注册',
    user: req.session.user,
    success: req.flash('success').toString(),
    error: req.flash('error').toString()
  });
});

router.post('/reg', checkNotLogin);
router.post('/reg', function (req, res) {
  var name = req.body.name,
      password = req.body.password,
      password_re = req.body['password-repeat'],
      type = req.body.type;
  //检验是否有输入东西
  if (name == '' || password == '' || password_re  == '') {
    req.flash('error', '存在没有输入的表单!'); 
    return res.redirect('/reg');//返回注册页
  }
  //检验用户两次输入的密码是否一致
  if (password_re != password) {
    req.flash('error', '两次输入的密码不一致!'); 
    return res.redirect('/reg');//返回注册页
  }
  //生成密码的 md5 值
  var md5 = crypto.createHash('md5'),
      password = md5.update(req.body.password).digest('hex');
  var newUser = new User({
      name: name,
      password: password,
      type: type
  });
  //检查用户名是否已经存在 
  User.get(newUser.name, function (err, user) {
    if (err) {
      req.flash('error', err);
      return res.redirect('/');
    }
    if (user) {
      req.flash('error', '用户已存在!');
      return res.redirect('/reg');//返回注册页
    }
    //如果不存在则新增用户
    newUser.save(function (err, user) {
      if (err) {
        req.flash('error', err);
        return res.redirect('/reg');//注册失败返回主册页
      }
      req.session.user = user;//用户信息存入 session
      req.flash('success', '注册成功!');
      res.redirect('/');//注册成功后返回主页
    });
  });
});

router.get('/login', checkNotLogin);
router.get('/login', function (req, res) {
    res.render('login', {
        title: '登录',
        user: req.session.user,
        success: req.flash('success').toString(),
        error: req.flash('error').toString()});
});
router.post('/login', checkNotLogin);
router.post('/login', function (req, res) {
  //生成密码的 md5 值
  var md5 = crypto.createHash('md5'),
      password = md5.update(req.body.password).digest('hex');
  //检查用户是否存在
  User.get(req.body.name, function (err, user) {
    if (!user) {
      req.flash('error', '用户不存在!'); 
      return res.redirect('/login');//用户不存在则跳转到登录页
    }
    //检查密码是否一致
    if (user.password != password) {
      req.flash('error', '密码错误!'); 
      return res.redirect('/login');//密码错误则跳转到登录页
    }
    //用户名密码都匹配后，将用户信息存入 session
    req.session.user = user;
    req.flash('success', '登陆成功!');
    res.redirect('/');//登陆成功后跳转到主页
  });
});

router.get('/post', checkLogin);
router.get('/post', function (req, res) {
    res.render('post', {
      title: '发布作业',
      user: req.session.user,
      success: req.flash('success').toString(),
      error: req.flash('error').toString()
    });
});

router.post('/post', checkLogin);
router.post('/post', function (req, res) {
  var currentUser = req.session.user,
      post = new Post(currentUser.name, req.body.title, req.body.ddl, req.body.post);
  post.save(function (err) {
    if (err) {
      req.flash('error', err); 
      return res.redirect('/');
    }
    req.flash('success', '发布成功!');
    res.redirect('/');//发表成功跳转到主页
  });
});

router.get('/hwpost/:stu_name/:tc_name/:title', checkLogin);
router.get('/hwpost/:stu_name/:tc_name/:title', function (req, res) {
  Post.getOne(req.params.tc_name, req.params.title, function (err, post) {
    res.render('hwpost', {
      title: '提交作业',
      user: req.session.user,
      hwtitle: req.params.title,
      hwrequirement: post.post,
      success: req.flash('success').toString(),
      error: req.flash('error').toString()
    });
  });
});
router.post('/hwpost/:stu_name/:tc_name/:title', checkLogin);
router.post('/hwpost/:stu_name/:tc_name/:title', function (req, res) {
  Post.getOne(req.params.tc_name, req.params.title, function (err, post) {
    var currentUser = req.session.user,
        hw = new Hw(currentUser.name, req.params.tc_name, post.title, post.post, req.body.post, 0);
    hw.save(function (err) {
      if (err) {
        req.flash('error', err); 
        return res.redirect('/');
      }
      req.flash('success', '提交成功!');
      res.redirect('/');//发表成功跳转到主页
    });
  });
});

router.get('/myhw', checkLogin);
router.get('/myhw', function (req, res) {
  Hw.getAll(null, function (err, hws) {
    if (err) {
      hws = [];
    } 
    res.render('hwlist', {
      title: '我的提交列表',
      user: req.session.user,
      hws: hws,
      success: req.flash('success').toString(),
      error: req.flash('error').toString()
    });
  });
});

router.get('/stuhws', checkLogin);
router.get('/stuhws', function (req, res) {
  Hw.getAll(null, function (err, hws) {
    if (err) {
      hws = [];
    } 
    res.render('hwlist', {
      title: '学生们的提交列表',
      user: req.session.user,
      hws: hws,
      success: req.flash('success').toString(),
      error: req.flash('error').toString()
    });
  });
});

router.get('/u/:name', function (req, res) {
  //检查用户是否存在
  User.get(req.params.name, function (err, user) {
    if (!user) {
      req.flash('error', '用户不存在!'); 
      return res.redirect('/');//用户不存在则跳转到主页
    }
    //查询并返回该用户的所有文章
    Post.getAll(user.name, function (err, posts) {
      if (err) {
        req.flash('error', err); 
        return res.redirect('/');
      } 
      res.render('user', {
        title: user.name,
        posts: posts,
        user : req.session.user,
        success : req.flash('success').toString(),
        error : req.flash('error').toString()
      });
    });
  }); 
});

router.get('/u/:name/:day/:title', function (req, res) {
  Post.getOne(req.params.name, req.params.title, function (err, post) {
    if (err) {
      req.flash('error', err); 
      return res.redirect('/');
    }
    res.render('article', {
      title: "作业标题:" + req.params.title,
      post: post,
      user: req.session.user,
      success: req.flash('success').toString(),
      error: req.flash('error').toString()
    });
  });
});

router.get('/edit/:name/:day/:title', checkLogin);
router.get('/edit/:name/:day/:title', function (req, res) {
  var currentUser = req.session.user;
  Post.edit(currentUser.name, req.params.day, req.params.title, function (err, post) {
    if (err) {
      req.flash('error', err); 
      return res.redirect('back');
    }
    res.render('edit', {
      title: '编辑',
      post: post,
      user: req.session.user,
      success: req.flash('success').toString(),
      error: req.flash('error').toString()
    });
  });
});
router.post('/edit/:name/:day/:title', checkLogin);
router.post('/edit/:name/:day/:title', function (req, res) {
  var currentUser = req.session.user;
  Post.update(currentUser.name, req.params.day, req.params.title, req.body.ddl, req.body.post, function (err) {
    var url = encodeURI('/u/' + req.params.name + '/' + req.params.day + '/' + req.params.title);
    if (err) {
      req.flash('error', err); 
      return res.redirect(url);//出错！返回文章页
    }
    req.flash('success', '修改成功!');
    res.redirect(url);//成功！返回文章页
  });
});


router.get('/remove/:name/:day/:title', checkLogin);
router.get('/remove/:name/:day/:title', function (req, res) {
  var currentUser = req.session.user;
  Post.remove(currentUser.name, req.params.day, req.params.title, function (err) {
    if (err) {
      req.flash('error', err); 
      return res.redirect('back');
    }
    req.flash('success', '删除成功!');
    res.redirect('/');
  });
});

router.get('/logout', checkLogin);
router.get('/logout', function (req, res) {
  req.session.user = null;
  req.flash('success', '登出成功!');
  res.redirect('/');//登出成功后跳转到主页
});


module.exports = router;
