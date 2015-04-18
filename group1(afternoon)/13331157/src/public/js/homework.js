
$(document).ready(function(){
	var dateToDisable = new Date();
	dateToDisable.setDate(dateToDisable.getDate());
	$("#datetimepicker").datetimepicker();
    $("#datetimepicker2").datetimepicker({
		/*beforeShowDay: function(date) {
			if (date.getTime() < dateToDisable.getTime()) {
				return [false, ""]
			}
			return [true, ""];
		}*/
	});
});