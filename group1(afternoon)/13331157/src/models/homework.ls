require! ['mongoose']

HomeworkSchema = new mongoose.Schema {
	id: String,
	title: String,
	author: String,
	description: String,
	submits: String,
	start: Date,
	end: Date
}

HomeworkSchema.virtual 'startDate' .get ->
	month = if (@start.getMonth!+1) >= 10 then "#{@start.getMonth!+1}" else "0#{@start.getMonth!+1}"
	date = if (@start.getDate!) >= 10 then "#{@start.getDate!}" else "0#{@start.getDate!}"
	hour = if (@start.getHours!) >= 10 then "#{@start.getHours!}" else "0#{@start.getHours!}"
	minute = if (@start.getMinutes!) >= 10 then "#{@start.getMinutes!}" else "0#{@start.getMinutes!}"
	"#{@start.getFullYear!}/#{month}/#{date} #{hour}:#{minute}"

HomeworkSchema.virtual 'endDate' .get ->
	month = if (@end.getMonth!+1) >= 10 then "#{@end.getMonth!+1}" else "0#{@end.getMonth!+1}"
	date = if (@end.getDate!) >= 10 then "#{@end.getDate!}" else "0#{@end.getDate!}"
	hour = if (@end.getHours!) >= 10 then "#{@end.getHours!}" else "0#{@end.getHours!}"
	minute = if (@end.getMinutes!) >= 10 then "#{@end.getMinutes!}" else "0#{@end.getMinutes!}"
	"#{@end.getFullYear!}/#{month}/#{date} #{hour}:#{minute}"

module.exports = mongoose.model 'Homework',HomeworkSchema