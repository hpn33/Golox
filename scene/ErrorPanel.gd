extends VBoxContainer


onready var edit_text = $TextEdit


func _ready():
	
	ErrorHandler.connect("exporting", self, 'refresh')


func refresh(errors):
	
	edit_text.text = ''
	
	for error in errors:
		edit_text.text += error + '\n'
	
	
func clean():
	edit_text.text = ''
