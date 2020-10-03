extends Stmt
class_name Var

var name: Token
var initializer: Expr

func _init(name: Token, initializer: Expr):
	self.name = name
	self.initializer = initializer

func accept(visitor):
	return visitor.visit_var_stmt(self)