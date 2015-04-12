require! ['mongoose']

module.exports = mongoose.model 'Assignment', {
	id: String,
	content: String,
	week: Number,
	#course: String,
	deadline: Date
}