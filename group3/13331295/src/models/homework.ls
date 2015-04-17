require! ['mongoose']

module.exports = mongoose.model 'Homework', {
  teacherName: String,
  homeworkName: String,
  homeworkDemand: String,
  homeworkDeadline: String
}