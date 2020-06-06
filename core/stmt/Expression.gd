extends Stmt
class_name Expression

var expression

func _init(expression):
	self.expression = expression

func accept(visitor):
	return visitor.visit_expression_stmt(self)
