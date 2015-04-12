require! {Homework:'../models/homework'}

module.exports = exports = {}

exports.create = (params) !->
  new_homework = new Homework {
      username  : params.username
      filename : params.filename
      time : params.time
  }
  Homework.findOne {filename : params.filename},(err,homework) !->
    if !!err
      console.log "Error in find homeeork: ", err
      throw err
    else if !homework
      new_homework.save (error)->
        if error
          console.log "Error in saving homework: ", error
          throw error
        else
          console.log "Store homework successfully!"
          return
    else
      Homework.where({filename:params.filename}).update {username:params.username,time:params.time},(err,homework) !->
        if err
          console.log "Error in update homework: ", err
        else
          console.log "Update homework successfully!"


exports.get = (params,res) !->
  if params.role is 'student'
    Homework.find {username:params.username},(err,homeworks) !->
      if !!err
        console.log "Error in find homeeork: ", err
        throw err
      else
        res.render 'homework',{homeworks : homeworks, user : params}
  else if params.role is 'teacher'
    Homework.find (err,homeworks) !->
      if !!err
        console.log "Error in find homeeork: ", err
        throw err
      else
        res.render 'homework',{homeworks : homeworks,user : params}
