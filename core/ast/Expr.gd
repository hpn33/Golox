extends Object

class Expr:
	func _init(): pass

class Binary:
	extends Expr
	
	var left
	var operator: Token
	var right: Expr
	
	func _init(left, operator: Token, right: Expr):
		self.left = left
		self.operator = operator
		self.right = right


class Grouping:
	extends Expr
	
	var expression: Expr
	
	func _init(expression: Expr):
		self.expression = expression


class Literal:
	extends Expr
	
	var value
	
	func _init(value):
		self.value = value


class Unary:
	extends Expr
	
	var operator: Token
	var right: Expr
	
	func _init(operator: Token, right: Expr):
		self.operator = operator
		self.right = right

