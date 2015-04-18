/**
 * Created by Kira on 4/18/15.
 */

var filesystem = angular.module('myHomework', [
    'ngResource',
    'ngRoute',
    'ngCookies',
    'homeworkControllers'
]);

filesystem.config(['$routeProvider', function($routeProvider) {
    $routeProvider
        .when('/', {
            redirectTo: '/login'
        })
        .when('/main', {
            templateUrl: '/views/main.html'
        })
        .when('/login', {
            templateUrl: '/views/login.html'
        })
        .when('/main/students', {
            templateUrl: '/views/studentList.html'
        })
        .when('/main/upload', {
            templateUrl: '/views/uploader.html'
        })
        .when('/main/allhomework', {
            templateUrl: '/views/allhomework.html'
        })
        .when('/main/status', {
            templateUrl: '/views/status.html'
        })
        .when('/main/submitHW', {
            templateUrl: '/views/submitHW.html'
        })
        .when('/main/homework', {
            templateUrl: '/views/homework.html'
        })
        .when('/safe', {
            templateUrl: '/views/safe.html'
        })
        .when('/safe/register', {
            templateUrl: '/views/register.html'
        })
        .when('/safe/returnPW', {
            templateUrl: '/views/returnPW.html'
        })
        .otherwise({
            redirectTo: '404'
        })
}]);