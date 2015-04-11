require! ['mongoose']

module.exports = mongoose.model 'Homework', {
  coursename: String,
  requirementname: String,
  username: String,
  content: String,
  score: String
}