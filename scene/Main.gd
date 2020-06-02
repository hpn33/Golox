extends Node


onready var update_label = $UI/HBoxContainer/L1/InputPart/VBox/bar/update/Label
onready var compile_time_label = $UI/HBoxContainer/L1/InputPart/VBox/bar/update/CompileTime
onready var update_progress = $UI/HBoxContainer/L1/InputPart/VBox/bar/update/Progress

onready var error_panel = $UI/HBoxContainer/ErrorPanel

onready var input = $UI/HBoxContainer/L1/InputPart/VBox/input

onready var output = $UI/HBoxContainer/L1/OutputPart/output

onready var timer = $Timer
onready var compile_time = $CompileTime

onready var processor = $processor


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
	
	Reader.init(input.text)
	
	processor.compile()
	
	output.text = Reader.output()


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

	input.text =\
"""// print 'hello world
hello
/*
print 'hello world'
*/"""

#	input.text = """print 'hello world"""
#	input.text = """12 \n10.10"""
	input.emit_signal("text_changed")


func _on_Compile_pressed() -> void:
	compile()
