require! ['mongoose']

module.exports = mongoose.model 'Submit', {
	id: String,
	author: String,
	homework: String,
	title: String,
	description: String,
	grade: String,
	time: Date
}
