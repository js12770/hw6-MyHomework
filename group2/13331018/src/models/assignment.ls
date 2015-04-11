require! ['mongoose']

module.exports = mongoose.model 'Assignment', {
	id: String,
	name: String,
	demand: String,
	endtime: Date,
	finishedstudent: []
}