Assignment = require './assignment'
User = require './user'

module.exports = !->
	now1 = new Date 2009, 2, 27, 23, 59, 59
	now2 = new Date 2015, 4, 30, 23, 59, 59
	now3 = new Date 2015, 11, 11, 11, 11, 11
	assignment = new Assignment {
		name: 'Lab1'
		demand: 'Write a Jade.',
		finishedstudent: [{'name': 'Student1', 'assignment': 'Student1-lab1'}, {'name': 'Student2', 'assignment': 'Student2-lab1'}],
		endtime: now1
	}
	assignment.save!
	assignment = new Assignment {
		name: 'Lab2'
		demand: 'Write a Sass',
		finishedstudent: [{'name': 'Student1', 'assignment': 'Student1-lab2'}, {'name': 'Student2', 'assignment': 'Student2-lab2'}],
		endtime: now2
	}
	assignment.save!
	assignment = new Assignment {
		name: 'Lab3'
		demand: 'Write a Livescript',
		finishedstudent: [{'name': 'Student1', 'assignment': 'Student1-lab3'}, {'name': 'Student2', 'assignment': 'Student2-lab3'}],
		endtime: now3
	}
	assignment.save!

	user = new User {
		type: 'Student',
		username: 'Student1',
		password: '$2a$10$.Ea1yh4ISMnYtqRLiM08ZeOshEIyQocQFycvK8tuTOWyV3zERlfqG' # 密码是12345
		email: 'Student1@qq.com'
		firstName: 'Student1'
		lastName: '1',
		finishedassignment: {'Lab1': 'Student1-lab1', 'Lab2': 'Student1-lab2', 'Lab3': 'Student1-lab3'},
		marks: {'Lab1': '95', 'Lab2': '85', 'Lab3': '75'}
	}
	user.save!
	user = new User {
		type: 'Student',
		username: 'Student2',
		password: '$2a$10$.Ea1yh4ISMnYtqRLiM08ZeOshEIyQocQFycvK8tuTOWyV3zERlfqG' # 密码是12345
		email: 'Student2@qq.com'
		firstName: 'Student2'
		lastName: '2',
		finishedassignment: {'Lab1': 'Student2-lab1', 'Lab2': 'Student2-lab2', 'Lab3': 'Student2-lab3'},
		marks: {'Lab1': '95', 'Lab2': '85', 'Lab3': '75'}
	}
	user.save!
	user = new User {
		type: 'Teacher',
		username: 'Teacher',
		password: '$2a$10$.Ea1yh4ISMnYtqRLiM08ZeOshEIyQocQFycvK8tuTOWyV3zERlfqG' # 密码是12345
		email: 'Teacher1@qq.com'
		firstName: 'Teacher'
		lastName: '1'
	}
	user.save!




