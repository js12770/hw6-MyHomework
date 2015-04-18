# SE-386 Lab 06. MyHomework    
## start
1. install MongoDB
2. run mongod (on default port 27017)
3. npm install
4. grunt watch
## readme
- 对需求的理解
    - 不分课程, 课程只有"本课程"
    - user of 2 roles: teacher & student
    - 权限
        - teacher
            - view all homeworks
            - create a homework
            - edit a homework(before deadline)
            - view all submits
            - grade a submit(after deadline)
        - student
            - view all homeworks
            - submit a homework(covering the last submit, before deadline)
            - view his last submit(and the score)
- 数据验证
    - 前端页面提供表单验证
    - 后端接口对bad data一律bad request(400)
- 身份验证
    - 前端页面
        - 未登录一律redirect '/'
        - 无权限一律redirect '/home'
    - 后端接口
        一律bad request(400)
