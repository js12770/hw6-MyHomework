require! ['mongoose']

module.exports = mongoose.model 'Answer', {
  id: String,
  master: String,
  homework_title: String,
  homework_id: String,
  content: String,
}