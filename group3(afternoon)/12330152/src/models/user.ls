require! ['mongoose']

module.exports = mongoose.model 'User',
  username: String
  password: String
  role: String
