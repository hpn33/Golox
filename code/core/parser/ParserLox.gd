extends ParserBase
class_name ParserLox





func parse() -> Array:
	
	var statements := []
	
	while not is_at_end():
		statements.append(declaration())
	
	return statements







func expression():
	return assignment()


func assignment() -> Expr:
	var expr = orF()
	
	if match([TokenType.EQUAL]):
		var equals = previous()
		var value = assignment()
	
		if expr is Variable:
			var name = (expr as Variable).name
			
			return Assign.new(name, value)
#			return Assign.new(name, value)
		
		return error(equals, "Invalid assignment target.")
	
	return expr

func orF() -> Expr:
	var expr = andF()
	
	while match([TokenType.OR]):
	  var operator = previous()
	  var right = andF()
	  expr = Logical.new(expr, operator, right)
	
	return expr


func andF() -> Expr:
	var expr = equality()
	
	while match([TokenType.AND]):
	  var operator = previous()
	  var right = equality()
	  expr = Logical.new(expr, operator, right)
	
	
	return expr


func declaration():
	
	if match([TokenType.VAR]):
		return var_declaration()
	
	return statement()
	
	synchronize()
	return null


func statement() -> Stmt:
	
	if match([TokenType.FOR]):
		return for_statement()
	
	if match([TokenType.IF]):
		return if_statement()
	
	if match([TokenType.PRINT]):
		return print_statement()
	
	if match([TokenType.WHILE]):
		return while_statement()
	
	if match([TokenType.LEFT_BRACE]):
		return Block.new(block())
	
	return expression_statement()


func for_statement() -> Stmt:
	if not consume(TokenType.LEFT_PAREN, "Expect '(' after 'for'."):
		return null
	
	var initializer
	if match([TokenType.SEMICOLON]):
		initializer = null
	elif match([TokenType.VAR]):
		initializer = var_declaration()
	else:
		initializer = expression_statement()
	
	var condition = null
	if not check(TokenType.SEMICOLON):
		condition = expression()
	
	if not consume(TokenType.SEMICOLON, "Expect ';' after loop condition."):
		return null
	
	var increment = null
	if not check(TokenType.RIGHT_PAREN):
		increment = expression()
	
	if not consume(TokenType.RIGHT_PAREN, "Expect ')' after for clauses."):
		return null
	
	var body = statement()
	
	if increment:
		body = Block.new([body, ExpressionL.new(increment)])
	
	if not condition:
		condition = Literal.new(true)
	body = While.new(condition, body)
	
	if initializer:
		body = Block.new([initializer, body])
	
	return body


func if_statement() -> Stmt:
	if not consume(TokenType.LEFT_PAREN, "Expect '(' after 'if'."):
		return null
	
	var condition = expression();
	if not consume(TokenType.RIGHT_PAREN, "Expect ')' after if condition."):
		return null
	
	var thenBranch = statement();
	var elseBranch = null;
	if match([TokenType.ELSE]):
		elseBranch = statement();
	
	return If.new(condition, thenBranch, elseBranch)


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


func while_statement():
	if not consume(TokenType.LEFT_PAREN, "Expect '(' after 'while'."):
		return null
	
	var condition = expression()
	if not consume(TokenType.RIGHT_PAREN, "Expect ')' after condition."):
		return null
	
	var body = statement()
	return While.new(condition, body)


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



