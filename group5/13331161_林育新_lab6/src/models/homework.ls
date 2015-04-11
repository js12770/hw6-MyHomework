require! ['mongoose']

module.exports = mongoose.model 'homework', {
	createid: String,
	coursename: String,
	createby: String,
	ddl: String,
	command: String
}