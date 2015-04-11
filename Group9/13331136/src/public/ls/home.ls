LiveScript = require "LiveScript"
LiveScript.go()

require! {User:'../models/user', "../models/requirement", 'bcrypt-nodejs', 'passport-local'}

addRequirement = (username) !->
	# console.log document.getElementById(add-requirement).value()
	new-requirement = new Requirement {
	  username  : $ 
	}