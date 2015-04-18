# SE-386 Lab 06. MyHomework    

based on http://code.tutsplus.com/tutorials/authenticating-nodejs-applications-with-passport--cms-21619

## install & start development
1. install MonogoDB
2. run mongod (on default port 27017)
3. npm install
如果运行出错的话就运行一下 npm install multer， 再运行一下grunt watch
4. grunt watch

1,一个老师只有一门课，一门课只有一个老师，老师可以发布多个作业，学生可以选择多门课，可以参加多门作业

2.注册完了之后，让注册用户选择角色（老师或者学生）， 还要选择一门课程

3.老师进入个人主页之后，可以发布作业，可以修改（modify）已经发布的作业deadline和作业要求，这个也会显示老师已经发布的作业，并且可以查看已经发布的作业的详情（detail）在每个详情页面可以查看每个作业的提交情况，还可以在deadline到达之后对应给学生分数和可以下载对应学生的作业。

4学生的个人主页分别显示可以参加的课程，已经参加的课程，已经参加的作业，可以参加的作业，已经参加的作业在没有逾期的情况下可以提交作业，作业可以多次提交，保持最新版本。
