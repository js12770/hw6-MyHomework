require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	id: String,
	hwname: String,
	discription: String,
	deadline: Date
}