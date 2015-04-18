require! ['mongoose']

module.exports = mongoose.model 'Homework', {
<<<<<<< HEAD:下午班group2/13354467/src/models/homework.ls
	homeworkid: String,
	require: String,
	teacher: String,
=======
	producerID: String,
	producerName: String,
	title: String,
	question: String,
	createTime: Date,
>>>>>>> origin/master:13331078/src/models/homework.ls
	ddl: Date
}