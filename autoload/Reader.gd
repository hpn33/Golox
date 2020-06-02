extends Node


var source := ''
var tokens := []

var start := 0
var current := 0
var line := 1


func init(input):
	
	start = 0
	current = 0
	line = 1
	source = input
	tokens.clear()


func advance():
	current += 1
	
	return source[current - 1]

func is_at_end():
	return current >= len(source)


func is_digit(letter):
	return '0' <= letter && letter <= '9'


func is_alpha(letter):
	return ('a' <= letter and letter <= 'z')\
		or ('A' <= letter and letter <= 'Z')\
		or letter == '_'

func is_alpha_numeric(letter):
	return is_alpha(letter) || is_digit(letter)




func peek():
	if is_at_end():
		return '\\0'
	
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
	
	
	var s := ''
	
	for tok in tokens:
		s += str(tok) + '\n'
	
	return s


func fresh():
	start = current

func substr(from = start, to = current):
	return source.substr(from, to - from)

func selected_text():
	return substr()

func selected_string():
	return substr(start+1, current - 1)


func next_line():
	line += 1

func add_token(token: Token):
	tokens.append(token)

func add_token_type(type):
	add_token(Token.new(type, null))

func add_token_literal(type, literal):
	add_token(Token.new(type, selected_text(), literal, line))        
