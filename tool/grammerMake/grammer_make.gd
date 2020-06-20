extends Node



func _ready():
	
	var tokens = LexerGen.new().do(open_file())
	
	var tree = ParserGen.new().do(tokens)
	

func open_file():
	
	var file := File.new()
	
	file.open("res://tool/grammerMake/lox.gd", File.READ)
	
	var text = file.get_as_text()
	
	file.close()
	
	return text


