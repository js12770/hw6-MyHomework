require! ['mongoose']

module.exports = mongoose.model 'Requirement', {
  coursename: String,
  requirementname: String,
  requirementcontent: String,
  deadline: String
}
