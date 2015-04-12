require! {Homework:'../models/homework', 'bcrypt-nodejs', 'passport-local'}

module.exports = (name, requirement, deadline, done)!->
	homework = Homework.find-one {name: name}
	if homework
		console.log msg = "Homework: #{name} already exists"
  	else
  		new-homework = new Homework {
  			name: name
  			requirement: requirement
  			deadline: deadline
  			} 
  	new-homework.save (error)->
		if error
        			console.log "Error in saving homework: ", error
        			throw error
      		else
        			console.log "User registration success"
        			done null, new-homework 