require! ['mongoose']

module.exports =  mongoose.model 'Submission', {
    id: String,
    username: String,
    submittime: String,
    score: String,
    title: String,
    content: String
}