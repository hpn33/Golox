extends LexerBase
class_name LexerGen



var _actions := [
	LexerAction.WhiteSpaceAction.new(),
	
	LexerAction.IdentifierAction.new(),
	
	ArrowAction.new(),
	
	LexerAction.NextLineAction.new(),
	
	LexerAction.StringAction.new(),
	
	LexerAction.NumberAction.new(),
	
	LexerAction.SingleLetterAction.new(),
	LexerAction.OperatorsAction.new(),
	
]



func get_actions() -> Array:
	return _actions





class ArrowAction:
	
	func check(c):
		return c == '-'
	
	func lex(lexer, letter):
		
		if lexer.match('>'):
			lexer.add_token_literal('->', lexer.selected_text())
		
		
		
	
