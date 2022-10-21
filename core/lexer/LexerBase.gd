class_name LexerBase



var source := ''
var tokens := []

var start_position := 0
var current_position := 0
var line := 1



func do(_source):
	
	source = _source
	
	scan_tokens()
	
	return tokens



func scan_tokens():
	
	while not is_at_end():
		
		fresh_start_position()
		scan_token()
	
	
	# end token
	add_token(Token.new(TokenType.EOF, "", null, line))





func scan_token() -> void:
	
	var c = advance()
	
	if find_lex(c): return
	
	ErrorHandler.error(line, "[%s]: Unexpected character." % c)




func get_actions() -> Array:
	return []

func find_lex(letter) -> bool:
	
	for action in get_actions():
		#var action : LexerActionBase = a as LexerActionBase
		
		if action.check(letter):
			action.lex(self, letter)
			return true
		
	
	return false











# move forward
# get char
func advance() -> String :
	current_position += 1
	
	return source[current_position - 1]

func is_at_end() -> bool:
	return current_position >= len(source)


func is_digit(letter) -> bool:
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
	
	return source[current_position]

func peek_next():
	if current_position + 1 >= len(source):
		return '\\0'
	
	return source[current_position + 1]


func match(expected) -> bool:
	if is_at_end():
		 return false
	
	if source[current_position] != expected:
		return false
	
	current_position += 1
	return true   





func fresh_start_position():
	start_position = current_position

func substr(from = start_position, to = current_position):
	return source.substr(from, to - from)

func selected_text():
	return substr()

func selected_string():
	return substr(start_position + 1, current_position - 1)


func next_line():
	line += 1

func add_token(token: Token):
	tokens.append(token)

func add_token_type(type):
	add_token(Token.new(type, null))

func add_token_literal(type, literal):
	add_token(Token.new(type, selected_text(), literal, line))        
