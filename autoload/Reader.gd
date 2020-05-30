extends Node


var source := ''
var tokens := []

var start := 0
var current := 0
var line := 1


func init(input):
	
	source = input
	tokens.clear()


func advance():
	current += 1
	
	# print(self.source[self.current - 1])
	return source[current - 1]

func is_at_end():
	# print(self.current, ':', len(self.source))
	return current >= len(source)


func peek():
	if is_at_end():
		return '\\0'
	
	# print(self.source[self.current])
	return source[current]

func peek_next():
	if current + 1 >= len(source):
		return '\\0'
	
	return source[current + 1]


func match(expected) -> bool:
	if is_at_end():
		 return false;                         
	
	if source[current] != expected:
		return false
	
	current += 1
	return true   


func output():
	return str(tokens)

func fresh():
	start = current

func substr(from = start, to = current):
	return source.substr(from, to - from)

func selected_text():
	return substr()


func next_line():
	line += 1

func add_token(token: Token):
	tokens.append(token)

func add_token_type(type):
	add_token(Token.new(type, null))

func add_token_literal(type, literal):
	add_token(Token.new(type, selected_text(), literal, line))        
