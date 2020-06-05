class_name Grouping

var expression

func _init(_expression):
	expression = _expression

func accept(visitor):
	return visitor.visit_grouping_expr(self)
