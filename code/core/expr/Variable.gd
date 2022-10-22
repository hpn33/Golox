extends Expr
class_name Variable

var name: Token

func _init(name: Token):
	self.name = name

func accept(visitor):
	return visitor.visit_variable_expr(self)