require! ['mongoose']

module.exports = mongoose.model 'HomeworkPublish', {
  title: String
  description: String
  deadline: String
  publisher: String
}