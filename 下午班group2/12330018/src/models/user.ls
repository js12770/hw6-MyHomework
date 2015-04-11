require! ['mongoose']

module.exports = mongoose.model 'User', {
  id: String,
  identi: String,
  username: String,
  password: String,
  email: String,
  firstName: String,
  lastName: String  
}