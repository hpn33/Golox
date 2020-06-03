class_name Binary

var left
var operator
var right

func _init(left, operator, right):
	self.left = left
	self.operator = operator
	self.right = right

func accept(visitor):
	return visitor.visit_binary_expr(self)
