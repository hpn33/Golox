extends Expr
class_name Literal

var value

func _init(value):
	self.value = value

func accept(visitor):
	return visitor.visit_literal_expr(self)
