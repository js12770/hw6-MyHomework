# SE-386 Lab 06. MyHomework    

based on http://code.tutsplus.com/tutorials/authenticating-nodejs-applications-with-passport--cms-21619

## install & start development
1. install MonogoDB
2. run mongod (on default port 27017):  
	在mongodb目录下创建一个文件夹比如my-homework  
	进入mongodb目录下的bin文件夹:  
	对于windows： mongodb.exe --dbpath (my-homewok的相对路径或绝对路径)  
	对于mac：	./mongod --dbpath (my-homewok的相对路径或绝对路径)  
3.（sudo）npm install
4. grunt watch


### 完成了所有的功能点，附上几点说明：
1. 用户注册多了学(工)号的输入和身份的选择，教师还是学生。
2. 对于作业，未过截止日期，日期字体显示绿色，已过截止日期，显示红色。
3. 对于老师，作业未过截止日期，显示编辑（可修改截止日期和具体要求）和删除的操作，已过截止日期，只显示批改操作。   
   点击批改，显示此次作业所有同学提交的作业链接，点击下载查阅。
4. 对于学生，作业未过截止日期，可点击查看详情，进入后有此次作业的具体要求，并且可以上传作业，默认只支持.zip文件。  
   文件名要求为本人的学号，但如果不按照要求也无关紧要，后台会做出相应的修改操作。支持作业覆盖更新。
