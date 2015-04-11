require! ['mongoose']

module.exports = mongoose.model 'Homework', {
  id: String,
  teacherName: String,
  homeworkName: String,
  homeworkDemand: String,
  homeworkDeadline: String
}