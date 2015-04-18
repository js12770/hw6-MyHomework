require! ['mongoose']

Homework = mongoose.model 'Homework', {
    hw-id       : mongoose.Schema.ObjectId,
    name        : String,
    requirement : String,
    uploaded    : {type: Number, default: 0}
    startDate   : {type: Date, default: Date.now!},
    deadline    : Date
}

module.exports.create = (user, param)->
  if param.deadline < Date.now!
    {error: 'Invalid deadline.'}
  else
    new-homework = new Homework(param)
    new-homework.save (error)->
      if error then console.log error
      else console.log "Create " + new-homework
    new-homework

module.exports.findAll = (condition, callback)->
    Homework.find condition, (error, result)->
      if error then res.send error
      else callback result

module.exports.findById = (condition, callback)->
    Homework.find-one condition, (error, result)->
        if error then res.send error
        else callback result

module.exports.updateRequirement = (conditions, requirement)->
    Homework.update(conditions, {requirement: requirement}, {upsert : true}, (error)->
      if error then console.log error else console.log 'UpdateRequirement succeed.')

module.exports.updateDeadline = (conditions, deadline)->
    Homework.update(conditions, {deadline: deadline}, {upsert : true}, (error)->
      if error then console.log error else console.log 'UpdateDeadline succeed.')

module.exports.updateUploaded = (conditions, uploaded)->
    Homework.update(conditions, {uploaded: uploaded}, {upsert : true}, (error)->
      if error then console.log error else console.log 'Update number of submissions succeed.')

