require! ['mongoose']

SubmitSchema = new mongoose.Schema {
	id: String,
	author: String,
	homework: String,
	title: String,
	description: String,
	grade: String,
	time: Date
}

SubmitSchema.virtual 'submitDate' .get ->
	month = if (@time.getMonth!+1) >= 10 then "#{@time.getMonth!+1}" else "0#{@time.getMonth!+1}"
	date = if (@time.getDate!) >= 10 then "#{@time.getDate!}" else "0#{@time.getDate!}"
	hour = if (@time.getHours!) >= 10 then "#{@time.getHours!}" else "0#{@time.getHours!}"
	minute = if (@time.getMinutes!) >= 10 then "#{@time.getMinutes!}" else "0#{@time.getMinutes!}"
	"#{@time.getFullYear!}/#{month}/#{date} #{hour}:#{minute}"

module.exports = mongoose.model 'Submit',SubmitSchema