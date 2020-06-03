extends Node


var struc := {
	'Binary': {
		'left': '',
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
#		[
#			"Binary   : Expr left, Token operator, Expr right",
#			"Grouping : Expr expression",                      
#			"Literal  : Object value",                         
#			"Unary    : Token operator, Expr right"            
#		],
		

func define_ast(output_dir: String,  base_name: String, types: Dictionary):

	var writer := TextWriter.new()
	
	writer.add('extends Object')\
		.new_line()\
		.new_line('class %s:' % base_name)\
		.add_level()\
		.new_line('func _init(): pass')\
		.sub_level()\
		.new_line()\
		.done()
	
	
	# The AST classes.
	for i in types.size():
#		var clas_name = type.split(":")[0]
#		var fields = type.split(":")[1]
		
		var clas_name = types.keys()[i]
		var fields = types.values()[i]
		
		define_type(writer, base_name, clas_name, fields)
	
	
	
	var path = 'res://%s/' % output_dir
	
	var iou := IOUtil.new()
	
	iou.be(path)
	
	var file = iou.open_file('%s.gd' % base_name)
	
	file.store_string(writer.text)
	file = ''
	iou.close_file()
	
	$TextEdit.text = writer.text
	

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
	
	
	writer.sub_level(2)\
		.new_line().new_line()\
		.done()




class TextWriter:
	
	var text := ''
	var level := 0
	
	func add(_text = '') -> TextWriter:
		
		text += _text
		
		return self
	
	
	func new_line(_text = '') -> TextWriter:
		
		return add('\n' + tabs() + _text)
	
	
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
	
	
	







