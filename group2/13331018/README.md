# SE-386 Lab 06. MyHomework    

based on http://code.tutsplus.com/tutorials/authenticating-nodejs-applications-with-passport--cms-21619

## install & start development
1. install MonogoDB
2. run mongod (on default port 27017)
3. npm install
4. grunt watch


##已完成的内容
1. 人物角色分类，分为老师和学生。
2. 访问管理，老师可以看到所有的作业要求和所有学生提交的作业，学生能看到所有的作业要求，但只能够看到自己的作业。

##使用说明与注意
1. 一开始已经把三个人物（一个老师和两个学生）和三个作业导入了数据库，可参考文件目录下的src/models/init.ls文件：
    - 其中，老师的账号名为Teacher，学生的账号名为Student1和Student2，三个人物的密码均为12345。
    - 三个作业的名称分别为Lab1，Lab2，Lab3，已经有作业要求和提交的作业，均为文本格式...
2. 存在重复导入数据的问题：当重启服务器时，会再一次把三个人物和三个作业的数据导入数据库，待改进...
3. 暂时就这么多，能力有限，抱歉。


