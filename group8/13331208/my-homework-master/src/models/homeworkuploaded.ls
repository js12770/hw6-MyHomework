require! {'mongoose', User:'../models/user', Homework:'../models/homework'}

Homework-uploaded = mongoose.model 'Homework-uploaded', {
    homeworkName : {type: String, ref: 'Homework'},
    student      : {type: String, ref: 'User'},
    uploadDate   : {type: Date, default: Date.now!},
    filename     : String,
    commitment   : String,
    grades       : Number
}

module.exports.upload = (param)->
    new-homework-uploaded = new Homework-uploaded(param)
    new-homework-uploaded.save (error)->
        if error then console.log error
        else console.log "Upload " + new-homework-uploaded
    new-homework-uploaded

module.exports.findAll = (condition, callback)->
    Homework-uploaded.find condition, (error, result)->
      if error then res.send error
      else callback result

module.exports.findById = (condition, callback)->
    Homework-uploaded.find-one condition, (error, result)->
        if error then res.send error
        else callback result

module.exports.updateCommitment = (conditions, commitment, filename)->
    Homework-uploaded.update(conditions, {commitment: commitment, filename: filename, uploadDate: Date.now!}, {upsert : true}, (error)->
      if error then console.log error else console.log 'UpdateCommitment succeed.')

module.exports.updateGrades = (conditions, grades)->
    Homework-uploaded.update(conditions, {grades: grades}, {upsert : true}, (error)->
      if error then console.log error else console.log 'UpdateGrades succeed.')
