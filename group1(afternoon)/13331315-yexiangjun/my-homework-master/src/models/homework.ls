require! ['mongoose']

module.exports = mongoose.model 'Homework' , {
	student: String,
	title : String,
	content : String,
	score : String,
	commit: String
}
