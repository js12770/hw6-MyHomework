require! ['mongoose']

module.exports = mongoose.model 'Requirement', {
	id:String,
	teacher:String,
	question:String,
	requirement:String,
	course:String,
	deadline:String
}