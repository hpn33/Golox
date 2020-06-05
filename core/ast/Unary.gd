class_name Unary

var operator
var right

func _init(_operator, _right):
	operator = _operator
	right = _right

func accept(visitor):
	return visitor.visit_unary_expr(self)
