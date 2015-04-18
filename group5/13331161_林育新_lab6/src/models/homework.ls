require! ['mongoose']

module.exports = mongoose.model 'homework', {
	createid: String,
	createby: String,
	ddl: String,
	command: String,
	hwname: String,
	submit_hw: Array
}
