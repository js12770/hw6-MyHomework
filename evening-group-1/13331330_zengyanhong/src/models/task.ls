require! ['mongoose']

module.exports = mongoose.model 'Task', {
	startdate: String,
	deadline: String,
	detail: String,
	name: String
}