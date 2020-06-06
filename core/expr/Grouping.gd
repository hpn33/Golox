extends Expr
class_name Grouping

var expression

func _init(expression):
	self.expression = expression

func accept(visitor):
	return visitor.visit_grouping_expr(self)
