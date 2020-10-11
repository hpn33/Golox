class_name TextWriter

var text := ''
var level := 0

func add(_text = '') -> TextWriter:
	
	text += _text
	
	return self


func new_line(_text = '') -> TextWriter:
	
	return add('\n' + tabs() + _text)


func add_line(num: int = 1) -> TextWriter:
	
	var line = ''
	
	for i in num:
		line += '\n' + tabs()
	
	return add(line)


func add_level(num: int = 1) -> TextWriter:
	
	level += num
	
	return self


func sub_level(num: int = 1) -> TextWriter:
	
	level -= num
	
	return self


func tabs() -> String:
	var tabs := ''
	
	for i in level:
		tabs += '\t'
	
	return tabs


func done():
	pass


func clear():
	text = ''
	level = 0







