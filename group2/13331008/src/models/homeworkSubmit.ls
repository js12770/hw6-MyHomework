require! ['mongoose']

module.exports = mongoose.model 'HomeworkSubmit', {
  title: String
  content: String
  belongTo: String
  submitter: String
  score: String
}