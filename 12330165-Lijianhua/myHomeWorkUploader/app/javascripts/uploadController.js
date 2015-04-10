/**
 * Created by Kira on 4/10/15.
 */

$(document).ready(function() {
    $('#uploader-button').click(function() {
        $(':file').click();
    });
    $(':file').change(function() {
        var file = this.files[0];
        $('#filename').val(file.name);
    });
    function progressHandlingFunction(e) {
        if (e.lengthComputable) {
            $('progress').attr({value: e.loaded, max: e.total});
        }
    }
    $('#submit-button').click(function() {
        var formData = new FormData($('form')[0]);
        $.ajax({
            type: 'POST',
            url: '/main/upload',
            xhr: function() {
                myXhr = $.ajaxSettings.xhr();
                if (myXhr.upload) {
                    myXhr.upload.addEventListener('progress', progressHandlingFunction, false);
                }
                return myXhr;
            },
            data: formData,
            success: function(data) {
                data = JSON.parse(data);
                alert(data.message);
                if (data.type) {
                    self.parent.location.replace('/main');
                }
            },
            cache: false,
            contentType: false,
            processData: false
        });
    });
});