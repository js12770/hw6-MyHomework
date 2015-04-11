require! ['mongoose']

module.exports = mongoose.model 'StudentWork', {
    asgnment: String,
    student: String,
    content: String,
    grade: String
}

