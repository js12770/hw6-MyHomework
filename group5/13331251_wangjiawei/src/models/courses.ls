require! ['mongoose']

module.exports = mongoose.model 'Course', {
    id: String,
    name: String,	
    student-id: [String],
    teacher-id: String,
    homework-id: [String]
}
