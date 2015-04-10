/**
 * Created by Kira on 4/10/15.
 */

$(document).ready(function() {
    var registerInformation = $('#register-container').find('.input-text-area');
    var loginInformation = $('#login-container').find('.input-text-area');
    var tbodyArea = $('#list-container').find('tbody');
    var loginController = {
        register: function() {
            $.post('/safe/register', {
                studentID: $(registerInformation[0]).val(),
                password: $(registerInformation[1]).val(),
                name: $(registerInformation[2]).val(),
                sexprefer: $(registerInformation[3]).val(),
                group: $(registerInformation[4]).val(),
                phonenumber: $(registerInformation[5]).val(),
                email: $(registerInformation[6]).val()
            }, function(data) {
                data = JSON.parse(data);
                alert(data.message);
                if (data.type == 1) {
                    self.parent.location.replace('/login');
                }
            });
        },
        login: function() {
            $.post('/login', {
                studentID: $(loginInformation[0]).val(),
                password: $(loginInformation[1]).val()
            }, function(data) {
                data = JSON.parse(data);
                alert(data.message);
                if (data.type == 1) {
                    window.location.replace('/main');
                }
            });
        },
        getStudents: function() {
            $.get('/main/getAllStudents', function(data) {
                data = JSON.parse(data);
                if (data.length) {
                    for (var i = 0; i < data.length; i++) {
                        var insertData = "<tr>";
                        insertData += "<td>" + data[i].studentID + "</td>";
                        insertData += "<td>" + data[i].name + "</td>";
                        insertData += "<td>" + data[i].sexprefer + "</td>";
                        insertData += "<td>" + data[i].group + "</td>";
                        insertData += "<td>" + data[i].phonenumber + "</td>";
                        insertData += "<td>" + data[i].email + "</td>";
                        insertData += "</tr>"
                        tbodyArea.append(insertData);
                    }
                } else {
                    self.parent.location.replace('/login');
                }
            });
        },
        logout: function() {
            $.post('/logout', {}, function(data) {
                data = JSON.parse(data);
                alert(data.message);
                if (data.type == 1) {
                    window.location.replace('/login');
                }
            });
        }
    }
    $('#register-container').find('input[value="注 册"]').click(function() {
        loginController.register();
    });
    $('#password').find('input').bind('keypress', function(event) {
        if(event.keyCode == "13")
        {
            loginController.login();
        }
    });
    $('#username').find('input').bind('keypress', function(event) {
        if(event.keyCode == "13")
        {
            loginController.login();
        }
    });
    $('input[value="登 录"]').click(function() {
        loginController.login();
    });
    $('input[value="登 出"]').click(function() {
        loginController.logout();
    });

    if (window.location.pathname == "/main/students" && self.parent.location.pathname == "/main") {
        loginController.getStudents();
    }
});