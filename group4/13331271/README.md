# SE-386 Lab 06. MyHomework    

based on http://code.tutsplus.com/tutorials/authenticating-nodejs-applications-with-passport--cms-21619

## install & start development
1. install MonogoDB
2. run mongod (on default port 27017)
3. npm install
4. grunt watch
5. http://localhost:5000
（如出现无法运行，请联系QQ：553544693）

## 主要功能
	1. 注册功能
	    * 注册时可以选择职业（教师/学生）
	    * 学生可以任意注册，只需输入相关用户资料即可
	    * 教师注册需要输入序列号，通过认证才可注册
	    * 注册后自动跳转相应身份的主页

	2. 登陆功能
	    * 当用户名和密码通过验证才可登陆，根据身份自动跳转至相应的主页
	    
    3. 教师端（每个行为都对用户身份进行判断，只有教师才拥有以下权限）
        * 发布作业
            可设定作业题目，作业内容，ddl, 上传文件
	    * 查看发布
	        教师可以查看自己发布作业的历史，包括文字内容和文件
	    * 评分
	        过了ddl之后，教师可以看到每个学生对自己发布的作业的提交内容（包括学生上传的文件），并且可以打分
        * 编辑已发布的作业
            教师可以修改作业的内容，ddl和相关文件
        * 删除已发布的作业
	    * 不同的教师之间发布的题目是不可见的

	4. 学生端
	    * 学生可以看到所有老师发布的作业
	    * 学生可以选择任一作业填写内容，上传文件并提交
    	* 当ddl过了之后，将禁止提交
    	* 学生可以多次提交作业，系统只保存最新的那次提交
    	* 学生能够看到自己最新的提交时间，并且可以看到老师对这次作业的评分


## Router
    1. GET  '/'              登陆页面
    2. POST '/login'         登陆表单提交
    3. GET  '/signup'        注册页面
    4. POST '/signup'        提交注册表单
    5. POST '/signout'       登出请求
    6. GET  '/home'          登陆成功后的主页
    7. GET  '/grade?title=x' 教师获得学生作答该题的所有提交列表
    8. POST '/grade'         评分请求
    9. POST '/submit'        学生提交作业请求
    10.POST '/issue'         教师发布作业请求
    11.POST '/edit'          教师编辑作业请求
    12.POST '/delete'        教师删除作业请求
