require! ['mongoose']
/*
module.exports = mongoose.model 'Homework', {
    id: String,
}
*/
/*
mongooseSchema = new mongoose.Schema ({
    username : {type : String, default : '匿名用户'},
    title    : {type : String},
    content  : {type : String},
    time     : {type : Date, default: Date.now},
    age      : {type : Number}
})

mongooseSchema.methods.findbyusername = (username, callback)->
    return this.model 'mongoose' .find {username: username}, callback

mongooseSchema.statics.findbytitle = (title, callback)->
    return this.model 'mongoose' .find {title: title}, callback
mongooseModel = mongoose.model 'mongooseModel', mongooseSchema

module.exports = mongoose.model 'mongooseModel', mongooseSchema

doc = {username : 'emtity_demo_username', title : 'emtity_demo_title', content : 'emtity_demo_content'}

mongooseEntity = new mongooseModel(doc)

mongooseEntity.save (error)->
    if error
        console.log error
    else
        console.log 'saved OK!'

doc = {username : 'model_demo_username', title : 'model_demo_title', content : 'model_demo_content'}

mongooseModel.create doc, (error) ->
    if error
        console.log error
    else
        console.log 'save ok'

mongooseModel.update conditions, update, options, callback

conditions = {username : 'model_demo_username'}
update     = {$set : {age : 27, title : 'model_demo_title_update'}}
options    = {upsert : true}

mongooseModel.update conditions, update, options, (error)->
    if error
        console.log error
    else
        console.log 'update ok!'
*/
/*
mongooseEntity = new mongooseModel({})

mongooseEntity.findbyusername 'model_demo_username', (error, result)->
    if error
        console.log error
    else
        console.log result

mongooseModel.findbytitle 'emtity_demo_title', (error, result)->
    if error
        console.log error
    else
        console.log result

criteria = {title : 'emtity_demo_title'}
fields   = {title : 1, content : 1, time : 1}
options  = {}

mongooseModel.find criteria, fields, options, (error, result)->
    if error
        console.log error
    else
        console.log result

conditions = {username: 'emtity_demo_username'}

mongooseModel.remove conditions, (error)->
    if error
        console.log error
    else
        console.log 'delete ok!'


-----------
mongoose.createConnection 'mongodb://localhost/my-homework'


BlogId = mongoose.Schema.ObjectId
BlogSchema = mongoose.Schema({
    owner: BlogId,
    name: String,
    age: String,
    work: String,
    email: String,
    title:String,
    content:String,
    date:Date
})
*/
require! {User:'../models/user'}

mongoose.createConnection 'mongodb://localhost/my-homework'
# 生成表模型，可作为类使用
Homework = mongoose.model 'Homework', {
    hw-id      : mongoose.Schema.ObjectId,
    name       : String,
    requirement: String,
    startDate : {type: Date, default: Date.now},
    deadline   : Date
}
/*
Homework-upload = mongoose.model 'Homework-upload', {
    hw-to-upload : Homework,
    student      : User,
    upload-date  : {type: Date, default: Date.now},
}
*/
/*
module.exports = mongoose.model 'Blog', BlogSchema
*/
module.exports.create = (user, param)->
    if user.role is 'student'
        console.log 'Except operation!'
    else
        new-homework = new Homework(param)
        new-homework.save (error)->
            if error
                console.log error
            else
                console.log "Create " + new-homework
        new-homework
/*
module.exports.upload = (user, param)->
    if user.role is 'student'
        new-homework-upload = new Homework-upload(param)
        new-homework-upload.save (error)->
            if error
                console.log error
            else
                console.log "Upload " + new-homework-upload.hw-to-upload.name
        new-homework-upload
    else
        console.log 'Except operation!'
*/
# 查找
module.exports.findAll = (condition, callback)->
    Homework.find condition, callback


module.exports.findById = (condition, callback)->
    Homework.find-one condition, callback

module.exports.updateContent = (conditions, requirement, callback)->
    Homework.update(conditions, {requirement: requirement}, {upsert : true}, callback)

module.exports.updateDueDate = (conditions, deadline, callback)->
    Homework.update(conditions, {deadline: deadline}, {upsert : true}, callback)
