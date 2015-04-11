require! ['mongoose']

module.exports = mongoose.model 'Homeworkrequest', {
	name: String,
	request: String,
	ddl: String
}
