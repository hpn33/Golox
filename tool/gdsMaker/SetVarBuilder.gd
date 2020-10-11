class_name SetVarBuilder
extends GDBuilder


var right := ''
var left := ''


func setRightLeft(right: String, left: String) -> SetVarBuilder:
	self.right = right
	self.left = left
	
	return self


func done() -> void: pass


func build() -> String:
	return '%s = %s' % [right, left]
