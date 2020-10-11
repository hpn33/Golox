class_name ClassBuilder
extends GDBuilder

var nam
var funcs = []

func addFunc(fun: FuncBuilder) -> ClassBuilder:
	funcs.append(fun)
	
	return self


func done(): pass


