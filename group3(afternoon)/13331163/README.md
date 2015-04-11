# SE-386 Lab 06. MyHomework  

based on http://code.tutsplus.com/tutorials/authenticating-nodejs-applications-with-passport--cms-21619

### install & start development
1. install MonogoDB
2. run mongod (on default port 27017) 
3. npm install
4. grunt watch

### 运行
    1.安装 MonogoDB
    2.运行 mongod
    3.安装必要的包 npm install
    4.运行服务器 grunt watch
    5.浏览器输入 http://localhost:5000 访问应用
### 应用说明
    1.先注册并登陆用户，进入主页
        * 注册时可选择身份（学生或者教师）
    2.在导航栏，根据不同的身份有不同的功能,并且有用户名和用户身份，“退出登录”按钮
        * 点击“所有课程”可以查看老师开设的所有课程
        * 点击“所有课程”中的课程，即可参与该课程
        * 参与的课程可以在“我的课程”中查看
        
            学生
                * 点击“我的课程”中的课程，可以显示有关该课程的所有作业要求和学生本人的提交作业情况
                * 学生可以点击“提交作业”进行作业的提交，注意确保输入的课程名和作业名已经存在，否则提交失败，自己无法查看
            教师
                * 点击“开设课程”，输入课程名即可开设课程并且自动加入该课程
                * 点击“我的课程”中的课程，可以显示有关该课程的所有作业要求和所有学生的作业提交情况
                * 点击“布置作业”，完善相关信息，提交后可为某课程布置作业
                * 在“查看作业情况时”，老师可以给学生评分，可以修改作业要求
                
#### 注意
    * 由于能力和时间有限，“时间”方面还未实现限制
    * 界面不太友善，望见谅

#### 联系方式
    邮箱: MchCyLh@gmail.com