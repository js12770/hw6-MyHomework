require! ['mongoose']

module.exports = mongoose.model 'Problem' , {
	teacher: String,
	title : String,
	ddl  : String,
	content : String
}
