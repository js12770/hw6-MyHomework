/**
 * Created by Kira on 4/11/15.
 */

var homeworkControllers = angular.module('homeworkControllers', []);

homeworkControllers.controller('homeworkController', ['$location', '$scope', function($location, $scope) {
    var homeworkController = {
        getAllHomeWork: function() {
            $.get('/main/allhomeworkInfo', function(data) {
                data = JSON.parse(data);
                console.log(data);
                if (data.type != 0) {
                    data = data.data;
                    for (var i = 0; i < data.length; i++) {
                        var insertData = "<tr>";
                        insertData += "<td>" + data[i].title + "</td>";
                        insertData += "<td>" + data[i].deadline + "</td>";
                        insertData += "<td>" + data[i].content + "</td>";
                        insertData += "<td>" + '<input type="button" value="查看详情">' + "</td>";
                        insertData += "</tr>";
                        $('tbody').append(insertData);
                        insertData = "<option>" + data[i].title + "</option>";
                        $('select').append(insertData);
                    }
                    homeworkController.checkIfUploaded();
                }
            });
        },
        postNewHomeWork: function() {
            $.post('/main/homework', {
                title: $($('input[type=text]')[0]).val(),
                deadline: $($('input[type=text]')[1]).val(),
                content: $($('input[type=text]')[2]).val()
            }, function(data) {
                data = JSON.parse(data);
                alert(data.message);
                if (data.type != 0) {
                    $location.path('/main/students');
                }
            });
        },
        checkIfUploaded: function(studentID) {
            var all = $('tbody').find('tr');
            for (var i = 0; i < all.length; i++) {
                var j = i;
                console.log($($(all[i]).find('td')[0]).html());
                $.post('/main/checkIfUploaded', {
                    title: $($(all[i]).find('td')[0]).html()
                }, function(data) {
                    data = JSON.parse(data);
                    console.log(data);
                    if (data.type) {
                        $($(all[j]).find('td')[3]).html("已提交");
                    } else {
                        $($(all[j]).find('td')[3]).html("未提交");
                    }
                });
            }
        }
    }
    homeworkController.getAllHomeWork();
    $('.submit-button3').click(function() {
        homeworkController.postNewHomeWork();
    });
    $scope.checkIfUploaded = function() {
        homeworkController.checkIfUploaded();
    }
}]);