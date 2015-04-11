require! ['mongoose']

module.exports = mongoose.model 'Homework', {
  title: String,
  discription: String,   # to-do: 改进discription，使之能加入图片和视频
  deadline: Date,
  submited: Array
}