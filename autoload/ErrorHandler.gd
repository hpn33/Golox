extends Node


signal async(errors)

var errors := []
var had_error := false


func error(_error):
	
	errors.append(_error)
	had_error = true


func clear():
	
	errors.clear()

