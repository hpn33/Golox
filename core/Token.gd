class_name Token

var type
var lexeme
var literal
var line: int

func _init(_type, _lexeme, _literal = null, _line: int = 0):
	type = _type
	lexeme = _lexeme
	literal = _literal
	line = _line

func _to_string():
	return "[%d \"%s\" {%s}]" % [type, lexeme, literal]

