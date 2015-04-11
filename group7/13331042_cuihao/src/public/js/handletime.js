$(function(){
	Date.prototype.format = function(format){ 
		var o = { 
			"M+" : this.getMonth()+1, //month 
			"d+" : this.getDate(), //day 
			"h+" : this.getHours(), //hour 
			"m+" : this.getMinutes(), //minute 
			"s+" : this.getSeconds(), //second 
			"q+" : Math.floor((this.getMonth()+3)/3), //quarter 
			"S" : this.getMilliseconds() //millisecond 
		} 

		if(/(y+)/.test(format)) { 
			format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
		} 

		for(var k in o) { 
			if(new RegExp("("+ k +")").test(format)) { 
				format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length));
			} 
		} 
		return format; 
	} 
	
	var getTime = function() {
		var now = new Date(); 
		var nowStr = now.format("yyyy-MM-dd hh:mm");
		return nowStr
	}
	if ($("#thebutton")) {
		if (getTime() < $('#score1').attr('deadline')) {
			$("#thebutton").addClass("disabled");
			$("#moremessage").text("(未到deadline，无法评分)");
		}
	}
	if ($("#thebutton1")) {
		if (getTime() > $('#deadline').html()) {
			$("#thebutton1").addClass("disabled");
			$("#moremessage").text("(已过deadline，无法提交)");
		}
	}
	if ($('#datetimepicker')) {
		$("#datetimepicker").val(getTime());
	}
});
