require! ['mongoose']

module.exports = mongoose.model 'Homework', {
    id: Number,
    content: String,
    author: String,
    deadline: Date,
    score: Number,
    forList: Boolean
}
