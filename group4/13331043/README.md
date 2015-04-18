##   lab6 - MyHomework
#### Author: Xuan Dai
#### private repo: https://github.com/daix6/SPI/tree/master/lab6

based on http://code.tutsplus.com/tutorials/authenticating-nodejs-applications-with-passport--cms-21619

### 如何运行

1. npm install 安装依赖
2. mongod 运行数据库
3. grunt watch 
4. 访问localhost:5000

### 功能

1. 学生可以查看所有assignment并能提交homework。能重复提交，数据库保留最新一次。
2. 老师可以发布assignment，查看所有assignment，并能查看学生提交的homework，可以评分，但只能评一次。
3. 在截止日期前，学生可以提交homework，老师可以修改assignment要求，修改deadline。在截止日期后，学生不能再提交homework，老师可以修改deadline。
4. 每个assignment与homework都有自己的页面~

### 不足之处

1. 页面很丑，非常丑。
2. 代码很丑，非常丑。（没时间加注释了，代码质量就……什么都别说了！:cry:）