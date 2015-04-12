require! ['mongoose']

module.exports = mongoose.model 'Assignment', {
    detail: String,
    deadline: String
}
