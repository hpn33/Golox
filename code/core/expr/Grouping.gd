extends Expr
class_name Grouping

var expression: Expr

func _init(expression: Expr):
	self.expression = expression

func accept(visitor):
	return visitor.visit_grouping_expr(self)