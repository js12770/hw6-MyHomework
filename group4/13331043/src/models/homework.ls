require! ['mongoose']

module.exports = mongoose.model 'Homework', {
    assignmentId: String,
    assignmentTitle: String,
    studentId: String,
    studentName: String,
    text: String,
    postTime: {
        type: String,
        'default': Date.now!
    },
    grade: {
        type: Number,
        'default': -1
    }
}