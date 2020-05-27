extends Node

onready var lexer = $lexer
onready var parser = $parser

func compile():
	
	lexer.do()
	
#	return parser.do()
