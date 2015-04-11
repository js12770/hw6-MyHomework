require! ['mongoose']

module.exports = mongoose.model 'hw', {
	id: String,
	master: String,
	hwname: String,
	hwrequest: String,
	hwddl: Date
}