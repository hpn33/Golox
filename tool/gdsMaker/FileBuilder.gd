class_name FileBuilder
extends GDBuilder

var claz_name := ''
var extend := ''

var vars := []

var constructorFunc : FuncBuilder

var funcs := []


func setClassName(cn: String) -> FileBuilder:
	claz_name = cn
	
	return self


func setExtends(cn: String) -> FileBuilder:
	extend = cn
	
	return self


func addVar(varing: VarBuilder) -> FileBuilder:
	vars.append(varing)
	
	return self


func setConstructor(constructor: FuncBuilder) -> FileBuilder:
	constructorFunc = constructor
	
	return self


func addFunc(fun: FuncBuilder) -> FileBuilder:
	funcs.append(fun)
	
	return self


func done() -> void: pass


func clear():
	claz_name = ''
	funcs.clear()


func build() -> String:
	var textWriter = TextWriter.new()
	
	
	#
	if extend != '':
		textWriter.add('extends %s' % [extend])
		if claz_name != '':
			textWriter.new_line()
	
	
	if claz_name != '':
		textWriter.add('class_name %s' % [claz_name])
	
	
	textWriter.add_line().done()
	
	
	# Vars
	for v in vars:
		textWriter.new_line(v.build())
	
	
	if constructorFunc:
		textWriter.add_line().done()
	
	
	# Constructor
	if constructorFunc:
		textWriter.new_line(constructorFunc.build())
		
		if len(funcs) != 0:
			textWriter.add_line().done()
	
	
	
	# Functions
	for f in funcs:
		textWriter.new_line(f.build())
	
	
	return textWriter.text


