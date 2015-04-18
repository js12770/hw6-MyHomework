require! ['mongoose']

module.exports = mongoose.model 'Question', {
    teacher_id: String,
    teacher_name: String,
    title: String,
    requirements: String,
    deadline: Date,
}
