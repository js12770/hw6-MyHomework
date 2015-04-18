var mongoose = require('mongoose');
var NewhomeworkSchema = require('../schemas/newhomework');
var Newhomework = mongoose.model('Newhomework', NewhomeworkSchema);

module.exports = Newhomework;