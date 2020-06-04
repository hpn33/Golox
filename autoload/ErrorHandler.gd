extends Node


signal exporting(errors)

var errors := []
var had_error := false


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
 

func show_error():
	
	emit_signal("exporting", errors)
	clear()

func clear():
	
	errors.clear()
	had_error = false

