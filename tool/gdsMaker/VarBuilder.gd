class_name VarBuilder
extends GDBuilder


var nam := ''
var type := ''


func setName(n: String) -> VarBuilder:
	nam = n
	
	return self


func setType(n: String) -> VarBuilder:
	type = n
	
	return self


func done() -> void: pass


func build() -> String:
	var text = 'var %s' % [nam]
	
	if type != '':
		text += ': %s' % [type]
	
	return text
