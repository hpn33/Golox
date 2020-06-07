extends Stmt
class_name ExpressionL

var expression: Expr

func _init(expression: Expr):
	self.expression = expression

func accept(visitor):
	return visitor.visit_expressionl_stmt(self)
