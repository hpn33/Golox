class_name Parser


var tokens := []
var current := 0

func do(_tokens):
	
	tokens = _tokens
	
	return parse()


func parse() -> Array:
	
	var statements := []
	while not is_at_end():
		statements.append(statement())
	
	return statements



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


func is_at_end() -> bool:
	return peek().type == TokenType.EOF


func peek() -> Token:
	return tokens[current]


func previous() -> Token:
	return tokens[current - 1]





func expression():
	return equality()


func statement() -> Stmt:
	
	if match([TokenType.PRINT]):
		return print_statement()
	
	return expression_statement()


func print_statement():
	var value = expression()
	
	if not consume(TokenType.SEMICOLON, "Expect ';' after value."):
		return null
	
	return Print.new(value)


func expression_statement():
	var expr = expression()
	
	if not consume(TokenType.SEMICOLON, "Expect ';' after expression."):
		return null
	
	return Expresion.new(expr)


func equality():
	var expr = comparison()
	
	while match([TokenType.BANG_EQUAL, TokenType.EQUAL_EQUAL]):
		var operator = previous()
		var right = comparison()
		expr = Binary.new(expr, operator, right)
	
	return expr



func comparison() -> Expr:
	var expr = addition()
	
	while match([TokenType.GREATER, TokenType.GREATER_EQUAL, TokenType.LESS, TokenType.LESS_EQUAL]):
		var operator = previous()
		var right = addition()
		expr = Binary.new(expr, operator, right)
	
	return expr;                                             


func addition() -> Expr:
	var expr = multiplication()
	
	while match([TokenType.MINUS, TokenType.PLUS]):
		var operator = previous()
		var right = multiplication()
		expr = Binary.new(expr, operator, right)
	
	return expr


func multiplication() -> Expr:
	var expr = unary()
	
	while match([TokenType.SLASH, TokenType.STAR]):
		var operator = previous()
		var right = unary()
		expr = Binary.new(expr, operator, right)
	
	return expr


func unary():
	if match([TokenType.BANG, TokenType.MINUS]):
		var operator = previous()
		var right = unary()
		return Unary.new(operator, right)
	
	return primary()


func primary():
	if match([TokenType.FALSE]):
		return Literal.new(false)
	
	if match([TokenType.TRUE]):
		return Literal.new(true)
	
	if match([TokenType.NIL]):
		return Literal.new(null)
	
	if match([TokenType.NUMBER, TokenType.STRING]):
		return Literal.new(previous().literal)
	
	if match([TokenType.LEFT_PAREN]):
		var expr = expression()
		
		if not consume(TokenType.RIGHT_PAREN, "Expect ')' after expression."):
			return null
		
		return Grouping.new(expr)
	
	return error(peek(), 'Except expression.')


func consume(type, message: String):
	if check(type):
		return advance()
	
	return error(peek(), message)


func error(token: Token, message: String):
	ErrorHandler.error_token(token, message)
	
	return null

func synchronize():
	advance()
	
	while not is_at_end():
		if previous().type == TokenType.SEMICOLON:
			return
		
		if peek().type in [
			TokenType.CLASS, 
			TokenType.FUN,
			TokenType.VAR,
			TokenType.FOR,
			TokenType.IF,
			TokenType.WHILE,
			TokenType.PRINT,
			TokenType.RETURN]:
			return
		
		advance()



