require! ['mongoose']

module.exports = mongoose.model 'Class', {
  className: String,
  time: String,
  teacher: String,
  students: Array,
  homeworks: Array
}
