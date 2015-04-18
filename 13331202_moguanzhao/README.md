# SE-386 Lab 06. MyHomework    

based on http://code.tutsplus.com/tutorials/authenticating-nodejs-applications-with-passport--cms-21619

## install & start development
1. install MonogoDB
2. run mongod (on default port 27017)
3. npm install
4. grunt watch

①用户的身份(老师或是学生)在注册的时候要确定.
②登陆后，如果是老师,那么就可以发布作业.(蓝色按钮"publish homework",作业包括题目、要求、deadline)
③如果登陆的用户是学生,可以在主页上看到自己提交过的作业.(起始没有,因为没有提交过任何的作业)
④每发布一个作业后老师和学生都可以看到作业,以红色按钮表示.
⑤老师点开已发布的作业后,可以修改作业要求以及deadline,还可以进入批改作业页面.
⑥老师进入批改作业页面之后,可以看到所有学生提交的作业.在deadline过后可以评分
⑦学生点开已发布的作业后,可以在deadline前提交自己的作业(以直接输入的形式提交).