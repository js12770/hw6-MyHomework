require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	id: String,
	title: String,
	description: String,
	submits: String,
	start: Date,
	end: Date
}