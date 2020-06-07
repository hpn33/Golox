extends Expr
class_name Unary

var operator: Token
var right: Expr

func _init(operator: Token, right: Expr):
	self.operator = operator
	self.right = right

func accept(visitor):
	return visitor.visit_unary_expr(self)