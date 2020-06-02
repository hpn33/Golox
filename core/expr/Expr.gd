extends Object

class Expr:
	
	func _init():
		pass



class Binary:
	extends Expr
	
	var left: Expr
	var operator
	var right: Expr
	
	func _init(_left, _operator, _right):
		left = _left
		operator = _operator
		right = _right

class Grouping:
	extends Expr
	
	var expression: Expr
	
	func _init(_expression):
		expression = _expression


class Literal:
	extends Expr
	
	var value
	
	func _init(_value):
		value = _value

class Unary:
	extends Expr
	
	var operator
	var right: Expr
	
	func _init(_operator, _right):
		operator = _operator
		right = _right
