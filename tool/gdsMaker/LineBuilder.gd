class_name LineBuilder
extends GDBuilder


var line := ''


func setLine(text: String) -> LineBuilder:
	line = text
	
	return self


func done() -> void: pass
