# SE-386 Lab 06. MyHomework    

based on http://code.tutsplus.com/tutorials/authenticating-nodejs-applications-with-passport--cms-21619

## install & start development
1. install MonogoDB
2. run mongod (on default port 27017)
3. npm install
4. grunt watch

=========================================
1、安装MongoDB
2、运行mongod，通过如下命令来调用含有我已经写入数据的数据库
  mongod --dbpath ../13331194/data
  其中，..为13331194所在的根目录的路径，即需要填写完整的路径
3、运行npm grunt来安装所需要的库文件
4、通过如下命令来启动服务器
  grunt watch
5、默认端口号为5000，请在浏览器中输入"localhost:5000"(不含引号)来观察运行效果

# 数据库中含有2个老师账号:admin(admin)、admin2(admin2)，括号中为密码
# 有2个学生账号:xiaoming(xiaoming)、xiaohong(xiaohong)，括号中为密码

基本效果:
1、老师
   可以 创建作业要求，
   可以 查看所有的作业要求，
   可以 在任何时候 修改自己创建的作业要求，同时，交了该作业的学生的提交的作业要求的信息会同步变化！
   可以 查看所有学生的作业提交，
   可以 在一个作业要求过了ddl之后给学生的作业提交进行打分。
2、学生
   可以 看到所有老师发布的所有作业要求，
   可以 对任意的作业要求在作业要求的时间期间进行作业提交，
   只能 看到自己的作业提交，
   可以 对提交了的作业进行修改，会自动保留最新提交的作业，