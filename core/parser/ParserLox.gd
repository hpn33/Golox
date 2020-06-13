extends ParserBase
class_name ParserLox





func parse() -> Array:
	
	var statements := []
	
	while not is_at_end():
		statements.append(declaration())
	
	return statements







func expression():
	return assignment()


func assignment():
	var expr = equality()
	
	if match([TokenType.EQUAL]):
		var equals = previous()
		var value = assignment()
	
		if expr is Variable:
			var name = (expr as Variable).name
			
			return Expr.new().Assign(name, value)
		
		return error(equals, "Invalid assignment target.")
	
	return expr


func declaration():
	
	if match([TokenType.VAR]):
		return var_declaration()
	
	return statement()
	
	synchronize()
	return null


func statement() -> Stmt:
	
	if match([TokenType.PRINT]):
		return print_statement()
	
	if match([TokenType.LEFT_BRACE]):
		return Block.new(block())
	
	return expression_statement()


func print_statement():
	var value = expression()
	
	if not consume(TokenType.SEMICOLON, "Expect ';' after value."):
		return null
	
	return Print.new(value)


func block():
	var statements = []
	
	while not check(TokenType.RIGHT_BRACE)\
		and not is_at_end():
		statements.append(declaration())
	
	if not consume(TokenType.RIGHT_BRACE, "Expect '}' after block."):
		return null
	
	return statements


func var_declaration():
	var name = consume(TokenType.IDENTIFIER, "Expect variable name.")
	
	if not name: 
		return null
	
	var initializer = null;                                     
	if match([TokenType.EQUAL]):
		initializer = expression()
	
	if not consume(TokenType.SEMICOLON, "Expect ';' after variable declaration."):
		return null
	
	return Var.new(name, initializer)


func expression_statement():
	var expr = expression()
	
	if not consume(TokenType.SEMICOLON, "Expect ';' after expression."):
		return null
	
	return ExpressionL.new(expr)


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
	
	if match([TokenType.IDENTIFIER]):
		return Variable.new(previous())
	
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



