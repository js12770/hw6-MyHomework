require! ['mongoose']

module.exports = mongoose.model 'Request' , {
	title : String,
	teacher: String,
	content : String,
	startTime: String,
	endTime: String
}
