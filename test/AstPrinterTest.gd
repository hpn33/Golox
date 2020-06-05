extends Node


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
	
	
	
	$TextEdit.text = AstPrinter.new().ast_print(expression)
#	print(ast_print(expression));
	
