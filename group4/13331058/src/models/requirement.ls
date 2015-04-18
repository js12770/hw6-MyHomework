require! ['mongoose']

module.exports = mongoose.model 'Requirement', {
	id: String,
<<<<<<< HEAD:group4/13331058/src/models/requirement.ls
	master: String,
	Head: String,
	ddl: String,
	content: String
=======
	tid: String,
	teacher: String,
	requires: String,
	deadline: String
>>>>>>> 8e87d8047ea9b60158d5b4011b64802f4e8a21e3:Group9/12330340/src/models/requirement.ls
}