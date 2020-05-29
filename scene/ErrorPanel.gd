extends VBoxContainer


onready var edit_text = $TextEdit

var outputs := []


# Called when the node enters the scene tree for the first time.
func _ready():
	
	ErrorHandler.connect("exporting", self, 'refresh')
	pass # Replace with function body.


func refresh(errors):
	outputs += errors
	
	edit_text.text = str(outputs)
