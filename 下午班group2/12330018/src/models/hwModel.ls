require! ['mongoose']

schema = new mongoose.Schema {name: String, path: String}
module.exports = mongoose.model 'HwModel',schema
