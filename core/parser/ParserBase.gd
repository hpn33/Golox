class_name ParserBase



var tokens := []
var current := 0



func do(_tokens):
	
	tokens = _tokens
	
	return parse()


func parse() -> Array:
	return []



func is_at_end() -> bool:
	if typeof(peek().type) == typeof(TokenType.EOF):
		return peek().type == TokenType.EOF
	
	return false


func peek() -> Token:
	return tokens[current]


func previous() -> Token:
	return tokens[current - 1]



func match(types: Array) -> bool:
	
	for type in types:
		if check(type):
			advance()
			return true
	
	return false


func check(type) -> bool:
	
	if is_at_end():
		return false
	
	return peek().type == type


func advance() -> Token:
	
	if not is_at_end():
		current += 1
	
	return previous()


