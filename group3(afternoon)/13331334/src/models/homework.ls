require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	title: String,
	description: String,
	deadline: String
}

/* index: teacher */