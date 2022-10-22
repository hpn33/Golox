extends Expr
class_name Assign

var name: Token
var value: Expr

func _init(name: Token, value: Expr):
	self.name = name
	self.value = value

func accept(visitor):
	return visitor.visit_assign_expr(self)