require! ['mongoose']

module.exports = mongoose.model 'Homework', {
  homeworkName: String,
  className: String,
  teacher: String,
  description: String,
  deadline: String,
  submits: Array
}
