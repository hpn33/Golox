extends Node


var expr_struc := {
	'Binary': {
		'left': 'Expr',
		'operator': 'Token',
		'right': 'Expr'
	},
	'Grouping': {
		'expression': 'Expr'
	},
	'Literal': {
		'value': 'Object'
	},
	'Unary': {
		'operator': 'Token',
		'right': 'Expr' 
	}
}

var stmt_struc := {
	"Expresion": { 'expression': 'Expr' },
	'Print' : { 'expression': 'Expr'}
}


var root := 'res://core/'
var expr_path := root + 'expr/'
var stmt_path := root + 'stmt/'

var path := ''

func _ready():
	
	path = expr_path
	define_ast("Expr", expr_struc)
	
	path = stmt_path
	define_ast("Stmt", stmt_struc)


func define_ast(base_name: String, types: Dictionary):

	var writer := TextWriter.new()
	
	writer.add('class_name ' + base_name)\
		.add_line()\
		.done()
	
	define_visitor(writer, base_name, types)
	
	
	# The base accept() method.
	writer.add_line()\
		.new_line("func accept(visitor): pass")\
		.add_line(2)\
		.done()
	
	create_file(base_name + '.gd' , writer)
	
	# The AST classes.
	for clas_name in types.keys():
		
		define_type(writer, base_name, clas_name, types[clas_name])
	
	

func create_file(_file_name, writer):
	
	var iou := IOUtil.new()
	
	iou.be(path)
	
	if not iou.file_exists(_file_name):
		iou.make_file(_file_name)
	
	var file = iou.open_file(_file_name)
	
	file.store_string(writer.text)
	file = ''
	iou.close_file()
	
	writer.clear()


func define_visitor(writer: TextWriter, base_name: String, types: Dictionary):
	
	for type_name in types.keys():
		
		writer.new_line('func visit_%s_%s(%s): pass' % [type_name.to_lower(), base_name.to_lower(), base_name.to_lower()]).done()
	


func define_type(writer: TextWriter, base_name: String, clas_name: String, field_list: Dictionary):
	writer.add('extends ' + base_name)\
		.new_line('class_name ' + clas_name)\
		.add_line()\
		.done()
	
	
	var vars := ''
	# Fields.
#	for i in field_list.size():
#
#		var key = field_list.keys()[i]
#
#		var variable = key
#
#		var type = field_list[key]
#
#		if type != '':
#			variable += ': %s' % type
#
#
#		vars += variable + (', 'if i != field_list.size()-1 else '')
#
#		variable = 'var ' + variable
#		writer.new_line(variable).done()
	
	for i in field_list.size():
		var key = field_list.keys()[i]
		
		vars += key + (', 'if i != field_list.size()-1 else '')
		writer.new_line('var ' + key).done()
	
	writer.add_line().done()
	
	# Constructor.
	writer.new_line("func _init(%s):" % str(vars))\
		.add_level()\
		.done()
	
	
	
	# Store parameters in fields.
	for key in field_list.keys():
		
		writer.new_line("self.%s = %s" % [key, key]).done()
	
	writer.sub_level().add_line().done()
	
	# Visitor pattern.
	writer.new_line("func accept(visitor):")\
		.add_level()\
		.new_line("return visitor.visit_%s_%s(self)" % [clas_name.to_lower(), base_name.to_lower()])\
		.done()
	
	create_file(clas_name + '.gd', writer)
	



class TextWriter:
	
	var text := ''
	var level := 0
	
	func add(_text = '') -> TextWriter:
		
		text += _text
		
		return self
	
	
	func new_line(_text = '') -> TextWriter:
		
		return add('\n' + tabs() + _text)
	
	
	func add_line(num: int = 1) -> TextWriter:
		
		var line = ''
		
		for i in num:
			line += '\n' + tabs()
		
		return add(line)
	
	
	func add_level(num: int = 1) -> TextWriter:
		
		level += num
		
		return self
	
	
	func sub_level(num: int = 1) -> TextWriter:
		
		level -= num
		
		return self
	
	
	func tabs() -> String:
		var tabs := ''
		
		for i in level:
			tabs += '\t'
		
		return tabs
	
	
	func done():
		pass
	
	
	func clear():
		text = ''
		level = 0
	
	
	







