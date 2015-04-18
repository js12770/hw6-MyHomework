require! ['mongoose']

module.exports = mongoose.model 'Handin' , {
	student: String,
	hwname: String,
	answer: String,
	score: String
}
