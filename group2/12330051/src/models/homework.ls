require! ['mongoose']

module.exports = mongoose.model 'Work', {
	id: String,
	title: String,
	requirment: String,
	deadline: String
}