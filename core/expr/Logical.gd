extends Expr
class_name Logical

var left: Expr
var operator: Token
var right: Expr

func _init(left: Expr, operator: Token, right: Expr):
	self.left = left
	self.operator = operator
	self.right = right

func accept(visitor):
	return visitor.visit_logical_expr(self)
