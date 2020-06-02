extends Node

onready var lexer = $lexer
onready var parser = $parser

func compile():
	
	Tester.start('lexing')
	
	lexer.do()
	
	Tester.stop()
	
#	return parser.do()
