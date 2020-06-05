extends Node

var _time_before = 0
var _for_time = 0
var _test_name = ""





func start(_name := ""):
	_test_name = _name
	_time_before = OS.get_ticks_msec()


func next(_name := ''): # -> float:
	var time = stop()
	start(_name)
	
#	return time


func stop(): # -> float:
	var time = OS.get_ticks_msec() - _time_before
	if _test_name.length() != 0:
		var test_time = time - _for_time
		
		print("[%s:\t%d]" % [ _test_name, test_time])# + " (with for: " + str(time) + ")")
	
#	return time
