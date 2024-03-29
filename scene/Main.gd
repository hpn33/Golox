extends Node


onready var update_label = $UI/HBoxContainer/L1/InputPart/VBox/bar/update/Label
onready var compile_time_label = $UI/HBoxContainer/L1/InputPart/VBox/bar/update/CompileTime
onready var update_progress = $UI/HBoxContainer/L1/InputPart/VBox/bar/update/Progress

onready var error_panel = $UI/HBoxContainer/ErrorPanel

onready var input = $UI/HBoxContainer/L1/InputPart/VBox/input

onready var output = $UI/HBoxContainer/L1/OutputPart/output

onready var timer = $Timer


func _ready() -> void:
	update_progress.max_value = timer.wait_time
	
	_on_SimpleText_pressed()

func _process(delta: float) -> void:
	update_label.text = str(timer.time_left)
	
	if timer.is_stopped():
		update_progress.value = 0
	else:
		update_progress.value = timer.wait_time - timer.time_left
	


func _on_input_text_changed() -> void:
	timer.start()






func compile():
	
	ErrorHandler.clear()
	error_panel.clean()
	
	
	Tester.start('-------')
	
	### compiling
	Tester.next('lexing')
	var tokens = LexerLox.new().do(input.text)
	
	Tester.next('parser')
	var statements = ParserLox.new().do(tokens)
	
	Tester.stop()
	### compiling
	
	
	if ErrorHandler.had_error:
		output.text = 'error exist.'
	
	else:
		
		Interpreter.new().interpret(statements); 
		
		if ErrorHandler.had_runtime_error:
			output.text = 'runtime error exist.'
		
#		else:
#			output.text = AstPrinter.new().ast_print(statements)
	
	


func _on_Timer_timeout() -> void:
	compile()

func _on_SimpleText_pressed() -> void:
#	input.text = """(){},.-+;*"""
#	input.text = """!!====<<=>>="""
#	input.text = """// hello\n/ /"""
#	input.text = """( ){\r}(\t)\n"""

#	input.text = \
#"""// this is a comment
#(( )){} // grouping stuff
#!*+-/=<> <= == // operators
#"""

	
#	input.text = """print 'hello world'\nprint 'hello world'"""
#	input.text = """print 'hello world\nprint 'hello world'"""

#	input.text =\
#"""// print 'hello world
#hello
#/*
#print 'hello world'
#*/"""

#	input.text = """print 'hello world"""
#	input.text = """12 \n10.10"""
#	input.text = """print('hello');"""
#	input.text = """1+(2+3)""" # expr test
#	input.text = """1+(2+3""" # with error
#	input.text = """1+(2 3)""" # with error
#	input.text = """1+(2+'hello')""" # with error
#	input.text = """2+2==-2+3""" 
#	input.text =\
#"""print 'one';
#print true;
#print 2 + 1;""" # with error
#	input.text =\
#"""var a = 'before';
#print a; // 'before'.
#var a = 'after';
#print a; // 'after'.
#""" # variable
	
#	input.text = """if (true) if (true) print('true'); else print('false');"""
	
#	input.text =\
#	"""
#	print \"hi\" or 2; // \"hi\".
#	print nil or \"yes\"; // \"yes\".
#	"""
	
	input.text = "for (var i = 0; i < 10; i = i + 1) print i;"
	
#	input.text =\
#	"""
#var a = 0;
#var b = 1;
#
#while (a < 10000) {
#  print a;
#  var temp = a;
#  a = b;
#  b = temp + b;
#}
#	"""
	
	input.emit_signal("text_changed")

