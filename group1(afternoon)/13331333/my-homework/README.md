# SE-386 Lab 06. MyHomework    

based on http://code.tutsplus.com/tutorials/authenticating-nodejs-applications-with-passport--cms-21619

## install & start development
1. install MonogoDB
2. run mongod (on default port 27017)
3. npm install
4. grunt watch

注：
需要运行mongodb 
运行方式为mongod --dbpath xxx (xxx为你计算机中mongodb存放data的路径)
本应用可以注册多个老师账户和学生账户，每个老师可以发布问题，且只能看到自己发布的问题。
每个学生都能看到所有老师的问题并作出回答，待老师评分后可以查看分数。
当deadline过了以后，老师和学生都不能修改问题和回答问题。
学生可以多次提交，老师可以多次评分。
lab6中的要求均已完成。
optional的部分由于时间不够，没有完成。