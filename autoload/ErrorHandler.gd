extends Node


signal exporting(errors)

var errors := []
var had_error := false
var had_runtime_error := false


func error(line: int, message: String):
	report(line, "", message)


func report(line: int, where: String, message: String):
	
	errors.append("[line %d] Error%s: %s" % [line, where, message])
	
	had_error = true
	show_error()


func error_token(token: Token, message: String):
	
	if token.type == TokenType.EOF:
		report(token.line, " at end", message)
	
	else:
		report(token.line, " at '%s'" % token.lexeme, message)


func runtime_token(token: Token, message: String):
	
	errors.append("%s\n[line %d]" % [message, token.line])
	
	had_runtime_error = true
	show_error()


func show_error():
	
	emit_signal("exporting", errors)
#	clear()

func clear():
	
	errors.clear()
	had_error = false
	had_runtime_error = false

