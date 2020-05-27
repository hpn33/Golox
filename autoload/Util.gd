extends Node

var debug := true
var levels := {
	normal = true,
	lexer = false,
	lexer_p = false,
	parser = true,
	info= false
}

var output := ''

func p(text:String, level := 'normal'):
	
	if levels[level]:
		
		output += text + '\n'
		
		if debug:
			print(text)

func info(text:String):
	p(text, 'info')

func lexer_p(text:String):
	p(text, 'lexer_p')

func parser(text:String):
	p(text, 'parser')







func text_to_letter_array(text:String) -> PoolStringArray:
	var letter_array := PoolStringArray()
	
	for let in text:
		letter_array.append(let)
	
	return letter_array





var keywords := ['print', 'var']
var symbols := ['\'', '=', '\n']
var white_space := ' '
var words = keywords + symbols

class Token:
	var text
	var type
	
	func _init(text, type = '') -> void:
		self.text = text
		self.type = type
