// Generated by LiveScript 1.3.1
(function(){
  $.fn.form.settings.rules.date = function(value){
    var dateExp;
    dateExp = /^((\d{2}(([02468][048])|([13579][26]))[\-\/\s]?((((0?[13578])|(1[02]))[\-\/\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\-\/\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\-\/\s]?((0?[1-9])|([1-2][0-9])))))|(\d{2}(([02468][1235679])|([13579][01345789]))[\-\/\s]?((((0?[13578])|(1[02]))[\-\/\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\-\/\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\-\/\s]?((0?[1-9])|(1[0-9])|(2[0-8]))))))(\s(((0?[0-9])|([1-2][0-3]))\:([0-5]?[0-9])))?$/;
    return dateExp.test(value);
  };
  $.fn.form.settings.rules.file = function(){
    console.log('file');
    return $(this).val();
  };
  $(function(){
    var dateTimePicker, uploadBtn, updateBtn, filePathBlock, hwModal, identityBtn, identityInput, loginForm, loginBtn, registerBtn, username, password, signupSubmitBtn, assignFormSubmitBtn, assignForm, uploadForm, homeworkSubmitBtn, datetimeinput, modalFormSubmitBtn, modalForm, deadlineDate, scoreForm, updateAssignmentBtn;
    dateTimePicker = $('#datetimepicker');
    uploadBtn = $('.myhw-upload');
    updateBtn = $('.update-deadline');
    filePathBlock = $('.file-path');
    hwModal = $('.modal');
    dateTimePicker.datetimepicker({
      lang: 'ch'
    });
    uploadBtn.on('change', function(){
      filePathBlock.val($(this).val());
    });
    updateBtn.on('click', function(){
      console.log('hehe');
      hwModal.modal('show');
    });
    identityBtn = $('.myhw-identity .button');
    identityInput = $('#identity');
    identityBtn.on('click', function(){
      var thisBtn, valu;
      thisBtn = $(this);
      identityBtn.removeClass('positive');
      thisBtn.addClass('positive');
      valu = thisBtn.attr('id') === 'student' ? 0 : 1;
      identityInput.val(valu);
    });
    loginForm = $('#login-form');
    loginBtn = $('.login-btn');
    registerBtn = $('.myhw-register');
    username = $('[name="username"]');
    password = $('[name="password"]');
    loginForm.form({
      username: {
        identifier: 'username',
        rules: [{
          type: 'empty',
          prompt: '请输入用户名'
        }]
      },
      password: {
        identifier: 'password',
        rules: [{
          type: 'empty',
          prompt: '请输入密码'
        }]
      }
    }, {
      inline: true,
      on: 'blur'
    });
    $('.myhw-register-form').form({
      username: {
        identifier: 'username',
        rules: [{
          type: 'empty',
          prompt: '请输入用户名'
        }]
      },
      password: {
        identifier: 'password',
        rules: [{
          type: 'empty',
          prompt: '请输入密码'
        }]
      },
      name: {
        identifier: 'name',
        rules: [{
          type: 'empty',
          prompt: '请输入密码'
        }]
      },
      email: {
        identifier: 'email',
        rules: [{
          type: 'email',
          prompt: '请输入合法的电邮'
        }]
      }
    }, {
      inline: true,
      on: 'blur'
    });
    loginBtn.on('click', function(){
      if (username.val() && password.val()) {
        loginForm.submit();
      }
    });
    registerBtn.on('click', function(){
      window.location = '/signup';
    });
    signupSubmitBtn = $('#myhw-submit');
    signupSubmitBtn.on('click', function(){
      $('.myhw-register-form').submit();
    });
    assignFormSubmitBtn = $('.assign-form-submit');
    assignForm = $('.assign-form');
    assignForm.form({
      title: {
        identifier: 'title',
        rules: [{
          type: 'empty',
          prompt: '请输入标题'
        }]
      },
      deadline: {
        identifier: 'deadline',
        rules: [{
          type: 'date',
          prompt: '请输入截止日期'
        }]
      },
      description: {
        identifier: 'description',
        rules: [{
          type: 'empty',
          prompt: '请输入描述'
        }]
      }
    });
    assignFormSubmitBtn.on('click', function(){
      assignForm.submit();
    });
    uploadForm = $('.upload-homework-form');
    homeworkSubmitBtn = $('.homework-submit-btn');
    uploadForm.form({
      title: {
        identifier: 'homework',
        rules: [{
          type: 'file',
          prompt: '请先上传文件'
        }]
      }
    }, {
      inline: true,
      on: 'blur'
    });
    homeworkSubmitBtn.on('click', function(){
      uploadForm.submit();
    });
    datetimeinput = $('.modal #datetimepicker');
    modalFormSubmitBtn = $('.modal-form-submit');
    modalForm = $('.modal-form');
    deadlineDate = $('.deadline-date');
    modalFormSubmitBtn.on('click', function(){
      $.post('/modify', modalForm.serialize(), function(data){
        if (data === '1') {
          console.log('error');
        } else {
          deadlineDate.text(data);
        }
      });
    });
    scoreForm = $('.score-form');
    scoreForm.on('submit', function(e){
      var thisForm, scoreInput, valu;
      e.preventDefault();
      thisForm = $(this);
      scoreInput = thisForm.find('.score-input');
      valu = scoreInput.val();
      console.log(valu);
      if (!valu) {
        return;
      }
      $.post('/score', thisForm.serialize(), function(data){
        scoreInput.val(valu);
      });
    });
    updateAssignmentBtn = $('.update-assignment');
    updateAssignmentBtn.on('click', function(){
      window.location = $(this).attr('data-href');
    });
  });
}).call(this);
