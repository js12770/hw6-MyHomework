require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	id: String,
<<<<<<< HEAD:group5/13331202_moguanzhao/src/models/homework.ls
	title: String,
=======
	hid: String,
	sid: String,
	tid: String,
	teacher: String,
	student: String,
>>>>>>> 8e87d8047ea9b60158d5b4011b64802f4e8a21e3:Group9/12330340/src/models/homework.ls
	content: String,
	deadline: Date
}