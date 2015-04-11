require! ['mongoose']

module.exports = mongoose.model 'Course', {
  creater: String,
  course-name: String,
  course-short-name: String,
  short-discription: String,
  detail-discription: String,
  students: Array,
}