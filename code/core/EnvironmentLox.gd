class_name EnvironmentLox


var values := {}

var enclosing

func _init(_enclosing: EnvironmentLox = null):
	enclosing = _enclosing



func define(name: String, value):
	values[name] = value


func Get(name: Token):
	if values.has(name.lexeme):
		return values[name.lexeme]
	
	if enclosing:
		return enclosing.Get(name)
	
	ErrorHandler.runtime_token(name, "Undefined variable '%s'." % name.lexeme)
	return null


func assign(name: Token, value):
	if values.has(name.lexeme):
		values[name.lexeme] = value
		return
	
	if enclosing:
		enclosing.assign(name, value)
		return
	
	ErrorHandler.runtime_token(name, "Undefined variable '%s'." % name.lexeme)
	return null





