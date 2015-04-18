require! ['mongoose']

schema = new mongoose.Schema {
  id: String,
  username: String,
  password: String,
  usertype: String,
  firstName: String,
  lastName: String
}

schema.virtual 'name' .get ->
  name = "#{@firstName or ' '} #{@lastName or ' '}"

module.exports = mongoose.model 'User', schema