extends Node


var tokens := []
var current := 0

func do():
	
	tokens = Reader.tokens
	current = 0
	
	return expression()





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



