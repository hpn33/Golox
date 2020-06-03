extends Node
class_name AstPrinter


func _ready():
	
	var expression = Binary.new(
			Unary.new(
				Token.new(TokenType.MINUS, "-", null, 1),
				Literal.new(123)
			),
			Token.new(TokenType.STAR, "*", null, 1),           
			Grouping.new(                                 
				Literal.new(45.67)
			))
	
	$TextEdit.text = ast_print(expression)
#	print(ast_print(expression));
	

func ast_print(expr):
	return expr.accept(self)



func visit_binary_expr(expr):
	return parenthesize(expr.operator.lexeme, [expr.left, expr.right])


func visit_grouping_expr(expr):
	return parenthesize("group", [expr.expression])


func visit_literal_expr(expr):
	
	if expr.value == null: 
		return "nil"
	
	return str(expr.value)


func visit_unary_expr(expr):
	return parenthesize(expr.operator.lexeme, [expr.right])



func parenthesize(nam: String, exprs):
	
	var text := ''
	
	text += '('
	
	var es := []
	for expr in exprs:
		es.append(expr.accept(self))
	
	if es.size() == 2:
		text += es[0] + ' ' + nam + ' ' + es[1]
	
	else:
		text += nam + ' ' + es[0]
	
	text += ")"
	
	return text


#func parenthesize(nam: String, exprs):
#
#	var text := ''
#
#	text += '(' + name
#
#	for expr in exprs:
#		text += ' ' + expr.accept(self)
#
#	text += ")"
#
#	return text
