$(function() {
    $('#file_upload').uploadify({
        'swf'      : '/resource/uploadify.swf',
        'uploader' : '/submit',
        'onUploadSuccess' : function(file,data,response) {
        	var data = eval('(' + data + ')');
        	if(!!data.err) {
        		alert(data.msg);
        		window.location.href='/home';
        	}
        	else {
        		alert("上传成功!");
        	}
        }
    });

    $('.form_datetime').datetimepicker({
        weekStart: 1,
        todayBtn:  1,
		autoclose: 1,
		todayHighlight: 1,
		startView: 2,
		forceParse: 0,
        showMeridian: 1
    });


    $('#update').click(function(){
    	var content = $('#content').val();
    	var time = $('#time').val();
    	var title = $('#title').val();
    	var postData = {
    		content : content,
    		deadline : time,
    		title : title
    	};
    	console.log(postData);
    	$.post('/createRequest',postData,function(data) {
    		var data = eval('(' + data + ')');
    		if(!!data.err) {
    			alert(data.msg);
    			window.location.href = '/home';
    		}
    		else {
    			alert('发布作业要求成功!');
    		}
    	})
    });
});