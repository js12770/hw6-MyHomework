# SE-386 Lab 06. MyHomework    

based on http://code.tutsplus.com/tutorials/authenticating-nodejs-applications-with-passport--cms-21619

## install & start development
1. install MonogoDB
2. run mongod (on default port 27017)
3. npm install
4. grunt watch

## 主要功能
1. 注册功能，注册时可以选择职业（教师/学生）
2. 登陆功能
3. 教师端
+ 教师可以发布作业，设定作业题目，内容，ddl
+ 教师可以查看自己发布作业的历史
+ 教师可以看到每个学生对自己发布的作业的提交内容，并且可以打分
+ 不同的教师之间发布的题目是不可见的
4. 学生端
+ 学生可以看到所有老师发布的作业
+ 学生可以选择任一作业填写内容并提交
+ 当ddl过了之后，将禁止提交
+ 学生能够看到自己最新的提交时间，并且可以看到老师对这次作业的评分
5. 使用前先清空数据库以免出错
6.　时间有限，注释比较少，见谅