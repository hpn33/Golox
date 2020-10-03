extends Stmt
class_name If

var condition: Expr
var thenBranch: Stmt
var elseBranch: Stmt

func _init(condition: Expr, thenBranch: Stmt, elseBranch: Stmt):
	self.condition = condition
	self.thenBranch = thenBranch
	self.elseBranch = elseBranch

func accept(visitor):
	return visitor.visit_if_stmt(self)