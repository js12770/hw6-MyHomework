require! ['mongoose']

module.exports = mongoose.model 'Answer', {
	homework: String,
	student: String,
	firstName: String,
	lastName: String,
	content: String,
	score: Number
}

/* index: homework, student */