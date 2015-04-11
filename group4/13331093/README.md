# SE-386 Lab 06. MyHomework    

MyHomework 是一个基于ExpressJS的Web 2.0应用，老师可以发布作业，学生可以提交作业。

    角色: 学生，老师。
    访问管理：
        只有选定了本课程老师和学生才能够访问使用本系统。
        老师可以看到所有的作业要求和所有学生提交的作业。
        学生能看到所有的作业要求，但只能够看到自己的作业。
    发布作业要求：老师可以发布作业要求，也可以修改一个已发布但是尚未截止的作业要求。
    提交作业：学生可以提交作业（可以多次提交作业，系统将保留最新的版本）。
    deadline：老师可以设定/修改作业要求的截止时间，截止时间到达后，任何学生都将无法提交作业。
    作业评分: 截止时间到达之后，老师可以批改作业给出分数。

based on http://code.tutsplus.com/tutorials/authenticating-nodejs-applications-with-passport--cms-21619

## install & start development
1. install MonogoDB
2. run mongod (on default port 27017)
3. npm install
4. grunt watch
5. open http://localhost:5000


## 使用说明：
请安装所有依赖
首次运行前确保MonogoDB中my-homework无数据，以免发生错误，
如果有数据的话进数据库用以下命令清空
use my-homework
db.dropDatabase()

如果运行有问题的话请联系我：
QQ:536803427


