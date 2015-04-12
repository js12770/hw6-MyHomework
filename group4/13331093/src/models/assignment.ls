require! ['mongoose']

module.exports = mongoose.model 'Assignment', {
    author: String,
    deadline: String,
    title: String,
    content: String,
}