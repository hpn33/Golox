extends Object


class Expr:
	
	func _init(): pass
	
	func visit_Binary_Expr(expr: Binary): pass
	func visit_Grouping_Expr(expr: Grouping): pass
	func visit_Literal_Expr(expr: Literal): pass
	func visit_Unary_Expr(expr: Unary): pass
	
	func accept(visitor): pass


class Binary:
	extends Expr
	
	var left: Expr
	var operator: Token
	var right: Expr
	
	func _init(left: Expr, operator: Token, right: Expr):
		self.left = left
		self.operator = operator
		self.right = right
	
	func accept(visitor):
		return visitor.visit_Binary_Expr(self)


class Grouping:
	extends Expr
	
	var expression: Expr
	
	func _init(expression: Expr):
		self.expression = expression
	
	func accept(visitor):
		return visitor.visit_Grouping_Expr(self)


class Literal:
	extends Expr
	
	var value
	
	func _init(value):
		self.value = value
	
	func accept(visitor):
		return visitor.visit_Literal_Expr(self)


class Unary:
	extends Expr
	
	var operator: Token
	var right: Expr
	
	func _init(operator: Token, right: Expr):
		self.operator = operator
		self.right = right
	
	func accept(visitor):
		return visitor.visit_Unary_Expr(self)

