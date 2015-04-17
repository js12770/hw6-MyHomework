require! ['mongoose']

module.exports = mongoose.model 'Uphomework', {
  uphomeworkName: String,
  uphomeworkid: String,
  studentName: String,
  extend: String,
  date: { type: Date, default: Date.now },
  score: { type: Number, default: -1},
}
