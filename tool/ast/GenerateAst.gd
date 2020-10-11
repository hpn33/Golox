tool
extends Node


var expr_struc := {
	"Assign": { 'name': 'Token', 'value': 'Expr' },
	'Binary': {
		'left': 'Expr',
		'operator': 'Token',
		'right': 'Expr'
	},
	'Grouping': { 'expression': 'Expr' },
	'Literal': { 'value': '' },
	"Logical"  : { 'left': 'Expr', 'operator': 'Token', 'right': 'Expr'},
	'Unary': {
		'operator': 'Token',
		'right': 'Expr' 
	},
	'Variable': { 'name': 'Token' } 
}

var stmt_struc := {
	"Block": { "statements": 'Array' },
	"ExpressionL": { 'expression': 'Expr' },
	'If': {'condition': 'Expr', 'thenBranch': 'Stmt', 'elseBranch': 'Stmt' },
	'Print' : { 'expression': 'Expr'},
	'Var': { 
		'name': 'Token',
		'initializer': 'Expr'
	},
	"While" : { 'condition': 'Expr', 'body': 'Stmt'}
}


var root := 'res://core/'
var expr_path := root + 'expr/'
var stmt_path := root + 'stmt/'

var path := ''


func _ready():
	generate()


#export(bool) var generate = false setget set_generate
#
#func set_generate(value):
#	generate()

func generate():
	
	path = expr_path
	define_ast("Expr", expr_struc)
	
	path = stmt_path
	define_ast("Stmt", stmt_struc)


func define_ast(base_name: String, types: Dictionary):
	
	var file = FileBuilder.new()
	
	file.setClassName(base_name).done()
	
	define_visitor(file, base_name, types)
	
	
	
	# The base accept() method.
	var fun = FuncBuilder.new()
	fun.setName('accept')\
		.setArg('visitor')\
		.setPass()\
		.spaceTop()\
		.spaceBottom()\
		.done()
	
	file.addFunc(fun).done()
	
	create_file(base_name + '.gd' , file)
	
	# The AST classes.
	for clas_name in types.keys():
		
		define_type(base_name, clas_name, types[clas_name])
	


func create_file(_file_name, fileBuilder: FileBuilder):
	
	var iou := IOUtil.new()
	
	iou.be(path)
	
	if not iou.file_exists(_file_name):
		iou.make_file(_file_name)
	
	var file = iou.open_file(_file_name)
	
	file.store_string(fileBuilder.build())
	file = ''
	iou.close_file()
	
	fileBuilder.clear()


func define_visitor(fileBuilder: FileBuilder, base_name: String, types: Dictionary):
	
	for type_name in types.keys():
		var fun = FuncBuilder.new()
		
		
		fun.setName('visit_%s_%s' % [type_name.to_lower(), base_name.to_lower()])\
			.setArg(base_name.to_lower())\
			.done()
		
		
		fileBuilder.addFunc(fun).done()
		
	


func define_type(base_name: String, clas_name: String, field_list: Dictionary):
	
	var file = FileBuilder.new()
	
	file.setExtends(base_name)\
		.setClassName(clas_name)\
		.done()
	
	
	var vars := []
	# Fields.
	for i in field_list.size():
		
		var key = field_list.keys()[i]
		var type = field_list[key]
		
		
		var varing = VarBuilder.new()
		varing.setName(key).done()
		if type != '':
			varing.setType(type).done()
		
		
		file.addVar(varing).done()
		
		
		var variable = key
		if type != '':
			variable += ': %s' % type
		
		vars.append(variable + (', 'if i != field_list.size()-1 else ''))
	
	
	# Constructor.
	var construcFunc = FuncBuilder.new()
	construcFunc.setName('_init')\
		.setArgs(vars)\
		.done()
	
	# Store parameters in fields.
	for key in field_list.keys():
		
		var setVar = SetVarBuilder.new()
		setVar.setRightLeft("self.%s" % [key], key).done()
		
		construcFunc.addToBody(setVar).done()
	
	file.setConstructor(construcFunc).done()
	
	
	# Visitor pattern.
	var acceptFunc = FuncBuilder.new()
	acceptFunc.setName('accept')\
		.setArg('visitor')\
		.addToBody("return visitor.visit_%s_%s(self)" % [clas_name.to_lower(), base_name.to_lower()])\
		.done()
	
	file.addFunc(acceptFunc).done()
	
	
	create_file(clas_name + '.gd', file)
	


