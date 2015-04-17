require! ['mongoose']

module.exports = mongoose.model 'Submission', {
    homeworkId: String,
    homeworkName: String,
    uploadDate: String,
    studentName: String,
    content: String,
    homeworkDeadline: String,
    grade: Number
}