extends Node





func _ready():
	
	
	
	
	define_ast('core/ast', "Expr", [
		"Binary   : Expr left, Token operator, Expr right",
		"Grouping : Expr expression",                      
		"Literal  : Object value",                         
		"Unary    : Token operator, Expr right"            
		]
	)

func define_ast(output_dir: String,  base_name: String, types: Array):
	
	var path = 'res://%s/%s.gd' % [output_dir, base_name] 
	
#	PrintWriter writer = new PrintWriter(path, "UTF-8")

	var writer := TextWriter.new()
	
	writer.add('extends Object')\
		.new_line()\
		.new_line('class %s:'% base_name)\
		.done()
	
	
	# The AST classes.
	for type in types:
		var clas_name = type.split(":")[0]
		var fields = type.split(":")[1]
		define_type(writer, base_name, clas_name, fields)
	
	
	print('[\n%s\n]' % writer.text)
	

func define_type(writer: TextWriter, base_name: String, clas_name: String, field_list: String):
	writer.new_line("class %s: extends" % clas_name)\
		.add_level()\
		.new_line('extends %s' % base_name)\
		.done()
	
	# Constructor.
	writer.new_line("func _init(%s):" % field_list)\
		.done()
	
	# Store parameters in fields.
	var fields = field_list.split(", ")
	for field in fields:
		var nam = field.split(" ")[1]             
		
		writer.add_level()\
			.new_line("self.%s = %s" % [nam, nam]).done()
	
	writer.new_line().sub_level()
	
	# Fields.
	for field in fields:
		writer.new_line("var %s" % field).done()
	
	
	writer.sub_level()




class TextWriter:
	
	var text := ''
	var level := 0
	
	func add(_text = '') -> TextWriter:
		
		text += tabs() + _text
		
		return self
	
	
	func new_line(_text = '') -> TextWriter:
		
		return add('\n' + _text)
	
	
	func add_level() -> TextWriter:
		
		level += 1
		
		return self
	
	
	func sub_level() -> TextWriter:
		
		level -= 1
		
		return self
	
	
	func tabs():
		var tabs := ''
		
		for i in level:
			tabs += '\t'
		print('[%s]' % tabs)
		return tabs
	
	
	func done():
		pass
	
	
	func clear():
		text = ''
		level = 0
	
	
	







