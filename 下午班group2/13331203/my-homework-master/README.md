# SE-386 Lab 06. MyHomework    

based on http://code.tutsplus.com/tutorials/authenticating-nodejs-applications-with-passport--cms-21619

## install & start development
1. install MonogoDB
2. run mongod (on default port 27017)
3. npm install
4. grunt watch

#使用说明
1.导航栏有Home、View、Publish(teacher)，分别为首页、作业、发布
2.首页Announcement为作业提交的状态动向
3.在作业View学生可查看老师发布的作业，点击并完成作业，提交后可查看分数，截止不予以提交
4.在作业View老师点击作业可查看所有学生提交状况，点击Content修改题目内容，点击ddl修改截止日期(截止后不可再修改题目内容)
5.在Check页老师可查看所有提交的作业状态，截止后给分