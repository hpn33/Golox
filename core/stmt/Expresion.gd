extends Stmt
class_name Expresion

var expression

func _init(expression):
	self.expression = expression

func accept(visitor):
	return visitor.visit_expresion_stmt(self)
