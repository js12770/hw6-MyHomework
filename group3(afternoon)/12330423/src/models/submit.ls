require! ['mongoose']

module.exports = mongoose.model 'Submit', {
  student: String,
  grade: String
}
