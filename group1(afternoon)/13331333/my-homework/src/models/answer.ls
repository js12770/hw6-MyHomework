require! ['mongoose']

module.exports = mongoose.model 'Answer', {
    student_id: String,
    question_id: String,
    student_name: String,
    question_title: String,
    teacher_id: String,
    content: String,
    score: String
}
