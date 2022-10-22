extends Stmt
class_name Block

var statements: Array

func _init(statements: Array):
	self.statements = statements

func accept(visitor):
	return visitor.visit_block_stmt(self)