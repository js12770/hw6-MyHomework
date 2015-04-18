require! ['mongoose']

module.exports = mongoose.model 'Answer', {
	Hw_id: Number,
	content: String,
	author: String,
	grade: String
}