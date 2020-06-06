extends Stmt
class_name Print

var expression

func _init(expression):
	self.expression = expression

func accept(visitor):
	return visitor.visit_print_stmt(self)
