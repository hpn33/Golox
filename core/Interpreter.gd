class_name Interpreter



var environment = EnvironmentLox.new()


func interpret(statements):
	
	for statement in statements:
		
		execute(statement)



func execute(stmt: Stmt):
	stmt.accept(self)


func execute_block(statements: Array, _environment: EnvironmentLox):
	var previous = environment
	
	environment = _environment
	
	for statement in statements:
		execute(statement)
	
	environment = previous


func visit_block_stmt(stmt: Block):
	execute_block(stmt.statements, EnvironmentLox.new(environment))
	
	return null



func stringify(object):
	if not object:
		return "nil"
	
	# Hack. Work around Java adding ".0" to integer-valued doubles.
	if object is float:
		var text :String= str(object)
		
		if (text.ends_with(".0")):
			text = text.substr(0, text.length() - 2)
		
		return text
	
	return str(object)




func visit_literal_expr(expr):
	return expr.value


func visit_logical_expr(expr: Logical):
	var left = evaluate(expr.left)
	
	if (expr.operator.type == TokenType.OR):
		if is_truthy(left): return left
	else:
		if !is_truthy(left): return left
	
	return evaluate(expr.right)


func visit_binary_expr(expr):
	var left = evaluate(expr.left)
	var right = evaluate(expr.right)
	
	match expr.operator.type:
		
		TokenType.GREATER:
			check_number_operands(expr.operator, left, right)
			return float(left) > float(right) 
		
		TokenType.GREATER_EQUAL:
			check_number_operands(expr.operator, left, right)
			return float(left) >= float(right)
		
		TokenType.LESS:
			check_number_operands(expr.operator, left, right)
			return float(left) < float(right)
		
		TokenType.LESS_EQUAL:
			check_number_operands(expr.operator, left, right)
			return float(left) <= float(right)
		
		TokenType.MINUS:
			check_number_operands(expr.operator, left, right)
			return float(left) - float(right)
		
		TokenType.PLUS:
			if left is float and right is float:
				return float(left) + float(right)
			
			if left is String and right is String:
				return str(left) + str(right)
			
#			throw new RuntimeError(expr.operator, "Operands must be two numbers or two strings.");  
			ErrorHandler.runtime_token(expr.operator, "Operands must be two numbers or two strings.")
		
		TokenType.SLASH:
			return float(left) / float(right)
		
		TokenType.STAR:
			return float(left) * float(right)
		
		TokenType.BANG_EQUAL:
			return not is_equal(left, right)
		
		TokenType.EQUAL_EQUAL:
			return is_equal(left, right)
	
	# Unreachable.
	return null


func visit_grouping_expr(expr: Grouping):
	return evaluate(expr.expression)


func visit_unary_expr(expr):
	var right = evaluate(expr.right)
	
	match expr.operator.type:
		TokenType.BANG:
			return not is_truthy(right)
		
		TokenType.MINUS:
			check_number_operand(expr.operator, right)
			
			return -float(right)
		
		
	
	# Unreachable.
	return null



func visit_variable_expr(expr: Variable):
	return environment.Get(expr.name)



func evaluate(expr):
	if not expr:
		return null
	
	return expr.accept(self)


func visit_expressionl_stmt(stmt: ExpressionL):
	evaluate(stmt.expression)
	
	return null

func visit_if_stmt(stmt: If):
	if (is_truthy(evaluate(stmt.condition))):
		execute(stmt.thenBranch)
	elif (stmt.elseBranch != null):
		execute(stmt.elseBranch)
	
	return null


func visit_print_stmt(stmt: Print):
	var value = evaluate(stmt.expression)
	
	print(stringify(value))
	
	return null


func visit_var_stmt(stmt: Var):
	var value = null
	if stmt.initializer:
		value = evaluate(stmt.initializer)
	
	environment.define(stmt.name.lexeme, value)
	return null


func visit_while_stmt(stmt: While):
	while is_truthy(evaluate(stmt.condition)):
		execute(stmt.body)
	
	return null


func visit_assign_expr(expr: Assign):
	var value = evaluate(expr.value)
	
	environment.assign(expr.name, value)
	return value





func is_truthy(object):
	if not object:
		return false
	
	if object is bool:
		return bool(object)
	
	return true



func is_equal(a, b):
	# nil is only equal to nil.
	if not a and not b:
		return true
	
	if not a:
		return false
	
#	return a.equals(b)
	return a == b




func check_number_operand(operator: Token, operand):
	
	if operand is float:
		return
	
#	throw new RuntimeError(operator, "Operand must be a number.")
	ErrorHandler.runtime_token(operator, "Operand must be a number.")



func check_number_operands(operator: Token, left, right):
	if left is float and right is float:
		return
	
#	throw new RuntimeError(operator, "Operands must be numbers.");
	ErrorHandler.runtime_token(operator, "Operands must be numbers.")




