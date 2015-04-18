# SE-386 Lab 06. MyHomework    

13331266

based on http://code.tutsplus.com/tutorials/authenticating-nodejs-applications-with-passport--cms-21619

## install & start development
1. install MonogoDB
2. run mongod (on default port 27017)
3. npm install
4. grunt watch

UI说明：
-注册账号时分为teacher, student 两种identity;
-首页显示所有作业情况，对于老师，过ddl的可以Remark评分，未过ddl的可以edit修改。对于学生，未过ddl的可以多次查看或提交handin.
-不能直接访问~/handin ~/reamrk ~/answerlist 三个页面，必须通过点击进入。请善用Homepage返回。
-所有要求功能都有实现，调试环境是windows7+chrome, 如果出现奇怪的bug可联系企鹅403977441