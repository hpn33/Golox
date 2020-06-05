class_name Binary

var left
var operator
var right

func _init(_left, _operator, _right):
	left = _left
	operator = _operator
	right = _right

func accept(visitor):
	return visitor.visit_binary_expr(self)
