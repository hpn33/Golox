extends Node


signal exporting(errors)

var errors := []
#var had_error := false


func error(_error):
	
	errors.append(_error)
#	had_error = true
	show_error()

func show_error():
	emit_signal("exporting", errors)
	
	clear()

func clear():
	
	errors.clear()

