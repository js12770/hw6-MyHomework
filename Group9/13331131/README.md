# MY HOMEWORK

一个用于作业发布、提交及批改的网站。用 NodeJS 实现，数据库采用 MongoDB。

## FUNCTION

### 教师
每个教师都能发布作业要求（支持 Markdown 语法），并且只能看到自己发布的作业要求。同时在作业详情页面中，**既能看到学生提交作业的情况，也能点击改作业下载文件。**

必须在 Deadline 过后，教师才能批改作业。Deadline 前，教师还能够更新 Deadline（大于当前时间的时间日期才是合法的），或者更新作业描述。

### 学生
每个学生都能看到全部作业要求，并且能够看到作业提交的情况，**但不能够下载其他同学提交的作业。**

必须在 Deadline 之前，学生才能够提交作业。重复提交作业以最后一次提交为准。

## HOW TO BUILD

```bash
npm install
grunt build
```

## HOW TO RUN

### 直接运行编译后的文件

1. 安装 MongoDB
2. 在命令行运行 `grunt server`
3. 如果没有自动打开浏览器，输入 `localhost:9000` 可以访问

### 编译后再运行

1. 安装 MongoDB
2. 命令行运行 `grunt`
3. 命令行运行 `grunt server`
4. 如果没有自动打开浏览器，输入 `localhost:9000` 可以访问

## DEPENDENCIES

1. Node v0.10.x
2. ExpressJS v4.12
3. Mongoose
4. Semantic UI
