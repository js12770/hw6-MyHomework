require! ['mongoose']

module.exports = mongoose.model 'Homework', {
  id: String,
  master: String,
  title:String,
  deadline:Date,
  demand:String,
}