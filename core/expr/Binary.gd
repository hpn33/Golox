extends Expr
class_name Binary

var left: Expr
var operator: Token
var right: Expr

func _init(left: Expr, operator: Token, right: Expr):
	self.left = left
	self.operator = operator
	self.right = right

func accept(visitor):
	return visitor.visit_binary_expr(self)