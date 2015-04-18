require! ['mongoose']

module.exports = mongoose.model 'Finished', {
	finished_workid: String,
	finished_user: String,
	finished_time: Date,
	hw_name: String,
	score: { type: String, default: '未评分' }
}