require! ['mongoose']

module.exports = mongoose.model 'Answer', {
  id: String,
  master: String,
  homework_title: String,
  homework_id: String,
  homework_deadline:Date,
  content: String,
  score:Number,
}