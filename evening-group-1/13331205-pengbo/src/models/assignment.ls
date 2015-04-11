require! ['mongoose']

module.exports = mongoose.model 'Assignment', {
    asgnname: String,
    deadline: String,
    requirement: String
}

