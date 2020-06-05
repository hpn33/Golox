class_name Literal

var value

func _init(_value):
	value = _value

func accept(visitor):
	return visitor.visit_literal_expr(self)
