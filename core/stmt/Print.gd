extends Stmt
class_name Print

var expression: Expr

func _init(expression: Expr):
	self.expression = expression

func accept(visitor):
	return visitor.visit_print_stmt(self)