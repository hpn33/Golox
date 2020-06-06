extends Expr
class_name Unary

var operator
var right

func _init(operator, right):
	self.operator = operator
	self.right = right

func accept(visitor):
	return visitor.visit_unary_expr(self)