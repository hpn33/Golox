class_name FuncBuilder
extends GDBuilder

var nam := ''
var args := []
var funcBody := []

var spaceTop = false
var spaceBottom = false


func setName(n) -> FuncBuilder:
	nam = n
	
	return self


func setArg(arg) -> FuncBuilder:
	args.append(arg)
	
	return self


func setArgs(args) -> FuncBuilder:
	for arg in args:
		setArg(arg)
	
	return self


func setPass() -> FuncBuilder:
	funcBody.clear()
	
	return self


func addToBody(body) -> FuncBuilder:
	funcBody.append(body)
	
	return self


func spaceTop() -> FuncBuilder:
	spaceTop = true
	
	return self


func spaceBottom() -> FuncBuilder:
	spaceBottom = true
	
	return self


func done(): pass


func build() -> String:
	var textWriter = TextWriter.new()
	
	if spaceTop:
		textWriter.add_line().done()
	
	# Set Vars
	var argss := ''
	
	for arg in args:
		argss += arg
	
	textWriter.add('func %s(%s):' % [nam, argss]).done()
	
	if len(funcBody) == 0:
		textWriter.add(' pass').done()
		
		if spaceBottom:
			textWriter.add_line(2).done()
		
		return textWriter.text
	
	
	
	textWriter.add_level().done()
	
	
	# Body
	for b in funcBody:
		if b is String:
			textWriter.new_line(b)
		else:
			textWriter.new_line(b.build())
	
	
	return textWriter.text

