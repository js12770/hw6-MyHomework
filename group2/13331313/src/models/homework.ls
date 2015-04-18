require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	Hw_id: Number,
	title: String,
	require: String,
	deadline: String
}