$.fn.form.settings.rules.date = (value)->
    date-exp = //
        ^((\d{2}(([02468][048])|([13579][26]))[\-\/\s]?((((0?[13578]
        )|(1[02]))[\-\/\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[4
        69])|(11))[\-\/\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\-\/\
        s]?((0?[1-9])|([1-2][0-9])))))|(\d{2}(([02468][1235679])|([1
        3579][01345789]))[\-\/\s]?((((0?[13578])|(1[02]))[\-\/\s]?((
        0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\-\/\s]?((
        0?[1-9])|([1-2][0-9])|(30)))|(0?2[\-\/\s]?((0?[1-9])|(1[0-9]
        )|(2[0-8]))))))(\s(((0?[0-9])|([1-2][0-3]))\:([0-5]?[0-9])))?$
    //
    return date-exp.test(value);

$.fn.form.settings.rules.file = ->
    console.log 'file'
    return $ @ .val!

<-! $

date-time-picker = $ '#datetimepicker'
upload-btn = $ '.myhw-upload'
update-btn = $ '.update-deadline'
file-path-block = $ '.file-path'
hw-modal = $ '.modal'

date-time-picker.datetimepicker lang: 'ch'
upload-btn.on 'change', !-> file-path-block.val ($ @).val!
update-btn.on 'click', !->
    console.log 'hehe'
    hw-modal.modal 'show'

identity-btn = $ '.myhw-identity .button'
identity-input = $ '#identity'

identity-btn.on 'click', !->
    this-btn = $ @
    identity-btn.remove-class 'positive'
    this-btn.add-class 'positive'
    valu = if this-btn.attr('id') is 'student' then 0 else 1
    identity-input.val valu


login-form = $ '#login-form'
login-btn = $ '.login-btn'
register-btn = $ '.myhw-register'
username = $ '[name="username"]'
password = $ '[name="password"]'

login-form.form {
    username: {
        identifier: 'username'
        rules: [
            {
                type: 'empty'
                prompt: '请输入用户名'
            }
        ]
    }
    password: {
        identifier: 'password'
        rules: [
            {
                type: 'empty'
                prompt: '请输入密码'
            }
        ]
    }
}, {
    inline: true
    on: 'blur'
}


$ '.myhw-register-form' .form {
    username: {
        identifier: 'username'
        rules: [
            {
                type: 'empty'
                prompt: '请输入用户名'
            }
        ]
    }
    password: {
        identifier: 'password'
        rules: [
            {
                type: 'empty'
                prompt: '请输入密码'
            }
        ]
    }
    name: {
        identifier: 'name'
        rules: [
            {
                type: 'empty'
                prompt: '请输入密码'
            }
        ]
    }
    email: {
        identifier: 'email'
        rules: [
            {
                type: 'email'
                prompt: '请输入合法的电邮'
            }
        ]
    }
}, {
    inline: true
    on: 'blur'
}
login-btn.on 'click', !-> if username.val! and password.val! then login-form.submit!

register-btn.on 'click', !-> window.location = '/signup'

signup-submit-btn = $ '#myhw-submit'
signup-submit-btn.on 'click', !-> $ '.myhw-register-form' .submit!

assign-form-submit-btn = $ '.assign-form-submit'
assign-form = $ '.assign-form'

assign-form.form {
    title: {
        identifier: 'title'
        rules: [
            {
                type: 'empty'
                prompt: '请输入标题'
            }
        ]
    }
    deadline: {
        identifier: 'deadline'
        rules: [
            {
                type: 'date'
                prompt: '请输入截止日期'
            }
        ]
    }
    description: {
        identifier: 'description'
        rules: [
            {
                type: 'empty'
                prompt: '请输入描述'
            }
        ]
    }
}



assign-form-submit-btn.on 'click', !-> assign-form.submit!

upload-form = $ '.upload-homework-form'
homework-submit-btn = $ '.homework-submit-btn'

upload-form.form {
    title: {
        identifier: 'homework'
        rules: [
            {
                type: 'file'
                prompt: '请先上传文件'
            }
        ]
    }
},{
    inline: true
    on: 'blur'
}

homework-submit-btn.on 'click', !-> upload-form.submit!

datetimeinput = $ '.modal #datetimepicker'
modal-form-submit-btn = $ '.modal-form-submit'
modal-form = $ '.modal-form'
deadline-date = $ '.deadline-date'

modal-form-submit-btn.on 'click', !->
    $.post '/modify', modal-form.serialize!, (data)!->
        if data is '1'
            console.log 'error'
        else
            deadline-date.text data

score-form = $ '.score-form'
score-form.on 'submit', (e) !->
    e.preventDefault!
    this-form = $ @
    score-input = this-form.find '.score-input'
    valu = score-input .val!
    console.log valu
    if not valu then return
    $.post '/score', this-form.serialize!, (data)!->
        score-input.val valu

update-assignment-btn = $ '.update-assignment'
update-assignment-btn.on 'click', !-> window.location = $(@).attr 'data-href'

