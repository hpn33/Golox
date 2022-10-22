extends Stmt
class_name While

var condition: Expr
var body: Stmt

func _init(condition: Expr, body: Stmt):
	self.condition = condition
	self.body = body

func accept(visitor):
	return visitor.visit_while_stmt(self)