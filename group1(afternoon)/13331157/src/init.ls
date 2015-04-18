require! {User:'./models/user', Homework:'./models/homework', Submit:'./models/submit', 'bcrypt-nodejs', 'passport-local'}

hash = (password)-> bcrypt-nodejs.hash-sync password, (bcrypt-nodejs.gen-salt-sync 10), null

module.exports = !->
    User.find (err,obj)->
        if obj.length == 0
            user1 = new User {
                username  : '123'
                password  : hash '123'
                email     : 'email@example.com'
                firstName : '456'
                lastName  : '789'
                type      : 'student'
            }
            user1.save!
            user2 = new User {
                username  : 'test'
                password  : hash 'test'
                email     : 'email@example.com'
                firstName : 'hello'
                lastName  : 'world'
                type      : 'student'
            }
            user2.save!
            teacher1 = new User {
                username  : 'Eric'
                password  : hash 'password'
                email     : 'email@example.com'
                firstName : 'Wang'
                lastName  : 'Qin'
                type      : 'teacher'
            }
            teacher1.save!
            teacher2 = new User {
                username  : 'WangQing'
                password  : hash 'password'
                email     : 'email@example.com'
                firstName : 'Wang'
                lastName  : 'Qin'
                type      : 'teacher'
            }
            teacher2.save!

    Homework.find (err,obj)->
        if obj.length == 0
            s-date1 = new Date 2015,3,8,8,0,0
            e-date1 = new Date 2015,3,12,8,0,0
            homework1 = new Homework {
                title       : 'Homework1'
                author      : 'Eric'
                description : '在给定源代码：[source-code.zip](http://my.ss.sysu.edu.cn/wiki/pages/viewpage.action?pageId=395968523)的基础上，完成@+环形菜单的CSS。\r\n\r\n1. @+环形菜单出现在页面下部，靠近底边，居中\r\n2. 其关闭时（鼠标未指向），只显示缩小的@+按钮，效果如图：'
                start       : s-date1
                end         : e-date1
                submits     : '0'
            }
            homework1.save!
            s-date2 = new Date 2015,3,14,8,0,0
            e-date2 = new Date 2015,3,24,8,0,0
            homework2 = new Homework {
                title       : 'Homework2'
                author      : 'Eric'
                description : '* 在表头任意一个栏目中点击一下，下面各行将按照此栏目值的升序排序\r\n* 按照字符串比较来确定顺序\r\n* 再次点击该栏目，变更为降序排序\r\n* 点击其它栏目，则按其它栏目的值重新排序\r\n* 注意，排序时，栏目奇偶行的背景色保持奇数白色，偶数灰色'
                start       : s-date2
                end         : e-date2
                submits     : '0'
            }
            homework2.save!

    Submit.find (err,obj)->
        if obj.length == 0
            date1 = new Date 2015,3,10,8,0,0
            submit1 = new Submit {
                author      : '123'
                homework    : 'Homework1'
                title       : 'Submit for Homework1'
                description : '### 重点\r\n1.  用css控制显示圆形\r\n2. CSS transition\r\n3. 嵌套CSS规则'
                grade       : 80
                time        : date1
            }
            submit1.save!
            
            date2 = new Date 2015,3,11,8,0,0
            submit2 = new Submit {
                author      : 'test'
                homework    : 'Homework1'
                title       : 'Submit for Homework1 from test'
                description : '* hello world\r\n* javascript\r\n* python\r\n'
                grade       : null
                time        : date2
            }
            submit2.save!

