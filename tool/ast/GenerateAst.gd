extends Node


#		[
#			"Binary   : Expr left, Token operator, Expr right",
#			"Grouping : Expr expression",                      
#			"Literal  : Object value",                         
#			"Unary    : Token operator, Expr right"            
#		],
var struc := {
	'Binary': {
		'left': 'Expr',
		'operator': 'Token',
		'right': 'Expr'
	},
	'Grouping': {
		'expression': 'Expr'
	},
	'Literal': {
		'value': ''
	},
	'Unary': {
		'operator': 'Token',
		'right': 'Expr' 
	}
}


func _ready():
	
	
	
	
	define_ast('core/ast', "Expr", struc)
	

func define_ast(output_dir: String,  base_name: String, types: Dictionary):

	var writer := TextWriter.new()
	
	writer.add('extends Object')\
		.add_line(2)\
		.new_line('class %s:' % base_name)\
		.add_level()\
		.add_line()\
		.new_line('func _init(): pass')\
		.add_line()\
		.sub_level()\
		.done()
	
	define_visitor(writer, base_name, types)
	
	
	# The base accept() method.
	writer.add_level()\
		.add_line()\
		.new_line("func accept(visitor): pass")\
		.sub_level()\
		.done()
	
	writer.add_line(2).done()
	
	# The AST classes.
	for clas_name in types.keys():
		
		define_type(writer, base_name, clas_name, types[clas_name])
	
	
	
	var path = 'res://%s/' % output_dir
	
	var iou := IOUtil.new()
	
	iou.be(path)
	
	var file = iou.open_file('%s.gd' % base_name)
	
	file.store_string(writer.text)
	file = ''
	iou.close_file()
	
	$TextEdit.text = writer.text
	


func define_visitor(writer: TextWriter, base_name: String, types: Dictionary):
	
	writer.add_level()
	
	for type_name in types.keys():
		
		writer.new_line('func visit_%s_%s(%s: %s): pass' % [type_name, base_name, base_name.to_lower(), type_name])
	
	writer.sub_level()


func define_type(writer: TextWriter, base_name: String, clas_name: String, field_list: Dictionary):
	writer.new_line("class %s:" % clas_name)\
		.add_level()\
		.new_line('extends %s' % base_name)\
		.new_line()\
		.done()
	
	
	var vars := ''
	# Fields.
#	var fields = field_list.split(", ")
	for i in field_list.size():
		
		var key = field_list.keys()[i]
		
		var variable = key
		
		var type = field_list[key]
		
		if type != '':
			variable += ': %s' % type
		
		
		field_list.size()
		vars += variable + (', 'if i != field_list.size()-1 else '')
		
		variable = 'var ' + variable
		writer.new_line(variable).done()
	
	writer.new_line().done()
	
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
		.new_line("return visitor.visit_%s_%s(self)" % [clas_name, base_name])\
		.sub_level(2)\
		.add_line(2)\
		.done()



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
	
	
	







