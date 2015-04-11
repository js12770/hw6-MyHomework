# SE-386 Lab 06. MyHomework    

based on http://code.tutsplus.com/tutorials/authenticating-nodejs-applications-with-passport--cms-21619

## 环境配置
1. 安装 MonogoDB
2. 命令行运行 `mongod`
3. 命令行运行 `npm install`,安装不成功请运行 `sudo npm install`
4. 命令行运行 `grunt watch'`
5. 浏览器打开```localhost:5000```

## 逻辑说明
* 注册时可以选择老师或学生身份
* 初始已存在一个老师账号，请通过 `username: admin` `password: admin` 登陆
* 初始已存在一个作业 `MyHomework`
* 若需要看到作业截止后的效果，请登陆学生账号，在一个未截止的作业下提交作业，再登陆老师账号，将刚才作业的截止时间修改为已截止（比当天时间早的日期），即可打分，再登陆学生账号可看到效果。