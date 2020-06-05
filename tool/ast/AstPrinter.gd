extends Expr
class_name AstPrinter



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
		
		if not expr:
			return 'error'
		
		es.append(expr.accept(self))
	
	if es.size() == 1:
		text += nam + ' ' + es[0]
	
	elif es.size() == 2:
		text += es[0] + ' ' + nam + ' ' + es[1]
	
	else:
		text += '(' + nam
		for expr in exprs:
			text += ' ' + expr.accept(self)
	
	text += ")"
	
	return text


#func parenthesize(nam: String, exprs):
#
#	var text := ''
#
#	text += '(' + nam
#
#	for expr in exprs:
#		text += ' ' + expr.accept(self)
#
#	text += ")"
#
#	return text
