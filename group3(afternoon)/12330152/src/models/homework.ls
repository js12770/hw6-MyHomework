require! ['mongoose']

module.exports = mongoose.model 'Homework',
  title: String
  requirement: String
  date: Date
  deadline: Date
  submits:
    * username: String
      date: Date
      score: Number
