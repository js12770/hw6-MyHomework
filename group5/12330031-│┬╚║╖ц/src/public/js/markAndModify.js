window.onload = function(){
	$(document).on("click",".remarkSubmit",function(){
		var input = $(this).prevAll('input');
		var a = $(this).prevAll('a');
		var homeworkId = a.attr('data-homework');
		var studnetId = a.attr('data-student');
		var mark = input.val();
		var number = /^[0-9]*$/;
		if (number.test(mark)){
			var url = '/remark/';
			post(url, homeworkId, studnetId, mark);
		}
		else alert('分数应该为数字!');
	});
	function post(url,homeworkId, studentId,mark){
		
		$.post(url,
        {	
        	'homeworkId' : homeworkId,
            'studentId' : studentId,
            'mark' : mark
        }, function(data) {
        	alert(1)
        	location.reload(true);
        }, 'json')
	}
}