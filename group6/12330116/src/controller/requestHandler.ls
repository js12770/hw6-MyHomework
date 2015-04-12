require! {Request:'../models/request'}

module.exports = exports = {}

exports.create = (params) !->
  if !!params.id is true
    Request.where({_id:params.id}).update {username:params.username,deadline:params.deadline,content:params.content,title:params.title},(err,request) !->
      if err
        console.log "Error in update request: ", err
      else
        console.log "Update request successfully!"
    return

  new_request = new Request {
      username  : params.username
      deadline : params.deadline
      content : params.content
      title : params.title
  }
  new_request.save (error)->
    if error
      console.log "Error in saving request: ", error
      throw error
    else
      console.log "Store request successfully!"


exports.get = (params,user,res) !->
  if !!params._id is true
    Request.findOne {_id : params._id} (err,request) !->
      if(!!err)
        console.log "Error in find request: ", error
        throw error
      request.content = request.content.replace('/\s/g','&nbsp').replace(/\n/g,'<br />')
      res.end JSON.stringify {user:user,request:request}
    return

  Request.find (err,requests) !->
    if(!!err)
      console.log "Error in find requests: ", error
      throw error
    else
      console.log "Find requests successfully!"
      res.end JSON.stringify {user:user,requests:requests}